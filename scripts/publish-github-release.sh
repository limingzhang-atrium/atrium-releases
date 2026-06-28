#!/usr/bin/env bash
# 从 dist/<tag> 发布 GitHub Release assets。
# 这个脚本只发布当前仓库中已准备好的 Release 资产，不生成安装包。
set -euo pipefail

# resolve_root 负责把脚本位置解析为公开发布仓库根目录，避免从不同 cwd 调用时路径漂移。
resolve_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

# print_usage 输出可执行入口说明；参数错误时用于给出最小可操作提示。
print_usage() {
  cat <<'USAGE'
Usage:
  bash scripts/publish-github-release.sh --tag snapshot-latest
  bash scripts/publish-github-release.sh --tag v0.1.0

Options:
  --tag TAG          Release tag to publish. Default: snapshot-latest
  --repo OWNER/REPO  GitHub repo. Default: limingzhang-atrium/atrium-releases
  --dist-dir PATH    Dist root. Default: dist
  --dry-run          Validate files and print the gh operations without uploading.
USAGE
}

ROOT_DIR="$(resolve_root)"
TAG="snapshot-latest"
GITHUB_REPO="limingzhang-atrium/atrium-releases"
DIST_ROOT="$ROOT_DIR/dist"
DRY_RUN=0
CHANGELOG_FILE="$ROOT_DIR/CHANGELOG.md"

# gh_with_retry 对 GitHub API 偶发 EOF/SSL 中断做少量重试；非网络错误仍会按原退出码失败。
gh_with_retry() {
  local attempt=1
  local max_attempts=3
  local status=0
  while true; do
    "$@" && return 0
    status=$?
    if [[ "$attempt" -ge "$max_attempts" ]]; then
      return "$status"
    fi
    echo "[publish-github] gh command failed, retrying (${attempt}/${max_attempts}) ..." >&2
    sleep "$attempt"
    attempt=$((attempt + 1))
  done
}

# extract_changelog_section 从 CHANGELOG.md 中抽取与 tag 匹配的二级标题段落。
# 支持 `## v0.11.0`、`## 0.11.0`、`## [v0.11.0] - 2026-06-28` 等常见写法；找不到时不阻断发布。
extract_changelog_section() {
  local tag="$1"
  local version="${tag#v}"
  [[ -f "$CHANGELOG_FILE" ]] || return 1
  awk -v tag="$tag" -v version="$version" '
    function trim(value) {
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
      return value
    }
    function heading_matches(line) {
      line = trim(line)
      sub(/^##[[:space:]]+/, "", line)
      return line == tag || line == version ||
        line ~ "^\\[" tag "\\]" || line ~ "^\\[" version "\\]" ||
        line ~ "^" tag "([[:space:]]|-|$)" || line ~ "^" version "([[:space:]]|-|$)"
    }
    /^##[[:space:]]+/ {
      if (in_section) exit
      if (heading_matches($0)) {
        in_section = 1
        found = 1
        next
      }
    }
    in_section { print }
    END { if (!found) exit 1 }
  ' "$CHANGELOG_FILE"
}

# 解析发布参数；真正要发布哪个版本由 dist/<tag> 决定。
while [[ $# -gt 0 ]]; do
  case "$1" in
    --tag)
      TAG="${2:-}"
      shift 2
      ;;
    --tag=*)
      TAG="${1#--tag=}"
      shift
      ;;
    --repo)
      GITHUB_REPO="${2:-}"
      shift 2
      ;;
    --repo=*)
      GITHUB_REPO="${1#--repo=}"
      shift
      ;;
    --dist-dir)
      DIST_ROOT="$(cd "${2:-}" && pwd)"
      shift 2
      ;;
    --dist-dir=*)
      DIST_ROOT="$(cd "${1#--dist-dir=}" && pwd)"
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo "[publish-github] unknown argument: $1" >&2
      print_usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$TAG" ]]; then
  echo "[publish-github] --tag is required" >&2
  exit 1
fi

STAGE_DIR="$DIST_ROOT/$TAG"
NOTES_FILE="$STAGE_DIR/RELEASE_NOTES.md"
MANIFEST_FILE="$STAGE_DIR/Atrium-${TAG}-manifest.json"
RELEASE_TITLE="$TAG"
CREATE_FLAGS=()
EDIT_FLAGS=()
PUBLISH_NOTES_FILE="$NOTES_FILE"
TMP_NOTES_FILE=""

if [[ "$TAG" == "snapshot-latest" ]]; then
  CREATE_FLAGS=(--latest)
  EDIT_FLAGS=(--prerelease=false --latest)
elif [[ "$TAG" == snapshot* ]]; then
  CREATE_FLAGS=(--prerelease --latest=false)
  EDIT_FLAGS=(--prerelease --latest=false)
else
  CREATE_FLAGS=(--latest)
  EDIT_FLAGS=(--prerelease=false --latest)
fi

if [[ ! -d "$STAGE_DIR" ]]; then
  echo "[publish-github] missing staged directory: $STAGE_DIR" >&2
  exit 1
fi

if [[ ! -f "$NOTES_FILE" ]]; then
  echo "[publish-github] missing release notes: $NOTES_FILE" >&2
  exit 1
fi

if [[ ! -f "$MANIFEST_FILE" ]]; then
  echo "[publish-github] missing manifest: $MANIFEST_FILE" >&2
  exit 1
fi

ASSETS=()
while IFS= read -r asset_path; do
  ASSETS+=("$asset_path")
done < <(find "$STAGE_DIR" -maxdepth 1 -type f ! -name 'RELEASE_NOTES.md' -print | sort)
if [[ "${#ASSETS[@]}" -eq 0 ]]; then
  echo "[publish-github] no assets found in $STAGE_DIR" >&2
  exit 1
fi

echo "[publish-github] repo=$GITHUB_REPO"
echo "[publish-github] tag=$TAG"
echo "[publish-github] stage=$STAGE_DIR"
echo "[publish-github] assets:"
printf '  %s\n' "${ASSETS[@]}"

# GitHub Release body 以已准备好的 release notes 为主，再附加 CHANGELOG.md 中对应版本段落；
# 这样仓库首页保留完整 changelog，Release 页面也能直接看到该版本变更。
if CHANGELOG_SECTION="$(extract_changelog_section "$TAG")" && [[ -n "${CHANGELOG_SECTION//[[:space:]]/}" ]]; then
  TMP_NOTES_FILE="$(mktemp)"
  cat "$NOTES_FILE" > "$TMP_NOTES_FILE"
  {
    printf '\n### Changelog\n\n'
    printf '%s\n' "$CHANGELOG_SECTION"
  } >> "$TMP_NOTES_FILE"
  PUBLISH_NOTES_FILE="$TMP_NOTES_FILE"
  echo "[publish-github] appended changelog section for $TAG"
else
  echo "[publish-github] no matching changelog section for $TAG; using prepared release notes only"
fi

cleanup() {
  [[ -n "$TMP_NOTES_FILE" ]] && rm -f "$TMP_NOTES_FILE"
  return 0
}
trap cleanup EXIT

if [[ "$DRY_RUN" == "1" ]]; then
  echo "[publish-github] dry run only; no GitHub changes made"
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  cat >&2 <<'GH_MISSING'
[publish-github] gh CLI is required for uploading GitHub Release assets.
Install and login:
  brew install gh
  gh auth login
GH_MISSING
  exit 1
fi

# GitHub Release 不支持同名 asset 覆盖，先删除旧 asset，再上传本次发布文件。
if gh_with_retry gh release view "$TAG" --repo "$GITHUB_REPO" >/dev/null 2>&1; then
  echo "[publish-github] release exists, replacing assets on $TAG ..."
else
  echo "[publish-github] creating release $TAG ..."
  CREATE_ERROR="$(mktemp)"
  if ! gh_with_retry gh release create "$TAG" \
    --repo "$GITHUB_REPO" \
    --title "$RELEASE_TITLE" \
    --notes-file "$PUBLISH_NOTES_FILE" \
    "${CREATE_FLAGS[@]}" 2>"$CREATE_ERROR"; then
    if grep -qiE 'tag_name already exists|already exists' "$CREATE_ERROR"; then
      echo "[publish-github] release already exists remotely, continuing with asset replacement ..."
    else
      cat "$CREATE_ERROR" >&2
      rm -f "$CREATE_ERROR"
      exit 1
    fi
  fi
  rm -f "$CREATE_ERROR"
fi

gh_with_retry gh release upload "$TAG" "${ASSETS[@]}" --repo "$GITHUB_REPO" --clobber

# 已存在 release 时同步更新说明，确保 checksum 与 latest asset 一致。
gh_with_retry gh release edit "$TAG" \
  --repo "$GITHUB_REPO" \
  --title "$RELEASE_TITLE" \
  --notes-file "$PUBLISH_NOTES_FILE" \
  "${EDIT_FLAGS[@]}"

echo "[publish-github] done:"
echo "https://github.com/${GITHUB_REPO}/releases/tag/${TAG}"

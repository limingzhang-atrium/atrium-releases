# Download Channels / 下载通道

Atrium release packages are distributed through GitHub Release assets. Installer files should not be committed directly to this repository.

Atrium 发布包通过 GitHub Release assets 分发。安装包不应直接提交到本仓库。

GitHub Release assets do not provide a real directory hierarchy, so Atrium uses release tags, release channels, and package filenames to keep downloads organized.

GitHub Release assets 没有真正的目录层级，因此 Atrium 使用 release tag、发布通道和包文件名来组织下载。

GitHub automatically adds `Source code (zip)` and `Source code (tar.gz)` to every release. These archives contain only this public `atrium-releases` repository, not the private Atrium source code. Users should download the `.dmg` or `.app.zip` installer assets.

GitHub 会自动为每个 Release 添加 `Source code (zip)` 和 `Source code (tar.gz)`。这些压缩包只包含本公开 `atrium-releases` 仓库，不包含 Atrium 私有源代码。用户应下载 `.dmg` 或 `.app.zip` 安装包。

## Stable Releases / 稳定版

Stable releases are for normal users.

稳定版面向普通用户。

- Release type: normal GitHub Release
- Tag format: `vMAJOR.MINOR.PATCH`, for example `v0.1.0`
- Latest stable URL: `https://github.com/limingzhang-atrium/atrium-releases/releases/latest`
- Package files are permanent and should not be replaced after publishing.

- 发布类型：普通 GitHub Release
- Tag 格式：`vMAJOR.MINOR.PATCH`，例如 `v0.1.0`
- 最新稳定版地址：`https://github.com/limingzhang-atrium/atrium-releases/releases/latest`
- 包文件发布后应保持稳定，不应覆盖替换。

Recommended asset names:

推荐文件名：

```text
Atrium-v0.1.0-macos-arm64.dmg
Atrium-v0.1.0-macos-arm64.app.zip
Atrium-v0.1.0-macos-arm64.dmg.sha256
Atrium-v0.1.0-macos-arm64.app.zip.sha256
```

## Snapshot Releases / Snapshot 测试版

Snapshot releases are for quick verification, dogfood, and sharing a build before the next stable version.

Snapshot 用于快速验证、dogfood，以及在下一个稳定版之前分享临时构建。

- Release type: GitHub Prerelease
- Tag format: `snapshot-YYYYMMDD-HHMM`, for example `snapshot-20260625-2215`
- Snapshot releases may be deleted later when they are no longer useful.
- Snapshot builds may be less stable than normal releases.

- 发布类型：GitHub Prerelease
- Tag 格式：`snapshot-YYYYMMDD-HHMM`，例如 `snapshot-20260625-2215`
- Snapshot release 以后可以按需删除。
- Snapshot 构建可能没有普通稳定版可靠。

Recommended asset names:

推荐文件名：

```text
Atrium-snapshot-20260625-2215-macos-arm64.dmg
Atrium-snapshot-20260625-2215-macos-arm64.app.zip
Atrium-snapshot-20260625-2215-macos-arm64.dmg.sha256
Atrium-snapshot-20260625-2215-macos-arm64.app.zip.sha256
```

## Rolling Latest Snapshot / 滚动最新版 Snapshot

If a fixed snapshot download URL is needed, maintain one mutable prerelease named `snapshot-latest`.

如果需要一个固定的 snapshot 下载地址，可以维护一个可覆盖的 prerelease：`snapshot-latest`。

- Release type: GitHub Prerelease
- Tag: `snapshot-latest`
- Asset names should stay fixed.
- Old assets should be deleted before uploading new assets with the same filenames.
- This channel is intentionally mutable and should not be used for reproducible release history.

- 发布类型：GitHub Prerelease
- Tag：`snapshot-latest`
- 文件名保持固定。
- 上传同名新包前，先删除旧 asset。
- 这个通道是有意可变的，不用于可复现的版本历史。

Recommended asset names:

推荐文件名：

```text
Atrium-snapshot-latest-macos-arm64.dmg
Atrium-snapshot-latest-macos-arm64.app.zip
Atrium-snapshot-latest-macos-arm64.dmg.sha256
Atrium-snapshot-latest-macos-arm64.app.zip.sha256
```

Fixed download URL examples:

固定下载地址示例：

```text
https://github.com/limingzhang-atrium/atrium-releases/releases/download/snapshot-latest/Atrium-snapshot-latest-macos-arm64.dmg
https://github.com/limingzhang-atrium/atrium-releases/releases/download/snapshot-latest/Atrium-snapshot-latest-macos-arm64.app.zip
```

## Package Metadata / 包元数据

Each release should include a short release note with:

每次发布建议在 release note 中包含：

- Version or snapshot tag
- Build date
- Platform and architecture
- Major changes
- Known issues
- SHA-256 checksum

- 版本或 snapshot tag
- 构建日期
- 平台和架构
- 主要变化
- 已知问题
- SHA-256 校验值

If a separate metadata file is needed, use:

如需单独提供元数据文件，可使用：

```text
Atrium-v0.1.0-manifest.json
Atrium-snapshot-20260625-2215-manifest.json
Atrium-snapshot-latest-manifest.json
```

Suggested manifest fields:

推荐 manifest 字段：

```json
{
  "name": "Atrium",
  "version": "0.1.0",
  "channel": "stable",
  "buildDate": "2026-06-25",
  "platform": "macos",
  "arch": "arm64",
  "file": "Atrium-v0.1.0-macos-arm64.dmg",
  "sha256": ""
}
```

# AGENTS.md

本文件是 `atrium-releases` 公开发布仓库供 Codex、Claude Code 等编码 agent 共用的开发指引。该仓库只承载公开下载材料和 GitHub Release 资产说明。

## 公开发布红线

- **禁止泄露用户电脑信息、非公开项目信息、打包流程**：任何提交到本仓库的 README、CHANGELOG、docs、脚本注释、release notes、manifest、checksum 旁注和 GitHub Release 文案，都不得包含本机用户名、绝对路径、工作区结构、非公开仓库位置、构建脚本调用链、打包命令、临时产物目录、内部发布步骤或维护者专用流程。
- **公开文案只写用户视角结果**：可说明“请下载 `.dmg` / `.app.zip` 安装包”“GitHub 自动生成的 Source code 不是 Atrium 安装包”“包含 SHA-256 校验”，不得说明安装包如何生成、转移或发布。
- **发布前必须做泄露检查**：发布、提交或修改公开材料前，必须检查是否出现本机路径、非公开仓库名称或位置、维护者命令、临时产物目录、内部步骤、打包链路等内容；命中后必须先改成用户可见、非内部流程表述。

## 仓库边界

- 安装包只作为 GitHub Release assets 分发，不提交到 git 历史。
- GitHub 自动生成的 `Source code (zip)` 和 `Source code (tar.gz)` 不是 Atrium 安装包，公开说明应引导用户下载 `.dmg` 或 `.app.zip`。
- 本仓库不记录内部构建、打包、转移、发布执行流程；相关操作只在非公开维护上下文中进行。

## Git 约束

- AI agent 严禁未经用户明确确认就执行 `git add`、`git commit`、`git tag`、`git push` 或发布 GitHub Release。
- 如需暂存文件，必须精确列出文件名，禁止 `git add -A`。

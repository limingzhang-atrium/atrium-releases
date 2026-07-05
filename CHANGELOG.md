# Changelog / 更新日志

All notable public release changes for Atrium will be documented in this file.

Atrium 的重要公开发布变更会记录在此文件中。

## Unreleased / 未发布

- No unreleased public changes yet.
- 暂无未发布的公开变更。

## v0.14.0 - 2026-07-05

- Added context window usage indicators for Claude and Codex participants, with compact usage summaries and detail popovers.
- Improved Claude `/compact` handling so successful compaction can update context usage even when no text reply is produced.
- Improved the participant panel layout so context usage remains readable when an agent is offline and recovery actions are shown.
- Updated the desktop app release version to `0.14.0`.
- 新增 Claude 和 Codex 参与者的上下文窗口使用量展示，包含紧凑摘要和明细弹窗。
- 改进 Claude `/compact` 处理：即使压缩成功后没有文本回复，也能更新上下文使用量。
- 优化参与者面板布局，agent 离线并展示恢复操作时，上下文使用量仍能正常阅读。
- 将桌面 app release 版本更新为 `0.14.0`。

## v0.13.0 - 2026-06-30

- Improved `@` completion in the chat composer so roles and workspace files are discoverable in one menu.
- Made role suggestions more compact, so file suggestions appear sooner without extra scrolling.
- Improved workspace file discovery when ignored, missing, or broken linked files are encountered.
- Updated the desktop app release version to `0.13.0`.
- 优化聊天输入框的 `@` 补全，在同一个菜单中展示角色和工作区文件入口。
- 压缩角色候选行高，让文件候选更早出现，减少滚动。
- 改进工作区文件发现逻辑，遇到缺失或失效链接时仍尽量展示已找到的文件。
- 将桌面 app release 版本更新为 `0.13.0`。

## v0.12.0 - 2026-06-28

- Added a confirmation prompt before ending a meeting, clarifying that ended meetings cannot continue chatting.
- Expanded the public README with clearer product positioning, target users, requirements, platform limits, and usage boundaries.
- 结束会议前新增二次确认，并明确会议结束后无法继续对话。
- 扩充公开 README，补充产品定位、适用人群、前置依赖、平台限制和使用边界。

## v0.11.0 - 2026-06-28

- Added the first public macOS release package channel for Atrium.
- Added release metadata, SHA-256 checksum assets, and public download documentation.
- Clarified that GitHub automatic source archives are not Atrium installers.
- Added trademark and independence notices for third-party provider names and logos.
- Set the desktop app release version to `0.11.0`.
- Hid maintainer-only interface areas by default in public releases.
- 新增 Atrium 首个公开 macOS 安装包分发通道。
- 添加 release 元数据、SHA-256 校验文件和公开下载说明。
- 添加第三方 provider 名称与 logo 的商标及独立性声明。
- 将桌面 app release 版本设置为 `0.11.0`。
- 公开发布版本默认隐藏维护者专用界面入口。

## Repository Setup / 仓库初始化

- Initial public release repository setup.
- Added public download, license, and changelog materials.
- Added stable and snapshot download channel documentation.
- Clarified that GitHub automatic source archives are not Atrium installers.
- Removed maintainer-only publishing instructions from public documentation.
- 初始化公开发布仓库。
- 添加公开下载说明、专有软件许可和更新日志。
- 添加稳定版和 snapshot 下载通道说明。
- 说明 GitHub 自动生成的 source archives 不是 Atrium 安装包。
- 从公开文档中移除仅维护者需要的发布流程说明。

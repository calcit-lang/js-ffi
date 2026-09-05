# Correct release provenance and gates / 修正发布来源与门禁

Recorded at / 记录时间: 2026-09-05 06:37 UTC

## 中文

- 从当前 `main` 重新应用 PR #12 所要求的 Calcit 0.13.77 来源说明，明确区分正式 tag 源码与本地验证 artifact，并记录精确 revision、补丁路径及验证结果。
- 将 workflow 的 checkout、Node setup 与 Calcit setup Actions 固定到已验证的精确正式 tag。
- 在 CI 中强制执行 strict Caps、Calcit/JavaScript runtime 工具链一致性与既有 unsafe-boundary inventory 门禁。
- 不修改 Calcit Snapshot、源码、API、依赖版本、模块版本或运行行为。

## English

- Reapply the provenance correction requested on PR #12 from current `main`, distinguishing the official Calcit 0.13.77 tag source from the local validation artifact and recording exact revisions, patch paths, and validation results.
- Pin checkout, Node setup, and Calcit setup Actions to verified exact public release tags.
- Enforce strict Caps, Calcit/JavaScript runtime toolchain consistency, and the existing unsafe-boundary inventory in CI.
- Keep the Calcit Snapshot, source, APIs, dependency versions, module version, and runtime behavior unchanged.

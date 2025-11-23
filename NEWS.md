# News

## 2025年11月23日 从单一包迁移至 Monorepo 架构

我现在有一个功能庞杂的 `cailab.utils` R 包，内含文献、引物、LLM、Zotero、扩增子、统计绘图等所有功能。目标是将其无损拆分为多个子包（如 `cailab.biblio`, `cailab.primer` 等），并重构主包 `cailab.utils` 为轻量聚合器 —— 所有代码保留在同一 Git 仓库（Monorepo）中。

- 子包的信息保存在 `cailab.utils` 主包里面的 `inst/cailab-meta.yml` 文件中。
- 使用 `dev/create-from-meta.R` 可以新建一系列的子包框架到 `packages` 文件夹下面。
- 使用 `proj_set("packages/cailab.amplicon")` 可以将子包设为活动开发对象。
- 加入 `.github/workflows/sync-cailab-amplicon.yml` 可将发布的子包同步到一个独立的仓库 `cailab.amplicon` 下面。



# LazyVim 配置中文指南

## 目录结构与基础约定

- `init.lua` 只做 LazyVim 启动与 `lua/config`、`lua/plugins` 的引导，保持精简确保启动速度。
- 全局选项、键位、自动命令分别放在 `lua/config/options.lua`、`lua/config/keymaps.lua`、`lua/config/autocmds.lua`。
- 每个插件或主题放在独立的 `lua/plugins/*.lua`，便于按需启用或替换；`lazy-lock.json` 记录插件锁定版本，变更后要提交。
- 自定义运行任务模板位于 `lua/overseer/template`，在 `lua/plugins/overseer.lua` 中统一注册。
- Lua 代码用 `stylua lua` 统一格式化（2 空格缩进、120 列上限），新文件沿用这一风格。

## 插件与能力速览

| 插件                              | 功能                                                                   | 备注                                                                                          |
| --------------------------------- | ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `akinsho/toggleterm.nvim`         | 多终端管理，含浮窗、lazygit、手动命令、`codex` 专用终端 (`<leader>jc`) | 自定义 `new_float_terminal` 工厂 + TermOpen 键位绑定                                          |
| `CRAG666/code_runner.nvim`        | 依据文件类型运行当前文件/项目 (`<leader>jr/jF/jp`)                     | 预设 Python/Node/Go/Rust/C/C++ 模板                                                           |
| `michaelb/sniprun`                | 选区/文件快速执行 (`<leader>jR/jC`)                                    | 输出以 VirtualText 呈现                                                                       |
| `stevearc/overseer.nvim`          | 统一任务运行器                                                         | 自动加载 `run_current_file`、`run_single_translation_unit`、`get-compile-command-json` 等模板 |
| `theHamsta/nvim-dap-virtual-text` | DAP 变量虚拟文本并在结束后清理                                         | 在 terminate/exit/disconnect 钩子中刷新                                                       |
| `zbirenbaum/copilot.lua`          | 只启用行内提示，面板禁用                                               | 自定义按键 `<C-l>` 接受、`<M-]>/<M-[>` 切换                                                   |

如需查询完整插件树，可阅读 `lua/plugins` 与 `lazy-lock.json`。

## 个性化配置亮点

- **编辑体验**：开启软换行 (`wrap` + `linebreak` + `breakindent`)、基础 `scrolloff=10`/`sidescrolloff=8`，默认四空格缩进。
- **自动保存**：`lazyvim_autosave_on_leave` 组在 `BufLeave` 或 `FocusLost` 时静默写入普通缓冲区，确保终端切换或任务运行前保存文件。
- **便捷键位**：`g9/g0` 映射跳转历史，插入模式 `jk` 逃离；`toggleterm` 相关 `<leader>j?` 前缀统一管理所有运行类动作。
- **运行任务**：Overseer 模板覆盖脚本文件、C/C++ 单翻译单元和 `compile_commands.json` 生成，默认带有 quickfix 集成。

## 构建、验证与排障

- `nvim --headless "+Lazy! sync" +qa`：安装/同步插件。
- `nvim --headless "+Lazy! check" +qa`：检测插件仓库、更新提示与健康状态。
- `nvim --clean --headless "+checkhealth" +qa`：验证 Python/Node/剪贴板等核心依赖。
- 若 DAP、Overseer 或运行类插件异常，优先在浮窗终端或 Overseer 面板复现；必要时执行 `:Lazy profile` 评估性能。

## 与 Codex 协作的常见请求

- **功能 → 插件**：描述你想要的能力（如“想在浮窗里打开 git TUI”），Codex 优先从上表/`lua/plugins` 找到已存在插件（例如 toggleterm + lazygit 入口），若无则建议候选插件与集成方式。
- **插件 → 功能**：直接抛出插件名或文件（如“讲一下 `code_runner.nvim` 这块”），Codex 应说明它在本仓库的用途、键位、配置入口，并指出如何扩充 filetype/opts。
- **Bugfix**：说明症状或报错位置后，Codex 需先运行最贴近问题的验证命令（如重放 keymap、调用 `:messages`、执行 `:OverseerRun`），然后对相关 Lua 文件提出修复计划，必要时演示如何使用 `stylua`/headless nvim 复测。
- **进一步定制**：无论是新插件、增删键位还是扩展 Overseer 模板，Codex 应建议所需文件（通常在 `lua/plugins/*.lua` 或 `lua/config/*`）、说明依赖项，并在答复中给出可以直接复制的最小片段。复杂需求可拆分为多条 PR/commit。

## Bugfix/增强流程建议

1. 复现：利用上述 headless 命令或 `<leader>j?` 系列确认现象。
2. 定位：`rg` 搜索相关键位/命令，查阅 `lua/plugins` 对应文件。
3. 修复：在相应模块内调整配置或补充新函数，保持局部 `local` 作用域与 2 空格缩进。
4. 验证：重复复现步骤，必要时在 `nvim --clean -u init.lua` 中测试新插件。

## 提交与协作

- commit 信息使用祈使句、60 字符内（例：“完善 toggleterm 终端管理”），正文写明动机与副作用。
- 多项修改拆分提交，便于回溯；涉及 UI 的更新可附截图/终端输出。
- PR 描述需包含：变更摘要、手动验证命令列表、潜在风险或后续工作。

本指南旨在帮助任何阅读 `AGENTS.md` 的 Codex/协作者快速了解本 LazyVim 配置的插件选择、个性化细节，以及在获取功能、插件、Bugfix 与进一步定制化需求时应该如何响应。\*\*\*

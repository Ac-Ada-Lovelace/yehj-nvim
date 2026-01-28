# Neovim 配置问题说明文档

本文档记录了当前 nvim 配置中发现的问题及改进建议。

---

## 1. 废弃 API 使用

**位置**: `lua/config/autocmds.lua:27`

**问题代码**:
```lua
vim.api.nvim_buf_get_option(buf, "modified")
```

**说明**: `nvim_buf_get_option` 在 Neovim 0.10+ 中已标记为废弃。推荐使用 `vim.bo[buf].modified` 替代，这是更现代且简洁的写法。

---

## 2. 硬编码路径

**位置**: `lua/plugins/osc52.lua:24`

**问题代码**:
```lua
local candidates = {
  "/mnt/c/Users/YehJ/AppData/Local/Microsoft/WinGet/Links/win32yank.exe",
}
```

**说明**: 此路径仅适用于当前用户的 Windows 环境。如果在其他机器上使用此配置，或 Windows 用户名不同，该路径将失效。建议仅依赖 `win32yank.exe` 存在于 PATH 中，或使用环境变量动态构建路径。

---

## 3. LazyVim Extras 膨胀调查报告

### 3.1 概述

当前配置在 `lazyvim.json` 中启用了 **56 个 extras**，这可能导致：
- 启动时间增加
- 内存占用上升
- LSP/工具链安装负担
- 潜在的插件冲突

### 3.2 已启用 Extras 分类

#### AI 相关 (1个)
| Extra | 说明 |
|-------|------|
| `ai.claudecode` | Claude Code 集成 |

#### 编码增强 (6个)
| Extra | 说明 | 使用频率评估 |
|-------|------|-------------|
| `coding.blink` | 新一代补全引擎 | 高 - 核心功能 |
| `coding.luasnip` | 代码片段引擎 | 高 - 核心功能 |
| `coding.mini-comment` | 注释工具 | 高 - 常用 |
| `coding.mini-surround` | 括号/引号操作 | 高 - 常用 |
| `coding.neogen` | 文档注释生成 | 中 - 偶尔使用 |
| `coding.yanky` | 高级剪贴板 | 中 - 可选 |

#### 编辑器增强 (8个)
| Extra | 说明 | 使用频率评估 |
|-------|------|-------------|
| `editor.dial` | 数字/日期递增 | 低 - 很少使用 |
| `editor.harpoon2` | 文件标记导航 | 中 - 看个人习惯 |
| `editor.inc-rename` | 增量重命名 | 中 - 偶尔使用 |
| `editor.leap` | 快速跳转 | 高 - 常用 |
| `editor.mini-diff` | 差异显示 | 中 - 有用 |
| `editor.mini-move` | 行/块移动 | 中 - 有用 |
| `editor.overseer` | 任务运行器 | 高 - 核心功能 |
| `editor.refactoring` | 重构工具 | 中 - 偶尔使用 |
| `editor.snacks_picker` | Snacks 选择器 | 高 - 核心功能 |

#### 格式化 (3个)
| Extra | 说明 | 使用频率评估 |
|-------|------|-------------|
| `formatting.biome` | JS/TS 格式化 | 中 - 与 prettier 重叠 |
| `formatting.black` | Python 格式化 | 高 - Python 必需 |
| `formatting.prettier` | 通用格式化 | 高 - 前端必需 |

#### 语言支持 (18个) ⚠️ 重点关注

| Extra | 说明 | 使用频率评估 |
|-------|------|-------------|
| `lang.ansible` | Ansible 配置 | ❓ 是否在用? |
| `lang.clangd` | C/C++ | 中 - 可能在用 |
| `lang.cmake` | CMake | 低 - 依赖 C++ |
| `lang.dart` | Dart/Flutter | ❓ 是否在用? |
| `lang.docker` | Docker | 中 - 运维需要 |
| `lang.dotnet` | C#/.NET | 高 - 主力语言 |
| `lang.git` | Git 集成 | 高 - 必需 |
| `lang.go` | Go | ❓ 是否在用? |
| `lang.haskell` | Haskell | ❓ 是否在用? |
| `lang.json` | JSON | 高 - 常用 |
| `lang.julia` | Julia | ❓ 是否在用? |
| `lang.markdown` | Markdown | 高 - 常用 |
| `lang.python` | Python | 高 - 常用 |
| `lang.rust` | Rust | 高 - 在用 |
| `lang.toml` | TOML | 高 - Rust 配套 |
| `lang.typescript` | TypeScript | 中 - 前端需要 |
| `lang.vue` | Vue.js | ❓ 是否在用? |
| `lang.yaml` | YAML | 高 - 配置文件 |
| `lang.zig` | Zig | ❓ 是否在用? |

#### Linting (1个)
| Extra | 说明 |
|-------|------|
| `linting.eslint` | ESLint 集成 |

#### LSP 增强 (2个)
| Extra | 说明 | 使用频率评估 |
|-------|------|-------------|
| `lsp.neoconf` | 项目级 LSP 配置 | 低 - 很少配置 |
| `lsp.none-ls` | 非 LSP 工具适配 | 中 - 格式化需要 |

#### 测试 (1个)
| Extra | 说明 |
|-------|------|
| `test.core` | 测试框架集成 |

#### UI 增强 (5个)
| Extra | 说明 | 使用频率评估 |
|-------|------|-------------|
| `ui.dashboard-nvim` | 启动页面 | 低 - 纯装饰 |
| `ui.edgy` | 窗口布局管理 | 中 - 看习惯 |
| `ui.indent-blankline` | 缩进线 | 高 - 视觉辅助 |
| `ui.mini-indentscope` | 当前作用域缩进 | 中 - 与上一个重叠 |
| `ui.treesitter-context` | 上下文显示 | 高 - 很有用 |

#### 工具类 (8个)
| Extra | 说明 | 使用频率评估 |
|-------|------|-------------|
| `util.chezmoi` | Dotfiles 管理 | ❓ 是否在用? |
| `util.dot` | Graphviz DOT | 低 - 很少用 |
| `util.gh` | GitHub CLI | 中 - 偶尔用 |
| `util.gitui` | GitUI TUI | 低 - 与 lazygit 重复 |
| `util.mini-hipatterns` | 高亮模式 | 中 - TODO 高亮等 |
| `util.project` | 项目管理 | 中 - 看习惯 |
| `util.rest` | REST 客户端 | 低 - 偶尔用 |
| `util.startuptime` | 启动时间分析 | 低 - 调试用 |

#### 其他 (1个)
| Extra | 说明 |
|-------|------|
| `vscode` | VSCode 兼容 |

### 3.3 可疑的未使用 Extras

以下 extras 可能未被实际使用，建议确认后移除：

| Extra | 原因 |
|-------|------|
| `lang.ansible` | 除非做运维 |
| `lang.dart` | 除非做 Flutter 开发 |
| `lang.haskell` | 除非学习/使用 Haskell |
| `lang.julia` | 除非做科学计算 |
| `lang.vue` | 除非做 Vue 前端 |
| `lang.zig` | 除非学习/使用 Zig |
| `lang.go` | 除非做 Go 开发 |
| `util.chezmoi` | 除非用 chezmoi 管理 dotfiles |
| `util.dot` | 除非画 Graphviz 图 |
| `util.gitui` | 与 lazygit 功能重复 |

### 3.4 功能重叠

| 重叠项 | Extras | 建议 |
|--------|--------|------|
| 缩进显示 | `indent-blankline` + `mini-indentscope` | 保留一个即可 |
| JS 格式化 | `biome` + `prettier` | 选择一个作为主力 |
| Git TUI | `gitui` + (lazygit via toggleterm) | 保留一个即可 |

### 3.5 建议

1. **立即可移除** (如果确认不用): `lang.haskell`, `lang.julia`, `lang.dart`, `lang.zig`, `util.dot`, `util.gitui`
2. **确认后移除**: `lang.ansible`, `lang.vue`, `lang.go`, `util.chezmoi`
3. **合并功能**: 在 `indent-blankline` 和 `mini-indentscope` 中选一个
4. **定期审查**: 每隔几个月检查一次 extras 使用情况

### 3.6 潜在收益

移除 10 个不用的 extras 预计可以：
- 减少 5-10 个 LSP 服务器安装
- 减少 10-20 个插件加载
- 启动时间可能减少 50-200ms
- 内存占用减少 20-50MB

---

## 4. 重复的高亮组设置

**位置**: `lua/config/transparent.lua`

**问题**: 同一个高亮组在文件中被多次设置：

| 高亮组 | 设置位置 |
|--------|----------|
| `Pmenu` | 第 36 行、第 53 行、第 164 行 |
| `BlinkCmpMenu` | 第 54 行、第 168 行 |

**说明**: 这种重复设置会导致代码冗余，且最终只有最后一次设置生效。如果各处设置的值不同，还可能导致意外行为。建议合并这些设置，每个高亮组只设置一次。

---

## 5. omnisharp root_dir 回调签名异常

**位置**: `lua/plugins/dotnet.lua:18-22`

**问题代码**:
```lua
root_dir = function(bufnr, on_dir)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local root = lspconfig_util.root_pattern("*.sln", "*.slnx", "*.csproj", ".git")(fname)
  on_dir(root)
end
```

**说明**: nvim-lspconfig 的标准 `root_dir` 函数签名是 `function(fname)` 并直接返回路径字符串。当前使用的回调式写法 `function(bufnr, on_dir)` 可能是旧版 API 或非标准用法。

标准写法应为：
```lua
root_dir = function(fname)
  return lspconfig_util.root_pattern("*.sln", "*.slnx", "*.csproj", ".git")(fname)
end
```

需要验证当前写法是否在新版 nvim-lspconfig 中正常工作。

---

## 6. 终端状态使用模块级变量

**位置**: `lua/plugins/togglterm.lua:1-4`

**问题代码**:
```lua
local float_term
local lazygit_term
local command_runner_term
local codex_term
```

**说明**: 这些变量存储在模块的顶层作用域。如果因配置热重载（如 `:Lazy reload`）导致模块重新加载，这些变量会被重置为 `nil`，但之前创建的终端实例仍然存在，造成"孤儿终端"无法再被切换或关闭。

---

## 7. InsertLeave 时强制 redraw

**位置**: `lua/plugins/blink-cmp.lua:11-15`

**问题代码**:
```lua
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.cmd("redraw")
  end,
})
```

**说明**:
1. 这是一个 workaround，用于修复 blink.cmp 的窗口残留问题
2. 每次退出插入模式都强制重绘可能影响性能
3. 没有设置 `group` 参数，如果配置被重新加载，会注册多个相同的 autocmd
4. 建议添加 augroup 并监控是否该问题已在 blink.cmp 上游修复

---

## 8. 快捷键冲突风险

**涉及位置**: 多个文件

**发现的潜在冲突**:

| 快捷键 | 位置 1 | 位置 2 | 说明 |
|--------|--------|--------|------|
| `<leader>y` | `osc52.lua` (OSC52 复制) | `yanky` 插件 | 可能冲突 |

**说明**: `<leader>y` 在 osc52.lua 中被设置为 OSC52 复制操作符，但 yanky 插件（通过 `coding.yanky` extra 启用）通常也会使用 `<leader>y` 相关的快捷键。需要确认实际运行时哪个生效，以及是否是预期行为。

建议使用 `:verbose map <leader>y` 检查实际的映射情况。

---

## 10. 注释残留

**位置**: 多个文件

**发现的残留注释**:

| 文件 | 行号 | 内容 |
|------|------|------|
| `lua/config/options.lua` | 15 | `-- auto comp` (孤立注释，无上下文) |
| `lua/config/transparent.lua` | 84-90 | 大段被注释掉的 lualine 透明化代码 |

**说明**: 孤立的注释和被注释掉的代码会降低配置的可读性。如果代码已经不需要，建议删除；如果是备用方案，建议添加说明注释解释为什么保留。

---

## 11. checker 设置矛盾

**位置**: `lua/config/lazy.lua:34-37`

**问题代码**:
```lua
checker = {
  enabled = true,   -- 启用更新检查
  notify = false,   -- 但不通知
},
```

**说明**: 当前设置启用了插件更新检查，但禁用了通知。这意味着 lazy.nvim 会在后台检查更新，消耗网络资源，但你永远不会知道有更新可用（除非手动运行 `:Lazy`）。

建议：
- 如果想要更新提醒：设置 `notify = true`
- 如果不想被打扰：设置 `enabled = false` 节省资源
- 当前设置两边都不讨好

---

## 修复优先级建议

| 优先级 | 问题 | 原因 |
|--------|------|------|
| P1 | #1 废弃 API | 未来版本可能移除 |
| P1 | #5 root_dir 签名 | 可能导致 LSP 不工作 |
| P2 | #2 硬编码路径 | 影响可移植性 |
| P2 | #3 extras 膨胀 | 影响性能 |
| P2 | #7 缺少 augroup | 可能重复注册 |
| P3 | #4 重复高亮组 | 代码整洁 |
| P3 | #6 模块级变量 | 边缘情况 |
| P3 | #8 快捷键冲突 | 需验证 |
| P3 | #10 注释残留 | 代码整洁 |
| P3 | #11 checker 设置 | 资源浪费 |

---

*文档生成时间: 2026-01-28*

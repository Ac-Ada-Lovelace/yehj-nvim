# C# / F# Single File Runner for Neovim Overseer

## 已配置的任务

### 1. **C#: Run single file**
运行独立的 C# 文件（无项目结构）

- **快捷键**: `:OverseerRun` → 选择 "C#: Run single file"
- **适用**: 单文件 C# 代码（无 .csproj/.sln）
- **特点**:
  - 使用临时目录，不污染当前目录
  - 自动启用 `ImplicitUsings`
  - 支持命令行参数

**参数:**
- `Arguments`: 传递给程序的命令行参数
- `Open quickfix`: 是否打开 quickfix 窗口

### 2. **C#: Run with input file**
使用输入文件运行 C#（适合 OJ 调试）

- **快捷键**: `:OverseerRun` → 选择 "C#: Run with input file"
- **适用**: 算法题调试
- **特点**:
  - 从文件读取输入（默认 `input.txt`）
  - 自动查找同目录下的 `input.txt`

**使用方法:**
```bash
# 在 C# 文件同目录创建 input.txt
echo "5
1 2 3 4 5
10" > input.txt

# 然后在 nvim 中运行任务
```

### 3. **F#: Run script**
运行 F# 脚本文件（.fsx）

- **快捷键**: `:OverseerRun` → 选择 "F#: Run script"
- **适用**: F# 脚本文件（.fsx）
- **特点**: 使用官方 `dotnet fsi`

## 快速开始

### 基本使用

1. **打开 C# 文件**
   ```vim
   :e test.cs
   ```

2. **运行任务**
   ```vim
   :OverseerRun
   ```
   或使用你配置的快捷键

3. **选择任务**
   - 无项目: 选择 "C#: Run single file"
   - 有项目: 会自动显示 "Dotnet: solution task"

### OJ 算法调试工作流

```bash
# 1. 创建算法文件和输入文件
cd ~/oj
cat > solution.cs << 'EOF'
var n = int.Parse(Console.ReadLine()!);
var nums = Console.ReadLine()!.Split().Select(int.Parse).ToArray();
Console.WriteLine(nums.Sum());
EOF

cat > input.txt << 'EOF'
5
1 2 3 4 5
EOF

# 2. 在 nvim 中打开
nvim solution.cs

# 3. 运行任务
# :OverseerRun -> "C#: Run with input file"
```

### 带参数运行

```vim
" 运行任务时选择 "C#: Run single file"
" 在 Arguments 栏输入: arg1 arg2 arg3
```

## 推荐快捷键配置

在你的 `keys.lua` 或相应配置文件中添加:

```lua
-- Overseer 快捷键
vim.keymap.set("n", "<leader>rr", "<cmd>OverseerRun<cr>", { desc = "Run task" })
vim.keymap.set("n", "<leader>rt", "<cmd>OverseerToggle<cr>", { desc = "Toggle task list" })
vim.keymap.set("n", "<leader>ra", "<cmd>OverseerQuickAction<cr>", { desc = "Task action" })

-- 快速运行当前文件（自动选择第一个匹配的任务）
vim.keymap.set("n", "<F5>", function()
  local overseer = require("overseer")
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.cmd("OverseerRun")
  else
    overseer.run_action(tasks[1], "restart")
  end
end, { desc = "Run/Restart task" })
```

## 自定义配置

编辑 `~/.config/nvim/lua/config/csharp-runner.lua`:

```lua
local M = {}

-- 修改脚本路径
M.csharp_script_path = vim.fn.expand("~/bin/run-csharp.sh")

-- 修改默认输入文件名
M.default_input_file = "test.in"

return M
```

## 任务优先级

当多个任务同时匹配时的优先级:

1. **C#: Run single file** (priority: 60) - 无项目时优先
2. **C#: Run with input file** (priority: 59) - 无项目时可选
3. **Dotnet: solution task** (priority: 55) - 有项目时自动切换

## 目录清洁

所有任务都**不会污染当前目录**:

- ✅ C# 单文件: 使用临时目录编译和运行
- ✅ F# 脚本: 无编译产物
- ✅ 项目任务: 使用标准 bin/obj 目录

## 故障排除

### 任务未显示

检查:
```vim
:lua vim.bo.filetype  " 确认文件类型
:OverseerInfo         " 查看可用任务
```

### 脚本未找到

确认脚本存在并可执行:
```bash
ls -l ~/test/run-csharp.sh
chmod +x ~/test/run-csharp.sh
```

### F# 任务不可用

确认 .NET SDK 安装:
```bash
dotnet fsi --help
```

## 文件位置

```
~/.config/nvim/
├── lua/
│   ├── config/
│   │   └── csharp-runner.lua       # 配置文件
│   └── overseer/
│       └── template/
│           ├── csharp-single-file.lua    # C# 单文件
│           ├── csharp-with-input.lua     # C# 带输入
│           └── fsharp-script.lua         # F# 脚本
└── CSHARP-TASKS.md                 # 本文档
```

## 进阶技巧

### 自动测试多个输入

创建多个测试文件:
```bash
# test1.in, test2.in, test3.in
for i in {1..3}; do
  # 创建测试输入
done

# 在 nvim 中批量运行
:OverseerRun  " 选择 input file: test1.in
:OverseerRun  " 选择 input file: test2.in
```

### 与 LeetCode 集成

```lua
-- 在 overseer template 中添加 LeetCode 模板
-- 自动解析题目编号和测试用例
```

## 更多资源

- Overseer 文档: `:help overseer`
- 示例模板: `~/.config/nvim/lua/overseer/template/`
- 相关脚本: `~/test/run-csharp.sh`, `~/test/run-fsharp.sh`

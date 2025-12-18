# C# Runner 性能优化说明

## 🚀 性能提升

通过使用**编译缓存**，C# 单文件运行速度显著提升：

| 场景 | 耗时 | 提升 |
|------|------|------|
| 首次运行 | ~1.7秒 | - |
| 缓存运行 | ~0.5秒 | **3.6倍提速** |

## 📋 工作原理

### 原版本（慢）
```bash
每次运行都:
1. 创建临时目录
2. 创建项目文件
3. 复制源文件
4. dotnet restore
5. dotnet build
6. 运行程序
7. 删除临时目录
```

### 优化版本（快）
```bash
首次运行:
1. 创建缓存目录（~/.cache/csharp-runner/<hash>）
2. 编译并保存

后续运行:
1. 检测源文件是否修改
2. 如果未修改，直接运行已编译版本 ⚡
3. 如果修改了，重新编译
```

## 🎯 使用说明

### 自动使用
Overseer 任务已自动使用优化版本：
- 第一次运行某个 .cs 文件：需要编译 (~1.7s)
- 后续运行同一文件：直接运行 (~0.5s)
- 修改代码后：自动重新编译

### 手动使用
```bash
# 使用优化版本
~/.config/nvim/run-csharp.sh file.cs

# 或使用测试版本
~/test/run-csharp-fast.sh file.cs
```

## 🗂️ 缓存管理

### 查看缓存信息
```bash
~/.config/nvim/csharp-cache-manager.sh info
```

### 清理缓存
```bash
# 清理所有缓存（释放磁盘空间）
~/.config/nvim/csharp-cache-manager.sh clean
```

### 列出缓存项目
```bash
~/.config/nvim/csharp-cache-manager.sh list
```

## 📊 性能测试结果

实测数据（Intel/AMD 处理器，SSD）：

```
=== 性能对比测试 ===
1. 原版本:          1748ms
2. 快速版（首次）:  1740ms
3. 快速版（缓存）:  484ms   ⚡ 提速 261%

=== 总结 ===
第二次运行提速约 3-4 倍
```

## 🔧 缓存位置

```
~/.cache/csharp-runner/
├── <file-hash-1>/
│   ├── temp.csproj
│   ├── Program.cs
│   └── bin/Debug/net10.0/
│       └── temp.dll
├── <file-hash-2>/
│   └── ...
└── <file-hash-3>/
    └── ...
```

每个 .cs 文件根据完整路径生成唯一的哈希值，避免冲突。

## 💡 最佳实践

### OJ 算法题工作流
```bash
# 1. 创建题目文件
nvim problem1.cs

# 2. 第一次运行（慢，需编译）
:OverseerRun → "C#: Run single file"

# 3. 修改代码
# 编辑...

# 4. 再次运行（快，使用缓存）
<F5> 或 :OverseerRun
```

### 定期清理
如果做了大量算法题，定期清理缓存：

```bash
# 查看缓存大小
~/.config/nvim/csharp-cache-manager.sh info

# 如果占用太多（如 >100MB），清理
~/.config/nvim/csharp-cache-manager.sh clean
```

## ⚙️ 技术细节

### 缓存失效条件
缓存会在以下情况重新编译：
1. 源文件被修改（基于文件修改时间）
2. 编译产物不存在
3. 缓存目录被手动删除

### 为什么不用极速版本？
测试发现 `dotnet run --no-build` 比直接运行 dll 更快，因为：
- dotnet run 有启动优化
- 避免了额外的进程启动开销

### 编译优化选项
```xml
<TieredCompilation>false</TieredCompilation>
<TieredCompilationQuickJit>false</TieredCompilationQuickJit>
```
这些选项禁用分层编译，减少启动时间。

## 🐛 故障排除

### 缓存不工作
```bash
# 清理缓存重试
~/.config/nvim/csharp-cache-manager.sh clean

# 重新运行
nvim your-file.cs
:OverseerRun
```

### 编译错误后无法恢复
```bash
# 手动删除该文件的缓存
rm -rf ~/.cache/csharp-runner/<hash>

# 或清理所有缓存
~/.config/nvim/csharp-cache-manager.sh clean
```

### 磁盘空间不足
```bash
# 查看缓存大小
~/.config/nvim/csharp-cache-manager.sh info

# 清理缓存
~/.config/nvim/csharp-cache-manager.sh clean
```

## 📈 性能对比表

| 操作 | 原版本 | 优化版本 | 提升 |
|------|--------|----------|------|
| 首次编译 | 1.7s | 1.7s | 0% |
| 第2次运行 | 1.7s | 0.5s | **261%** |
| 第3次运行 | 1.7s | 0.5s | **261%** |
| 修改后运行 | 1.7s | 1.7s | 0% |
| 磁盘占用 | 0 | ~300KB/文件 | - |

## 🎉 总结

- ✅ 自动缓存，无需配置
- ✅ 3-4倍性能提升
- ✅ 智能失效检测
- ✅ 磁盘占用小（~300KB/文件）
- ✅ 易于管理和清理

**建议：**
- 日常开发使用缓存版本（已默认）
- 每月清理一次缓存
- OJ 刷题体验极佳！

#!/bin/bash
# C# 单文件快速运行器（带缓存）
# 用法: ./run-csharp-fast.sh Program.cs [args...]

if [ $# -eq 0 ]; then
	echo "用法: $0 <Program.cs> [args...]"
	exit 1
fi

FILE="$1"
shift # 移除第一个参数，剩下的是程序参数

# 获取绝对路径
FILE_ABS=$(realpath "$FILE")
FILE_HASH=$(echo -n "$FILE_ABS" | md5sum | cut -d' ' -f1)

# 使用缓存目录
CACHE_DIR="$HOME/.cache/csharp-runner/$FILE_HASH"
mkdir -p "$CACHE_DIR"

# 检查是否需要重新编译
NEED_BUILD=false

if [ ! -f "$CACHE_DIR/bin/Debug/net10.0/temp" ] && [ ! -f "$CACHE_DIR/bin/Debug/net10.0/temp.dll" ]; then
	# 首次编译
	NEED_BUILD=true
elif [ "$FILE_ABS" -nt "$CACHE_DIR/Program.cs" ]; then
	# 源文件更新了
	NEED_BUILD=true
fi

if [ "$NEED_BUILD" = true ]; then
	# 创建/更新项目文件
	cat >"$CACHE_DIR/temp.csproj" <<'EOF'
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net10.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <!-- 编译优化 -->
    <TieredCompilation>false</TieredCompilation>
    <TieredCompilationQuickJit>false</TieredCompilationQuickJit>
  </PropertyGroup>
</Project>
EOF

	# 复制源文件
	cp "$FILE_ABS" "$CACHE_DIR/Program.cs"

	# 编译（仅编译，不运行）
	cd "$CACHE_DIR"
	dotnet build -c Debug --nologo -v q 2>&1 | grep -v "Determining projects"

	if [ ${PIPESTATUS[0]} -ne 0 ]; then
		echo "编译失败"
		exit 1
	fi
	cd - >/dev/null
fi

# 直接运行已编译的程序
cd "$CACHE_DIR"
dotnet run --no-build --no-restore -- "$@"

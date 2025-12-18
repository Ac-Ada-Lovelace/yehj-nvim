#!/bin/bash
# C# Runner 缓存管理工具

CACHE_DIR="$HOME/.cache/csharp-runner"

case "${1:-}" in
    clean|clear)
        if [ -d "$CACHE_DIR" ]; then
            SIZE=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1)
            rm -rf "$CACHE_DIR"
            echo "✓ 已清理缓存 (释放 $SIZE)"
        else
            echo "✓ 缓存目录不存在"
        fi
        ;;

    size|info)
        if [ -d "$CACHE_DIR" ]; then
            SIZE=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1)
            COUNT=$(find "$CACHE_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
            echo "缓存信息:"
            echo "  位置: $CACHE_DIR"
            echo "  大小: $SIZE"
            echo "  项目数: $COUNT"
            echo
            echo "缓存的文件:"
            find "$CACHE_DIR" -name "Program.cs" -exec sh -c '
                for file; do
                    dir=$(dirname "$file")
                    mtime=$(stat -c "%y" "$file" | cut -d. -f1)
                    echo "  - $mtime"
                done
            ' sh {} +
        else
            echo "缓存目录不存在"
        fi
        ;;

    list|ls)
        if [ -d "$CACHE_DIR" ]; then
            echo "缓存的项目:"
            find "$CACHE_DIR" -mindepth 1 -maxdepth 1 -type d | while read dir; do
                if [ -f "$dir/Program.cs" ]; then
                    echo "  - $(basename "$dir")"
                    head -n 2 "$dir/Program.cs" | sed 's/^/    /'
                fi
            done
        else
            echo "缓存目录不存在"
        fi
        ;;

    help|--help|-h|"")
        cat <<EOF
C# Runner 缓存管理工具

用法: $0 <command>

命令:
  clean, clear    清理所有缓存
  size, info      显示缓存信息
  list, ls        列出缓存的项目
  help            显示此帮助

缓存位置: $CACHE_DIR

示例:
  $0 info         # 查看缓存大小
  $0 clean        # 清理缓存
EOF
        ;;

    *)
        echo "未知命令: $1"
        echo "使用 '$0 help' 查看帮助"
        exit 1
        ;;
esac

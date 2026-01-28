return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "fang2hou/blink-copilot",
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)

      -- 修复窗口残留问题：退出插入模式时刷新屏幕
      local redraw_group = vim.api.nvim_create_augroup("lazyvim_blink_cmp_redraw", { clear = true })
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = redraw_group,
        callback = function()
          vim.cmd("redraw")
        end,
      })
    end,
    opts = function(_, opts)
      -- 修复可能存在的配置问题
      if opts.sources then
        -- 移除 compat 字段（已废弃）
        opts.sources.compat = nil

        -- 移除没有 module 的 provider
        if opts.sources.providers then
          for name, provider in pairs(opts.sources.providers) do
            if type(provider) == "table" and not provider.module then
              opts.sources.providers[name] = nil
            end
          end
        end
      end

      opts.signature = opts.signature or {}
      opts.completion = opts.completion or {}
      opts.completion.menu = vim.tbl_deep_extend("force", opts.completion.menu or {}, {
        border = "rounded",
        scrollbar = true,
        winblend = 0,
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection",
      })

      opts.completion.documentation = opts.completion.documentation or {}
      opts.completion.documentation.window = vim.tbl_deep_extend("force", opts.completion.documentation.window or {}, {
        border = "rounded",
        scrollbar = true,
        -- 限制最大宽度和高度，减少窗口跳动
        max_width = 80,
        max_height = 20,
        -- 固定文档窗口位置：优先在补全菜单的右侧显示
        direction_priority = {
          menu_north = { "e", "w", "n", "s" },
          menu_south = { "e", "w", "n", "s" },
        },
        -- 添加 winblend 避免窗口残留
        winblend = 0,
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
      })

      if opts.signature then
        opts.signature.window = vim.tbl_deep_extend("force", opts.signature.window or {}, {
          border = "rounded",
          max_height = 3,
          show_documentation = true,
          direction_priority = { "s", "n" },
          scrollbar = false,
        })
      end

      -- 配置 Copilot 集成
      opts.sources = opts.sources or {}

      -- 安全地添加 copilot 到 default sources
      if opts.sources.default then
        local has_copilot = false
        for _, source in ipairs(opts.sources.default) do
          if source == "copilot" then
            has_copilot = true
            break
          end
        end
        if not has_copilot then
          table.insert(opts.sources.default, "copilot")
        end
      end

      -- 使用 vim.tbl_deep_extend 合并 providers
      opts.sources.providers = vim.tbl_deep_extend("force", opts.sources.providers or {}, {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
          opts = {
            max_completions = 5,
            debounce = 150,
          },
        },
      })

      -- 配置快捷键：手动触发补全
      opts.keymap = opts.keymap or {}
      opts.keymap = vim.tbl_deep_extend("force", opts.keymap, {
        preset = "default",
        -- Ctrl+Space: 手动显示补全菜单（所有 provider）
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        -- Enter: 直接接受当前项（未选中时会先选第一个）
        ["<CR>"] = { "select_and_accept", "fallback" },
      })
    end,
  },
}

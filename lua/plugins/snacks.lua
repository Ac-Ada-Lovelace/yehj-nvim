return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.picker = opts.picker or {}
      opts.picker.win = opts.picker.win or {}

      -- 直接跳到预览窗口的函数
      local function focus_preview(picker)
        if picker.preview and picker.preview.win and picker.preview.win.win then
          if vim.api.nvim_win_is_valid(picker.preview.win.win) then
            vim.api.nvim_set_current_win(picker.preview.win.win)
          end
        end
      end

      -- 为 input 窗口添加键映射
      opts.picker.win.input = opts.picker.win.input or {}
      opts.picker.win.input.keys = vim.tbl_extend("force", opts.picker.win.input.keys or {}, {
        -- Ctrl+Space: 循环切换所有窗口 (input -> preview -> list)
        ["<C-Space>"] = "cycle_win",
        -- Alt+p: 直接跳到预览窗口
        ["<M-p>"] = focus_preview,
      })

      -- 为 list 窗口添加键映射
      opts.picker.win.list = opts.picker.win.list or {}
      opts.picker.win.list.keys = vim.tbl_extend("force", opts.picker.win.list.keys or {}, {
        ["<C-Space>"] = "cycle_win",
        ["<M-p>"] = focus_preview,
      })

      -- 为 preview 窗口添加键映射（返回）
      opts.picker.win.preview = opts.picker.win.preview or {}
      opts.picker.win.preview.keys = vim.tbl_extend("force", opts.picker.win.preview.keys or {}, {
        ["<C-Space>"] = "cycle_win",
        ["q"] = "focus_input",
        ["<Esc>"] = "focus_list",
      })

      -- 让 colorschemes 用侧边分屏布局（非浮窗）
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.layouts = opts.picker.layouts or {}
      opts.picker.layouts.colorschemes_sidebar = {
        layout = {
          backdrop = false,
          width = 40,
          min_width = 40,
          height = 0,
          position = "right",
          border = "none",
          box = "vertical",
          {
            win = "input",
            height = 1,
            border = true,
            title = "{title} {live} {flags}",
            title_pos = "center",
          },
          { win = "list", border = "none" },
        },
      }

      opts.picker.sources.colorschemes = vim.tbl_deep_extend("force", opts.picker.sources.colorschemes or {}, {
        layout = { preset = "colorschemes_sidebar" },
        preview = false,
        on_show = function(picker)
          picker.state = picker.state or {}
          picker.state.colorscheme = vim.g.colors_name or "default"
          picker.state.background = vim.o.background
          picker.state.confirmed = false
        end,
        on_change = function(_, item)
          if item and item.text then
            vim.schedule(function()
              vim.cmd("colorscheme " .. item.text)
            end)
          end
        end,
        on_close = function(picker)
          if picker.state and picker.state.confirmed then
            return
          end
          if picker.state and picker.state.colorscheme then
            vim.schedule(function()
              vim.cmd("colorscheme " .. picker.state.colorscheme)
              vim.o.background = picker.state.background
            end)
          end
        end,
        confirm = function(picker, item)
          picker.state = picker.state or {}
          picker.state.confirmed = true
          picker:close()
          if item and item.text then
            vim.schedule(function()
              vim.cmd("colorscheme " .. item.text)
            end)
          end
        end,
      })

      return opts
    end,
  },
}

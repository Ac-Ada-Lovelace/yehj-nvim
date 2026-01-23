if true then
  return {}
end

return {
  {
    "themercorp/themer.lua",
    lazy = false,
    priority = 1000,
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        "<leader>uR",
        desc = "Themer Themes",
        function()
          require("themer").telescope_picker()
        end,
      },
    },

    config = function()
      local theme_file = vim.fn.stdpath("config") .. "/lua/config/last_theme.lua"
      local saved_theme = nil
      local ok, theme = pcall(dofile, theme_file)
      vim.notify(vim.inspect({ ok, theme }))
      if ok and type(theme) == "string" and theme ~= "" then
        vim.notify("Loaded saved theme: " .. theme, vim.log.levels.INFO)
        saved_theme = theme
      end

      require("themer").setup({
        colorscheme = saved_theme or "tokyo-night",
        styles = {
          ["function"] = { style = "italic" },
          functionbuiltin = { style = "italic" },
          variable = { style = "italic" },
          variableBuiltIn = { style = "italic" },
          parameter = { style = "italic" },
        },

        enable_installer = true,
      })
      local ok, telescope = pcall(require, "telescope")
      if not ok then
        return
      end

      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local finders = require("telescope.finders")
      local pickers = require("telescope.pickers")
      local themes = require("telescope.themes")
      local sorter = require("telescope.config").values.generic_sorter

      local function get_themer_themes()
        local disable_themes = require("themer.config")("get", nil).disable_telescope_themes
        local raw = vim.fn.getcompletion("themer_", "color")
        local results = {}
        for _, scheme in ipairs(raw) do
          local name = scheme:gsub("^themer_", "")
          if not vim.tbl_contains(disable_themes, name) then
            table.insert(results, name)
          end
        end
        return results
      end

      local function apply_theme(name)
        if name and name ~= "" then
          require("themer").setup({ colorscheme = name })
        end
      end

      local function save_theme(name)
        if name and name ~= "" then
          vim.fn.writefile({ string.format("return %q", name) }, theme_file)
        end
      end

      local function open_picker()
        local list = get_themer_themes()
        local original = require("themer.config")("get", nil).colorscheme
        local confirmed = false
        local default_index = nil

        for i, name in ipairs(list) do
          if name == original then
            default_index = i
            break
          end
        end

        local function restore()
          if not confirmed then
            apply_theme(original)
          end
        end

        local function preview(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            apply_theme(selection[1])
          end
        end

        local function move_next(prompt_bufnr)
          actions.move_selection_next(prompt_bufnr)
          preview(prompt_bufnr)
        end

        local function move_prev(prompt_bufnr)
          actions.move_selection_previous(prompt_bufnr)
          preview(prompt_bufnr)
        end

        local function confirm(prompt_bufnr)
          confirmed = true
          preview(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            save_theme(selection[1])
          end
          actions.close(prompt_bufnr)
        end

        local function cancel(prompt_bufnr)
          restore()
          actions.close(prompt_bufnr)
        end

        local opts = themes.get_ivy({
          prompt_title = "Themer ColorScheme",
          results_title = "Change colorscheme",
          finder = finders.new_table({ results = list }),
          sorter = sorter({}),
          previewer = false,
          default_selection_index = default_index,
          attach_mappings = function(prompt_bufnr, map)
            vim.api.nvim_create_autocmd("BufWinLeave", {
              buffer = prompt_bufnr,
              once = true,
              callback = restore,
            })

            map("i", "<CR>", confirm)
            map("n", "<CR>", confirm)
            map("i", "<Esc>", cancel)
            map("n", "<Esc>", cancel)
            map("i", "<C-c>", cancel)
            map("n", "<C-c>", cancel)
            map("n", "q", cancel)

            map("i", "<Down>", move_next)
            map("n", "<Down>", move_next)
            map("i", "<Up>", move_prev)
            map("n", "<Up>", move_prev)
            map("i", "<C-n>", move_next)
            map("i", "<C-p>", move_prev)
            map("n", "j", move_next)
            map("n", "k", move_prev)
            map("i", "<Tab>", move_next)
            map("i", "<S-Tab>", move_prev)

            return true
          end,
        })

        pickers.new(opts):find()
      end

      telescope.load_extension("themes")
      require("themer").telescope_picker = open_picker
    end,
  },
}

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local toggleterm = require("toggleterm")

      toggleterm.setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return math.floor(vim.o.columns * 0.4)
          end
          return 20
        end,
        open_mapping = [[<C-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 2,
        persist_mode = true,
        persist_size = true,
        start_in_insert = true,
        direction = "horizontal",
        close_on_exit = true,
        float_opts = {
          border = "curved",
          winblend = 0,
        },
      })

      local function set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], opts)
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], opts)
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], opts)
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], opts)
      end

      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*toggleterm#*",
        callback = set_terminal_keymaps,
      })
    end,
    keys = {
      {
        "<leader>jt",
        function()
          vim.cmd("ToggleTerm")
        end,
        mode = { "n", "t" },
        desc = "Toggle terminal",
      },
      {
        "<leader>jT",
        function()
          vim.cmd("TermSelect")
        end,
        mode = { "n", "t" },
        desc = "Show terminal list",
      },
      {
        "<leader>jF",
        function()
          if not float_term then
            local Terminal = require("toggleterm.terminal").Terminal
            float_term = Terminal:new({ direction = "float", float_opts = { border = "curved" } })
          end
          float_term:toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle floating terminal",
      },
    },
  },
}

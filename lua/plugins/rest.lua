return {
  {
    "rest-nvim/rest.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    rocks = { enabled = false },
    ft = { "http" },
    config = function()
      require("rest-nvim").setup({})
    end,
    keys = {
      {
        "<leader>jj",
        function()
          local items = {
            { label = "Run request", cmd = "Rest run" },
            { label = "Run last", cmd = "Rest run last" },
            { label = "Open result", cmd = "Rest open" },
            { label = "Show logs", cmd = "Rest logs" },
          }

          vim.ui.select(items, {
            prompt = "rest.nvim",
            format_item = function(item)
              return item.label
            end,
          }, function(item)
            if not item then
              return
            end
            vim.cmd(item.cmd)
          end)
        end,
        desc = "Rest menu",
      },
    },
  },
}

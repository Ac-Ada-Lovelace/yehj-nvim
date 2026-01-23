return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.views = opts.views or {}
      opts.views.popupmenu = vim.tbl_deep_extend("force", opts.views.popupmenu or {}, {
        border = { style = "rounded", padding = { 0, 1 } },
        scrollbar = true,
      })
      opts.views.cmdline_popup = vim.tbl_deep_extend("force", opts.views.cmdline_popup or {}, {
        border = { style = "rounded", padding = { 0, 1 } },
      })
    end,
  },
}

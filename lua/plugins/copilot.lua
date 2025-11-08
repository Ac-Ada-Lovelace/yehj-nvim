return {
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      -- Force inline suggestions with sane defaults and leave the panel disabled
      opts.suggestion = vim.tbl_deep_extend("force", {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = "<C-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      }, opts.suggestion or {})
      opts.panel = vim.tbl_deep_extend("force", {
        enabled = false,
      }, opts.panel or {})
    end,
  },
}

local function markdownlint_config()
  return vim.fn.stdpath("config") .. "/.markdownlint.jsonc"
end

return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      local formatter = opts.formatters["markdownlint-cli2"] or {}
      formatter.env = vim.tbl_extend("force", formatter.env or {}, {
        MARKDOWNLINT_CONFIG = markdownlint_config(),
      })
      opts.formatters["markdownlint-cli2"] = formatter
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      local linter = opts.linters["markdownlint-cli2"] or {}
      linter.env = vim.tbl_extend("force", linter.env or {}, {
        MARKDOWNLINT_CONFIG = markdownlint_config(),
      })
      opts.linters["markdownlint-cli2"] = linter
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local config = markdownlint_config()
      opts.sources = opts.sources or {}
      local nls = require("null-ls")
      local added = false

      for index, source in ipairs(opts.sources) do
        if source.name == "markdownlint_cli2" then
          opts.sources[index] = source.with({ env = { MARKDOWNLINT_CONFIG = config } })
          added = true
        end
      end

      if not added then
        table.insert(opts.sources, nls.builtins.diagnostics.markdownlint_cli2.with({
          env = { MARKDOWNLINT_CONFIG = config },
        }))
      end
    end,
  },
}

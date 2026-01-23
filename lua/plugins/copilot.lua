return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = function(_, opts)
      -- Give Copilot's node runtime a bit more headroom so it doesn't OOM in large files
      vim.env.NODE_OPTIONS = vim.env.NODE_OPTIONS or "--max-old-space-size=1536"

      -- 禁用 suggestion 和 panel，完全交由 blink-cmp 处理

      -- Ensure Copilot shuts down when Neovim exits to avoid orphaned node servers
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = vim.api.nvim_create_augroup("LazyVimCopilotShutdown", { clear = true }),
        callback = function()
          pcall(function()
            require("copilot.client").stop()
          end)
        end,
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = function(_, opts)
      opts.prompts = vim.tbl_deep_extend("force", opts.prompts or {}, {
        ["Describe Selection"] = {
          prompt = table.concat({
            "Describe the selected text in clear natural language.",
            "Highlight what it does, why it exists, and any noteworthy behavior or dependencies.",
          }, " "),
          description = "Summarize the selected code or text.",
        },
        ["Implement Selection Intent"] = {
          prompt = table.concat({
            "Treat the selection as a high-level intent (comments, pseudocode, or partial code).",
            "Produce concrete, working code that fulfills that intent using the surrounding context.",
            "Keep the answer concise: first show the finished code, then briefly explain the main decisions.",
          }, " "),
          description = "Generate code that fulfills the selected intent.",
          resources = {
            "selection",
            "buffer:active",
          },
        },
      })
    end,
    keys = function(_, keys)
      local remapped = {}
      for _, key in ipairs(keys) do
        if key[1] ~= "<leader>aa" then
          table.insert(remapped, key)
        end
      end
      table.insert(remapped, {
        "<leader>at",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "x" },
      })
      return remapped
    end,
  },
}

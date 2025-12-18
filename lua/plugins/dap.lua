return {
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = function(_, opts)
      opts = opts or {}
      opts.clear_on_continue = true
      return opts
    end,
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup(opts)

      local dap = require("dap")
      local function clear_virtual_text()
        require("nvim-dap-virtual-text").refresh()
      end

      dap.listeners.after.event_terminated["dap_virtual_text_cleanup"] = clear_virtual_text
      dap.listeners.after.event_exited["dap_virtual_text_cleanup"] = clear_virtual_text
      dap.listeners.after.disconnect["dap_virtual_text_cleanup"] = clear_virtual_text
    end,
  },
}

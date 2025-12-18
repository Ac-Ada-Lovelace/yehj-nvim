-- Overseer template: Run F# script file
-- Uses dotnet fsi for script execution

local overseer = require("overseer")

return {
  name = "F#: Run script",
  desc = "Run a standalone F# script (.fsx) file",
  builder = function(params)
    local file = vim.fn.expand("%:p")

    local cmd = { "dotnet", "fsi", file }

    -- Add arguments if provided
    if params.args and params.args ~= "" then
      vim.list_extend(cmd, { "--" })
      for arg in string.gmatch(params.args, "%S+") do
        table.insert(cmd, arg)
      end
    end

    return {
      cmd = cmd,
      components = {
        { "on_output_quickfix", open = params.open_quickfix },
        { "on_complete_notify" },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "fsharp" },
    callback = function()
      local file = vim.fn.expand("%:t")
      -- Only for .fsx files
      return vim.endswith(file, ".fsx")
    end,
  },
  priority = 60,
  tags = { overseer.TAG.RUN },
  params = {
    args = {
      type = "string",
      name = "Arguments",
      desc = "Command line arguments to pass to the F# script",
      default = "",
      optional = true,
    },
    open_quickfix = {
      type = "boolean",
      name = "Open quickfix",
      desc = "Open quickfix window on output",
      default = true,
    },
  },
}

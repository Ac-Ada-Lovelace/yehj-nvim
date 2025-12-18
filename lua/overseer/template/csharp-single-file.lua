-- Overseer template: Run single C# file
-- Uses the run-csharp.sh script for clean, project-less execution
-- No directory pollution - uses temporary directories

local overseer = require("overseer")

return {
  name = "C#: Run single file",
  desc = "Run a standalone C# file without project structure",
  builder = function(params)
    local file = vim.fn.expand("%:p")
    local script_path = vim.fn.expand("~/.config/nvim/run-csharp.sh")

    -- Check if script exists
    if vim.fn.filereadable(script_path) ~= 1 then
      error("run-csharp.sh not found at " .. script_path)
    end

    local cmd = { script_path, file }

    -- Add command line arguments if provided
    if params.args and params.args ~= "" then
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
    filetype = { "cs" },
    callback = function()
      -- Only enable for .cs files that are NOT in a project structure
      local file = vim.fn.expand("%:p")
      local dir = vim.fs.dirname(file)

      -- Check if there's a .csproj or .sln nearby
      local csproj = vim.fs.find({ "*.csproj" }, { upward = true, type = "file", path = dir })[1]
      local sln = vim.fs.find({ "*.sln" }, { upward = true, type = "file", path = dir })[1]

      -- Only show this task if no project files found
      return not csproj and not sln
    end,
  },
  priority = 60, -- Higher priority than dotnet solution task
  tags = { overseer.TAG.RUN },
  params = {
    args = {
      type = "string",
      name = "Arguments",
      desc = "Command line arguments to pass to the C# program",
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

-- Overseer template: Run C# file with input file
-- Perfect for OJ algorithm debugging

local overseer = require("overseer")

return {
  name = "C#: Run with input file",
  desc = "Run C# file with input from a file (for OJ debugging)",
  builder = function(params)
    local file = vim.fn.expand("%:p")
    local script_path = vim.fn.expand("~/test/run-csharp.sh")

    if vim.fn.filereadable(script_path) ~= 1 then
      error("run-csharp.sh not found at " .. script_path)
    end

    -- Find input file
    local input_file = params.input_file
    if not input_file or input_file == "" then
      -- Try to find input.txt in same directory
      local dir = vim.fs.dirname(file)
      local default_input = dir .. "/input.txt"
      if vim.fn.filereadable(default_input) == 1 then
        input_file = default_input
      else
        error("No input file specified and no input.txt found")
      end
    end

    if vim.fn.filereadable(input_file) ~= 1 then
      error("Input file not found: " .. input_file)
    end

    -- Build command: cat input.txt | ./run-csharp.sh file.cs
    local cmd = { "sh", "-c", string.format("cat %s | %s %s",
      vim.fn.shellescape(input_file),
      vim.fn.shellescape(script_path),
      vim.fn.shellescape(file)
    )}

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
      local file = vim.fn.expand("%:p")
      local dir = vim.fs.dirname(file)

      -- Only enable if no project files nearby
      local csproj = vim.fs.find({ "*.csproj" }, { upward = true, type = "file", path = dir })[1]
      local sln = vim.fs.find({ "*.sln" }, { upward = true, type = "file", path = dir })[1]

      return not csproj and not sln
    end,
  },
  priority = 59,
  tags = { overseer.TAG.RUN },
  params = {
    input_file = {
      type = "string",
      name = "Input file",
      desc = "File to read input from (default: input.txt in same directory)",
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

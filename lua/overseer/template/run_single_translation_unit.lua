local overseer = require("overseer")

local ft_defaults = {
  c = { compiler = "gcc", std = "c17" },
  cpp = { compiler = "g++", std = "c++20" },
  cxx = { compiler = "g++", std = "c++20" },
}

return {
  name = "Run current C/C++ file",
  desc = "Builds the current buffer into a temp binary and runs it",
  builder = function()
    local buf = vim.api.nvim_get_current_buf()
    local file = vim.api.nvim_buf_get_name(buf)
    if file == "" then
      error("Current buffer is not associated with a file.")
    end

    if vim.bo[buf].modified then
      vim.cmd("write")
    end

    local ft = vim.bo[buf].filetype
    local defaults = ft_defaults[ft]
    if not defaults then
      error(string.format("Filetype '%s' is not supported by this template.", ft))
    end

    local output = vim.fn.tempname()
    local binary = output .. ".bin"
    local compile_cmd = table.concat({
      vim.fn.shellescape(defaults.compiler),
      "-std=" .. defaults.std,
      "-O2",
      "-g",
      "-Wall",
      "-Wextra",
      vim.fn.shellescape(file),
      "-o",
      vim.fn.shellescape(binary),
    }, " ")
    local run_cmd = vim.fn.shellescape(binary)
    local cleanup_cmd = string.format('trap "rm -f %s" EXIT', vim.fn.shellescape(binary))
    local full_cmd = table.concat({
      "set -e",
      cleanup_cmd,
      compile_cmd,
      run_cmd,
    }, "\n")

    return {
      cmd = { "bash", "-c", full_cmd },
      cwd = vim.fn.fnamemodify(file, ":h"),
      components = {
        "default",
      },
    }
  end,
  condition = {
    filetype = vim.tbl_keys(ft_defaults),
  },
  priority = 60,
  tags = { overseer.TAG.BUILD, overseer.TAG.RUN },
  params = {},
}

local overseer = require("overseer")

return {
  name = "Generate compile_commands.json",
  desc = "Generate compile_commands.json using CMake or Bear",
  builder = function()
    local cwd = vim.fn.getcwd()
    local has_makefile = vim.fn.filereadable(cwd .. "/Makefile") == 1 or vim.fn.filereadable(cwd .. "/makefile") == 1
    local has_cmake = vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1

    if not (has_makefile or has_cmake) then
      error("No CMakeLists.txt or Makefile found in the current directory.")
    end

    local cmd, args

    if has_cmake then
      cmd = "cmake"
      args = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON", "." }
    elseif has_makefile then
      cmd = "bear"
      args = { "--", "make" }
    end

    return {
      cmd = cmd,
      args = args,
      cwd = cwd,
      components = {
        { "on_output_quickfix", open = true, set_diagnostics = true },
        "default",
      },
    }
  end,
  condition = {
    callback = function()
      local cwd = vim.fn.getcwd()
      local res = vim.fn.filereadable(cwd .. "/Makefile") == 1
        or vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1
        or vim.fn.filereadable(cwd .. "/makefile") == 1
      return res
    end,
  },
  priority = 50,
  tags = { overseer.TAG.BUILD },
  params = {},
}

return {
  name = "Run current file",
  desc = "Detects the current buffer filetype and runs it with a matching interpreter",
  builder = function()
    local file = vim.fn.expand("%:p")
    local ft = vim.bo.filetype
    local cmd

    if ft == "python" then
      cmd = { "python", file }
    elseif ft == "javascript" then
      cmd = { "node", file }
    elseif ft == "typescript" then
      cmd = { "node", file }
    elseif ft == "sh" then
      cmd = { "sh", file }
    else
      cmd = { file }
    end

    return {
      cmd = cmd,
      components = {
        { "on_output_quickfix", open = true },
        "default",
      },
    }
  end,
  condition = {
    filetype = { "python", "javascript", "typescript", "sh" },
  },
}

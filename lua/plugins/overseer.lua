local function register_user_templates(overseer)
  local template_dirs = {
    vim.fs.normalize(vim.fn.stdpath("config") .. "/lua/overseer/template"),
    vim.fs.normalize(vim.fn.stdpath("config") .. "/templates"),
  }

  local template_files = {}
  for _, dir in ipairs(template_dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      local files = vim.fn.glob(dir .. "/**/*.lua", false, true)
      vim.list_extend(template_files, files)
    end
  end

  for _, file in ipairs(template_files) do
    local ok, template = pcall(dofile, file)
    if not ok then
      vim.notify(string.format("overseer template error in %s: %s", file, template), vim.log.levels.WARN)
    elseif template then
      vim.notify(string.format("register template: %s", template))
      overseer.register_template(template)
    end
  end
end

return {
  {
    "stevearc/overseer.nvim",

    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)
      register_user_templates(overseer)
    end,
  },
}

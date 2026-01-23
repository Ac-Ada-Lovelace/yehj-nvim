if true then
  return {}
end

local function register_user_templates(overseer)
  -- Check both /templates and /lua/overseer/template directories
  local dirs = {
    vim.fs.normalize(vim.fn.stdpath("config") .. "/templates"),
    vim.fs.normalize(vim.fn.stdpath("config") .. "/lua/overseer/template"),
  }

  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      local files = vim.fn.glob(dir .. "/**/*.lua", false, true)
      for _, file in ipairs(files) do
        local ok, template = pcall(dofile, file)
        if not ok then
          vim.notify(string.format("overseer template error in %s: %s", file, template), vim.log.levels.WARN)
        elseif template then
          overseer.register_template(template)
        end
      end
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

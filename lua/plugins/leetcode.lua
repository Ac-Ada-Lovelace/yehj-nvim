-- LeetCode CLI integration for Neovim
-- Wraps leetcode-cli commands using overseer tasks

-- Run overseer task by name
local function run_overseer_task(task_name, params)
  local overseer = require("overseer")

  -- Use run_template to properly start the task
  overseer.run_template({ name = task_name, params = params }, function(task)
    if task then
      overseer.open()
    else
      vim.notify("Failed to create task: " .. task_name, vim.log.levels.ERROR)
      -- Show available templates for debugging
      vim.cmd("OverseerRun")
    end
  end)
end

-- Setup commands
local function setup_commands()
  -- Edit/Download problem
  vim.api.nvim_create_user_command("LeetEdit", function(opts)
    local id = opts.args
    if id == "" then
      vim.notify("Please provide a problem id: :LeetEdit <id>", vim.log.levels.ERROR)
      return
    end
    run_overseer_task("LeetCode: Edit/Download", { problem_id = id })
  end, {
    nargs = 1,
    desc = "Download LeetCode problem by id",
  })

  -- Execute/Submit solution
  vim.api.nvim_create_user_command("LeetExec", function()
    run_overseer_task("LeetCode: Submit")
  end, {
    nargs = 0,
    desc = "Submit current LeetCode solution",
  })

  -- Test solution
  vim.api.nvim_create_user_command("LeetTest", function()
    run_overseer_task("LeetCode: Test")
  end, {
    nargs = 0,
    desc = "Test current LeetCode solution",
  })
end

-- Setup keymaps (optional)
local function setup_keymaps()
  -- Only set keymaps for LeetCode files
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.*.{rs,py,java,cpp,c,js,ts,go,kt,swift,rb,scala,cs}",
    callback = function()
      local filename = vim.fn.expand("%:t")
      -- Check if it's a LeetCode file (starts with number)
      if filename:match("^%d+%.") then
        vim.keymap.set("n", "<leader>jt", "<cmd>LeetTest<cr>", { buffer = true, desc = "LeetCode Test" })
        vim.keymap.set("n", "<leader>jx", "<cmd>LeetExec<cr>", { buffer = true, desc = "LeetCode Submit" })
      end
    end,
  })

  -- Global keymap for downloading problems
  vim.keymap.set("n", "<leader>je", function()
    vim.ui.input({ prompt = "LeetCode Problem ID: " }, function(input)
      if input and input ~= "" then
        vim.cmd("LeetEdit " .. input)
      end
    end)
  end, { desc = "LeetCode Edit/Download" })
end

return {
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Setup commands when LazyVim loads
      setup_commands()
      setup_keymaps()
    end,
  },
}

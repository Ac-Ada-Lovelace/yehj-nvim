-- Configuration for C# single file runner
-- Customize paths and behavior here

local M = {}

-- Path to the run-csharp.sh script
-- Change this if you move the script to a different location
M.csharp_script_path = vim.fn.expand("~/test/run-csharp.sh")

-- Path to the run-fsharp.sh script
M.fsharp_script_path = vim.fn.expand("~/test/run-fsharp.sh")

-- Default input file name for OJ debugging
M.default_input_file = "input.txt"

-- Whether to open quickfix window by default
M.open_quickfix_default = true

-- Whether to notify on completion
M.notify_on_complete = true

return M

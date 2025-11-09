return {
  {
    "CRAG666/code_runner.nvim",
    config = function()
      require("code_runner").setup({
        filetype = {
          python = "python3 -u",
          javascript = "node",
          typescript = "ts-node",
          rust = "cargo run",
          go = "go run",
          c = "gcc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
          cpp = "g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
        },
      })
    end,
    keys = {
      { "<leader>jr", ":RunCode<CR>", desc = "Run code" },
      { "<leader>jF", ":RunFile<CR>", desc = "Run file" },
      { "<leader>jp", ":RunProject<CR>", desc = "Run project" },
    },
  },

  {
    "michaelb/sniprun",
    build = "bash ./install.sh",
    config = function()
      require("sniprun").setup({
        display = { "Classic", "VirtualTextOk" },
      })
    end,
    keys = {
      { "<leader>jR", ":'<,'>SnipRun<CR>", mode = "v", desc = "Run selection" },
      { "<leader>jC", ":SnipRun<CR>", desc = "Run current file" },
    },
  },
}

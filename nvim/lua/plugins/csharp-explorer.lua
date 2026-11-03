-- =====================================================================================================
-- TITLE: dtrh95/csharp-explorer.nvim
-- ABOUT: A lightweight, efficient C# Solution Explorer for Neovim
-- LINKS: https://github.com/dtrh95/csharp-explorer.nvim
-- =====================================================================================================

local env = require("config.lsp-env")

return {
  "dtrh95/csharp-explorer.nvim",
  dependencies = {
    "nvim-tree/nvim-tree.lua",
    "nvim-tree/nvim-web-devicons",
  },
  cond = env.dotnet_lsp_available,
  cmd = "CSharpExplorer",
  opts = {
    enabled = true,
    ui = {
      width = 40,
      sync_nvim_tree_width = true,
    },
    filter = {
      gitignored = true,
    },
  },
  config = function(_, opts)
    local explorer = require("csharp-explorer")
    explorer.setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("CSharpExplorerNoList", { clear = true }),
      pattern = "csharpexplorer",
      callback = function()
        vim.wo.list = false
      end,
    })
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("CSharpExplorerFollow", { clear = true }),
      pattern = "*.cs",
      callback = function()
        if not explorer.is_active then
          return
        end
        local prev_win = vim.api.nvim_get_current_win()
        explorer.find_file()
        if vim.api.nvim_win_is_valid(prev_win) then
          vim.api.nvim_set_current_win(prev_win)
        end
      end,
    })
  end,
}

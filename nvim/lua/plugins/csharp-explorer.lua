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
    require("csharp-explorer").setup(opts)
  end,
}

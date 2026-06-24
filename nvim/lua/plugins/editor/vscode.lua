-- ================================================================================
-- TITLE: mofiqul/vscode.nvim
-- ABOUT: VSCode like color scheme for Neovim
-- LINKS: https://github.com/mofiqul/vscode.nvim
-- ================================================================================

return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    disable_nvimtree_bg = true,
  },
  config = function(_, opts)
    require("vscode").setup(opts)
    vim.cmd([[colorscheme vscode]])
  end,
}

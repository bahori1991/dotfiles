-- ================================================================================
-- TITLE: mofiqul/vscode.nvim
-- ABOUT: VSCode like color scheme for Neovim
-- LINKS: https://github.com/mofiqul/vscode.nvim
-- ================================================================================

local colorscheme = require("config.colorscheme")
return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  -- opts = colorscheme.vscode_opts(),
  config = function()
    colorscheme.apply_vscode()
  end,
}

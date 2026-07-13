-- ================================================================================
-- TITLE: mofiqul/vscode.nvim
-- ABOUT: VSCode like color scheme for Neovim
-- LINKS: https://github.com/mofiqul/vscode.nvim
-- ================================================================================

local colorscheme = require("config.ui.colorscheme")
return {
	"Mofiqul/vscode.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		colorscheme.apply_vscode()
	end,
}

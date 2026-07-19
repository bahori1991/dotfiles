-- ======================================================================================
-- TITLE: mason-org/mason-lspconfig.nvim
-- ABOUT: bridges mason.nvim with the lspconfig plugin
-- LINKS: https://github.com/mason-org/mason-lspconfig.nvim
-- ======================================================================================
--
-- Role split (automatic_enable = false):
--   mason-lspconfig  → LSP binary install (ensure_installed) + Mason↔lspconfig mapping
--   nvim-lspconfig   → server settings, blink capabilities, vim.lsp.enable()
--   mason-tool-installer → formatters / linters only

return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		"mason-org/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	opts = {
		automatic_enable = false,
		ensure_installed = {
			"lua_ls",
			"hls", -- haskell-language-server
		},
	},
}

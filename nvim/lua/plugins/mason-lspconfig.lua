-- =====================================================================================================
-- TITLE: mason-org/mason-lspconfig.nvim
-- ABOUT: Bridge between Mason and vim.lsp.config / nvim-lspconfig
-- LINKS: https://github.com/mason-org/mason-lspconfig.nvim
-- =====================================================================================================

return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{
			"mason-org/mason.nvim",
			cmd = "Mason",
			build = ":MasonUpdate",
			opts = {},
		},
		"neovim/nvim-lspconfig",
		"saghen/blink.cmp",
	},
	opts = {
		-- "ensure_installed" depends on "mason-tool-installer"
		ensure_installed = {},
		automatic_enable = true,
	},
	config = function(_, opts)
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})
		require("mason-lspconfig").setup(opts)
	end,
}

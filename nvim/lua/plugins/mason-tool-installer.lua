-- =====================================================================================================
-- TITLE: WhoIsSethDaniel/mason-tool-installer.nvim
-- ABOUT: Ensure Mason tools are installed/updated on startup
-- LINKS: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- =====================================================================================================

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	opts = {
		ensure_installed = {
			"lua_ls",
			"stylua",
		},
		run_on_start = true,
		start_delay = 1000,
		debounce_hours = 24,
		integrations = {
			["mason-lspconfig"] = true,
			["mason-null-ls"] = false,
			["mason-nvim-dap"] = false,
		},
	},
}

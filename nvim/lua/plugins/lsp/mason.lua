-- ======================================================================================
-- TITLE: mason-org/mason.nvim
-- ABOUT: Easy install and manage LSP servers, DAP servers, linters, and formatters
-- LINKS: https://github.com/mason-org/mason.nvim
-- ======================================================================================

return {
	"mason-org/mason.nvim",
	opts = {
		-- Mason bin first so conform / LSP pick up Mason-installed tools
		PATH = "prepend",
		max_concurrent_installers = 4, -- use 1 on slow networks
		ui = {
			border = "rounded", -- matches vim.diagnostic.config float border
			width = 0.8,
			height = 0.9,
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}

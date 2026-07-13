-- ========================================================================================
-- TITLE: stevearc/conform.nvim
-- ABOUT: Lightweight formatter plugin for Neovim
-- LINKS: https://github.com/stevearc/conform.nvim
-- ========================================================================================

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
		},
		format_on_save = {
			timeout_ms = 30,
			lsp_format = "fallback",
		},
		notify_on_error = false,
	},
}

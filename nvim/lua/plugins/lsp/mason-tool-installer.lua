-- ========================================================================================
-- TITLE: WhoIsSethDaniel/mason-tool-installer.nvim
-- ABOUT: keep up to date with tools and to make consistent environment
-- LINKS: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
-- ========================================================================================

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "mason-org/mason.nvim" },
	opts = {
		ensure_installed = {
			"stylua",
			"fourmolu", -- formatter of haskell
			"hlint", -- linter for haskell (used by nvim-lint)
		},
		run_on_start = true,
		start_delay = 3000, -- reduce Mason UI noise on startup
		debounce_hours = 24, -- skip reinstall attempts within 24h
	},
}

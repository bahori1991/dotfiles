-- ======================================================================================
-- TITLE: saghen/blink.pairs
-- ABOUT: Intelligent auto-pairs with rainbow highlighting for Neovim
-- LINKS: https://github.com/saghen/blink.pairs
-- ======================================================================================

return {
	"saghen/blink.pairs",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = { "saghen/blink.lib" },
	version = "*",
	build = function()
		require("blink.pairs").download():pwait(60000)
	end,
	---@module "blink.pairs"
	---@type blink.pairs.Config
	opts = {
		mappings = {
			enabled = true,
			cmdline = true,
			disabled_filetypes = {},
		},
		highlights = {
			enabled = true,
			cmdline = true,
			groups = { "BlinkPairsBlue" },
			unmatched_group = "BlinkPairsUnmatched",
			matchparen = {
				enabled = true,
				cmdline = false,
				include_surrounding = false,
				group = "BlinkPairsMatchParen",
				priority = 250,
			},
		},
		debug = false,
	},
}

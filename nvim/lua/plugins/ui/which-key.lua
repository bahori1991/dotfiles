-- ================================================================================
-- TITLE: folke/which-key.nvim
-- ABOUT: remenber custom Neovim keymaps
-- LINKS: https://github.com/folke/which-key.nvim
-- ================================================================================

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		disable = {
			ft = { "TelescopePrompt" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps",
		},
	},
}

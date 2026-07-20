-- ================================================================================
-- TITLE: folke/which-key.nvim
-- ABOUT: remember custom Neovim keymaps
-- LINKS: https://github.com/folke/which-key.nvim
-- ================================================================================

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		-- Don't show popup on `v`; wait until the next key in visual mode
		defer = function(ctx)
			return vim.list_contains({ "v", "V", "<C-V>" }, ctx.mode)
		end,
		spec = {
			-- leader prefix groups
			{ "<leader>f", group = "find" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>g", group = "git" },
			{ "<leader>t", group = "treesj" },
		},
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
			desc = "Help: buffer keymaps",
		},
	},
}

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
			{ "<leader>e", group = "explorer" },
			{ "<leader>d", group = "diagnostics" },
			{ "<leader>D", group = "docs" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>n", group = "icons" },
			{ "<leader>g", group = "git" },
			{ "<leader>G", group = "adjust (dot repeat)" },

			-- mappings without desc (plugin defaults / non-lazy keys)
			{ "-", desc = "Explorer: oil (split)" },
			{ "ys", desc = "Surround: add" },
			{ "ds", desc = "Surround: delete" },
			{ "cs", desc = "Surround: change" },
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

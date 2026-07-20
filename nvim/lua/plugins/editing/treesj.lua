-- ================================================================================
-- TITLE: Wansmer/treesj
-- ABOUT: splitting/joining blocks of code like arrays, objects, etc.
-- LINKS: https://github.com/Wansmer/treesj
-- ================================================================================

return {
	"Wansmer/treesj",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	keys = {
		{
			"<leader>tm",
			function()
				require("treesj").toggle()
			end,
			desc = "Split/join: toggle",
		},
		{
			"<leader>tj",
			function()
				require("treesj").join()
			end,
			desc = "Split/join: join",
		},
		{
			"<leader>ts",
			function()
				require("treesj").split()
			end,
			desc = "Split/join: split",
		},
	},
	config = function()
		require("treesj").setup({
			use_default_keymaps = false,
			check_syntax_error = true,
			max_join_length = 120,
			cursor_behavior = "hold",
			notify = true,
			dot_repeat = true,
		})
	end,
}

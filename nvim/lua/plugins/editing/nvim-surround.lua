-- ================================================================================
-- TITLE: kylechui/nvim-surround
-- ABOUT: Surround selections, stylishly
-- LINKS: https://github.com/kylechui/nvim-surround
-- ================================================================================

return {
	"kylechui/nvim-surround",
	version = "^4.0.0",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "folke/which-key.nvim" },
	config = function()
		require("nvim-surround").setup({
			aliases = {
				-- nearest ' or " or ``
				["q"] = { '"', "'", "`" },
			},
			highlight = {
				duration = 300,
			},
		})

		require("which-key").add({
			{ "ys", group = "surround (add)" },
			{ "yss", desc = "Surround current line", mode = "n" },
			{ "yS", desc = "Surround add (line-wise)", mode = "n" },
			{ "ySS", desc = "Surround current line (line-wise)", mode = "n" },
			{ "ysq", desc = 'Surround with nearest ", \', or `', mode = "n" },
			{ "ds", group = "surround (delete)" },
			{ "dsq", desc = 'Delete nearest ", \', or `', mode = "n" },
			{ "cs", group = "surround (change)" },
			{ "csq", desc = 'Change nearest ", \', or `', mode = "n" },
			{ "cS", desc = "Surround change (line-wise)", mode = "n" },
			{ "S", desc = "Surround selection", mode = "x" },
			{ "gS", desc = "Surround selection (line-wise)", mode = "x" },
		})
	end,
}

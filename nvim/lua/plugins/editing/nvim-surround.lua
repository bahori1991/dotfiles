-- ================================================================================
-- TITLE: kylechui/nvim-surround
-- ABOUT: Surround selections, stylishly
-- LINKS: https://github.com/kylechui/nvim-surround
-- ================================================================================

return {
	"kylechui/nvim-surround",
	version = "^4.0.0",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-surround").setup({
			-- nearest ' or " or ``
			aliases = {
				["q"] = { '"', "'", "`" },
			},
			highlight = {
				duration = 300,
			},
		})
	end,
}

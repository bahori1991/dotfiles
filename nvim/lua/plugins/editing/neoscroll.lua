-- ================================================================================
-- TITLE: karb94/neoscroll.nvim
-- ABOUT: A smooth scrolling neovim plugin
-- LINKS: https://github.com/karb94/neoscroll.nvim
-- ================================================================================

return {
	"karb94/neoscroll.nvim",
	event = "VeryLazy",
	config = function()
		local neoscroll = require("neoscroll")
		neoscroll.setup({
			mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" },
			hide_cursor = true,
			stop_eof = true,
			easing = "quadratic",
			duration_multiplier = 0.9,
		})
		-- zz: normal only (visual 選択中の center は通常不要)
		vim.keymap.set("n", "zz", function()
			neoscroll.zz({ half_win_duration = 250 })
		end)
	end,
}

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
			mappings = {},
			hide_cursor = true,
			stop_eof = true,
			easing = "quadratic",
			duration_multiplier = 0.9,
		})
		local modes = { "n", "v", "x" }
		local keymap = {
			["<C-u>"] = function()
				neoscroll.ctrl_u({ duration = 200 })
			end,
			["<C-d>"] = function()
				neoscroll.ctrl_d({ duration = 200 })
			end,
			["<C-f>"] = function()
				neoscroll.ctrl_f({ duration = 350 })
			end,
			["<C-b>"] = function()
				neoscroll.ctrl_b({ duration = 350 })
			end,
			["zz"] = function()
				neoscroll.zz({ half_win_duration = 200 })
			end,
		}
		for key, func in pairs(keymap) do
			vim.keymap.set(modes, key, func)
		end
	end,
}

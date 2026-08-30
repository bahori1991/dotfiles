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
		local window = require("neoscroll.window")

		local CURSOR_SCREEN_RATIO = 0.25

		local function position_cursor()
			local win = 0
			local cursor_line = vim.api.nvim_win_get_cursor(win)[1]
			local height = vim.api.nvim_win_get_height(win)
			local target_winline = math.max(1, math.floor(height * CURSOR_SCREEN_RATIO))
			local view = vim.fn.winsaveview()
			view.topline = math.max(1, cursor_line - target_winline + 1)
			vim.fn.winrestview(view)
		end

		local function with_after_scroll(after_scroll, opts)
			opts = opts or {}
			opts.info = { after_scroll = after_scroll }
			return opts
		end

		local function with_position(opts)
			return with_after_scroll(position_cursor, opts)
		end

		local function scroll_to_position()
			local window_height = vim.fn.winheight(0)
			local target_winline = math.max(1, math.floor(window_height * CURSOR_SCREEN_RATIO))
			local lines = vim.fn.winline() - target_winline
			if lines == 0 then
				return
			end

			local duration = math.floor(100 * (math.abs(lines) / (window_height / 2)) + 0.5)
			neoscroll.scroll(
				lines,
				with_position({
					move_cursor = false,
					duration = duration,
				})
			)
		end

		local function scroll_to_line(lines)
			if lines == 0 then
				position_cursor()
				return
			end

			local window_height = vim.fn.winheight(0)
			local duration = math.floor(100 * (math.abs(lines) / (window_height / 2)) + 0.5)
			neoscroll.scroll(
				lines,
				with_position({
					move_cursor = true,
					duration = duration,
				})
			)
		end

		neoscroll.setup({
			mappings = {
				"<C-b>",
				"<C-f>",
				"<C-y>",
				"<C-e>",
				"zt",
				"zb",
			},
			post_hook = function(info)
				if info and info.after_scroll then
					vim.schedule(info.after_scroll)
				end
			end,
		})

		vim.keymap.set("n", "<C-u>", function()
			neoscroll.ctrl_u(with_position({ duration = 100 }))
		end, { desc = "Scroll up half-page" })

		vim.keymap.set("n", "<C-d>", function()
			neoscroll.ctrl_d(with_position({ duration = 100 }))
		end, { desc = "Scroll down half-page" })

		vim.keymap.set("n", "zz", scroll_to_position, { desc = "Position cursor line" })

		vim.keymap.set("n", "gg", function()
			if vim.v.count > 0 then
				vim.cmd("normal! " .. vim.v.count .. "gg")
				position_cursor()
				return
			end

			scroll_to_line(-window.get_lines_above(vim.fn.line(".")))
		end, { desc = "Go to first line" })

		vim.keymap.set("n", "G", function()
			if vim.v.count > 0 then
				vim.cmd("normal! " .. vim.v.count .. "G")
				position_cursor()
				return
			end

			scroll_to_line(window.get_lines_below(vim.fn.line(".")))
		end, { desc = "Go to last line" })
	end,
}

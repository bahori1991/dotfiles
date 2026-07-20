-- ================================================================================
-- TITLE: petertriho/nvim-scrollbar
-- ABOUT: Extensible Neovim Scrollbar
-- LINKS: https://github.com/petertriho/nvim-scrollbar
-- ================================================================================

local colors = require("config.ui.colors")

return {
	"petertriho/nvim-scrollbar",
	event = "VeryLazy",
	opts = {
		handle = {
			text = " ",
			blend = 0,
			priority = 10,
			color = colors.gray[500],
			hide_if_all_visible = true,
		},
		marks = {
			Cursor = {
				priority = 0,
				text = "▌",
				color = colors.gray[100],
			},
			Search = { text = { "▌", "█" }, color = colors.cyan[500] },
			Error = { text = { "▌", "█" }, color = colors.red[500] },
			Warn = { text = { "▌", "█" }, color = colors.yellow[500] },
			Info = { text = { "▌", "█" }, color = colors.blue[500] },
			Hint = { text = { "▌", "█" }, color = colors.violet[500] },
			Misc = { text = { "▌", "█" }, color = colors.gray[400] },
		},
		excluded_filetypes = {
			"neo-tree",
			"dashboard",
			"dropbar_menu",
			"TelescopePrompt",
		},
	},
	config = function(_, opts)
		require("scrollbar").setup(opts)

		local group = vim.api.nvim_create_augroup("scrollbar_nvim_tree", { clear = true })

		local function render_in_window(winnr)
			if not winnr or not vim.api.nvim_win_is_valid(winnr) then
				return
			end
			vim.api.nvim_win_call(winnr, function()
				if vim.bo.filetype ~= "NvimTree" then
					return
				end
				require("scrollbar").render()
			end)
		end

		local function render_all_nvim_tree_windows()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local is_nvim_tree = vim.api.nvim_win_call(win, function()
					return vim.bo.filetype == "NvimTree"
				end)
				if is_nvim_tree then
					render_in_window(win)
				end
			end
		end

		local function setup_nvim_tree_hook()
			local ok, api = pcall(require, "nvim-tree.api")
			if not ok then
				return false
			end

			api.events.subscribe(api.events.Event.TreeRendered, function(data)
				vim.schedule(function()
					render_in_window(data and data.winnr)
				end)
			end)
			return true
		end

		if not setup_nvim_tree_hook() then
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "NvimTreeSetup",
				once = true,
				callback = setup_nvim_tree_hook,
			})
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "NvimTree",
			callback = function()
				vim.schedule(render_all_nvim_tree_windows)
			end,
		})

		vim.api.nvim_create_autocmd("WinEnter", {
			group = group,
			callback = function()
				if vim.bo.filetype == "NvimTree" then
					vim.schedule(function()
						render_in_window(0)
					end)
				end
			end,
		})
	end,
}

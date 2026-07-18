-- ======================================================================================
-- TITLE: nvimdev/dashboard-nvim
-- ABOUT: Fancy and Blazing Fast start screen plugin of Neovim
-- LINKS: https://github.com/nvimdev/dashboard-nvim
-- ======================================================================================

local logo = [[
                ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗                
                ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║                
█████╗█████╗    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║    █████╗█████╗
╚════╝╚════╝    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║    ╚════╝╚════╝
                ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║                
                ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝                
]]

logo = string.rep("\n", 2) .. logo .. "\n\n"

return {
	"nvimdev/dashboard-nvim",
	lazy = false,
	priority = 999,
	opts = {
		theme = "hyper",
		letter_list = "abcdefghilmnoprstuvwxyz",
		project = { enable = false },
		config = {
			header = vim.split(logo, "\n"),
			shortcut = {
				{ desc = " update", group = "@property", action = "Lazy update", key = "u" },
				{
					icon = " ",
					icon_hl = "@variable",
					desc = "files",
					group = "Label",
					action = "lua require('telescope.builtin').find_files({ cwd = vim.fn.getcwd() })",
					key = "f",
				},
				{
					desc = "󰗊 Grep",
					group = "DiagnosticHint",
					action = "Telescope live_grep",
					key = "g",
				},
				{
					desc = " dotfiles",
					group = "Number",
					action = "Telescope find_files cwd=~/.config/dotfiles",
					key = "d",
				},
			},
			footer = {},
		},
	},
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
	config = function(_, opts)
		require("dashboard").setup(opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "DashboardLoaded",
			callback = function()
				vim.schedule(function()
					if vim.bo.filetype ~= "dashboard" then
						return
					end
					vim.api.nvim_win_set_cursor(0, { 1, 0 })
					pcall(vim.fn.winrestview, { lnum = 1, col = 0, topline = 1, leftcol = 0 })
				end)
			end,
		})
	end,
}

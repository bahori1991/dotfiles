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

local function dashboard_footer()
	local lines = { "" }

	local version = vim.version()
	lines[#lines + 1] = string.format("Neovim %d.%d.%d", version.major, version.minor, version.patch)

	local cwd = vim.fn.getcwd()
	if vim.fn.isdirectory(cwd .. "/.git") == 1 then
		local branch = vim.fn.systemlist({ "git", "-C", cwd, "branch", "--show-current" })
		if vim.v.shell_error == 0 and branch[1] and branch[1] ~= "" then
			lines[#lines + 1] = "git: " .. branch[1]
		end
	end

	local ok, lazy = pcall(require, "lazy")
	if ok then
		for _, plugin in ipairs(lazy.plugins()) do
			if plugin.name == "dashboard-nvim" and plugin.commit then
				lines[#lines + 1] = "dashboard-nvim @" .. plugin.commit:sub(1, 7)
				break
			end
		end
	end

	return lines
end

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
			packages = { enable = true },
			shortcut = {
				{ desc = " update", group = "@property", action = "Lazy update", key = "u" },
				{
					icon = " ",
					icon_hl = "@variable",
					desc = "files",
					group = "Label",
					action = "lua require('config.navigation.telescope_pickers').find_files()",
					key = "f",
				},
				{
					desc = "󰋚 recent",
					group = "String",
					action = "lua require('telescope.builtin').oldfiles()",
					key = "o",
				},
				{
					desc = "󰈙 buffers",
					group = "Identifier",
					action = "lua require('telescope.builtin').buffers()",
					key = "b",
				},
				{
					desc = "󰗊 Grep",
					group = "DiagnosticHint",
					action = "lua require('config.navigation.telescope_pickers').live_grep()",
					key = "g",
				},
				{
					desc = " dotfiles",
					group = "Number",
					action = "Telescope find_files cwd=~/.config/dotfiles",
					key = "d",
				},
			},
			footer = dashboard_footer,
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

-- ================================================================================
-- TITLE: nvim-telescope/telescope.nvim
-- ABOUT: highly extendable fuzzy finder over lists
-- LINKS: https://github.com/nvim-telescope/telescope.nvim
-- ================================================================================

local colors = require("config.ui.colors")

--- Debian/Ubuntu ship fd as `fdfind`; other distros use `fd`.
local function fd_binary()
	if vim.fn.executable("fd") == 1 then
		return "fd"
	end
	if vim.fn.executable("fdfind") == 1 then
		return "fdfind"
	end
	return "fd"
end

local function find_files_command()
	return {
		fd_binary(),
		"--type",
		"f",
		"--follow",
		"--exclude",
		".git",
		"--exclude",
		"node_modules",
	}
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	opts = {
		pickers = {
			find_files = {
				hidden = true,
				find_command = find_files_command,
			},
			live_grep = {
				additional_args = function()
					return {
						"--hidden",
						"--glob",
						"!.git/**",
						"--glob",
						"!node_modules/**",
					}
				end,
			},
		},
	},
	config = function(_, opts)
		local builtin = require("telescope.builtin")

		--- Pin find_files to the cwd Neovim was opened from (not the current :cd).
		local initial_cwd = vim.fn.getcwd()

		local function find_files()
			builtin.find_files({ cwd = initial_cwd })
		end

		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Telescope commands" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope diagnostics" })
		vim.keymap.set(
			"n",
			"<leader>fe",
			"<cmd>Telescope diagnostics bufnr=0<cr>",
			{ desc = "Telescope current buffer" }
		)
		vim.keymap.set("n", "<leader>ff", find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

		vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.blue, bg = colors.bg })
		vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = colors.blue, bg = colors.bg })
		vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = colors.blue, bg = colors.bg })
		require("telescope").setup(opts)
	end,
}

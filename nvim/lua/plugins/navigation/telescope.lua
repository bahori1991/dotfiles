-- ================================================================================
-- TITLE: nvim-telescope/telescope.nvim
-- ABOUT: highly extendable fuzzy finder over lists
-- LINKS: https://github.com/nvim-telescope/telescope.nvim
-- ================================================================================

local colors = require("config.ui.colors")
local pickers = require("config.navigation.telescope_pickers")

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
		defaults = {
			layout_strategy = "horizontal",
			layout_config = {
				horizontal = {
					prompt_position = "bottom",
					preview_width = 0.55,
				},
			},
			path_display = { "truncate", "smart" },
		},
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

		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find: buffers" })
		vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Find: commands" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find: diagnostics" })
		vim.keymap.set(
			"n",
			"<leader>fe",
			"<cmd>Telescope diagnostics bufnr=0<cr>",
			{ desc = "Find: diagnostics (buffer)" }
		)
		vim.keymap.set("n", "<leader>ff", pickers.find_files, { desc = "Find: files" })
		vim.keymap.set("n", "<leader>fG", builtin.git_files, { desc = "Find: git files" })
		vim.keymap.set("n", "<leader>fg", pickers.live_grep, { desc = "Find: live grep" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find: help" })
		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Find: recent files" })

		vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.blue[500], bg = colors.gray[950] })
		vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = colors.blue[500], bg = colors.gray[950] })
		vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = colors.blue[500], bg = colors.gray[950] })

		require("telescope").setup(opts)
		pcall(require("telescope").load_extension, "fzf")
	end,
}

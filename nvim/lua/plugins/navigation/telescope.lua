-- ================================================================================
-- TITLE: nvim-telescope/telescope.nvim
-- ABOUT: highly extendable fuzzy finder over lists
-- LINKS: https://github.com/nvim-telescope/telescope.nvim
-- ================================================================================

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
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Find: buffers",
		},
		{
			"<leader>fc",
			function()
				require("telescope.builtin").commands()
			end,
			desc = "Find: commands",
		},
		{
			"<leader>fd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "Find: diagnostics",
		},
		{
			"<leader>fe",
			"<cmd>Telescope diagnostics bufnr=0<cr>",
			desc = "Find: diagnostics (buffer)",
		},
		{
			"<leader>ff",
			function()
				require("config.navigation.telescope_pickers").find_files()
			end,
			desc = "Find: files",
		},
		{
			"<leader>fG",
			function()
				require("telescope.builtin").git_files()
			end,
			desc = "Find: git files",
		},
		{
			"<leader>fg",
			function()
				require("config.navigation.telescope_pickers").live_grep()
			end,
			desc = "Find: live grep",
		},
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Find: help",
		},
		{
			"<leader>fo",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = "Find: recent files",
		},
		{
			"<leader>fn",
			"<cmd>Telescope noice<cr>",
			desc = "Find: notifications",
		},
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
		require("telescope").setup(opts)
		pcall(require("telescope").load_extension, "fzf")
	end,
}

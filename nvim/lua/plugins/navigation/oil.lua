-- ================================================================================
-- TITLE: stevearc/oil.nvim
-- ABOUT: Edit filesystem like a normal Neovim buffer
-- LINKS: https://github.com/stevearc/oil.nvim
--
-- Usage (with nvim-tree):
--   Sidebar explorer  -> <leader>e (nvim-tree)
--   In-buffer explorer -> - or <leader>O (oil, split)
--   Narrow tmux pane  -> <leader>Of (oil, float)
--
-- Oil buffer file operations (default keymaps; see :help oil-actions):
--   Rename/move/delete -> edit buffer text, then :w to apply
--   <CR>     open file or directory
--   <C-p>    preview file under cursor
--   gs       change sort
--   g.       toggle hidden files
--   g?       show keymaps help
--   <C-c>    close oil and return
-- ================================================================================

return {
	"stevearc/oil.nvim",
	---@module "oil"
	---@type oil.SetupOpts
	cmd = { "Oil" },
	opts = {
		default_file_explorer = false,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
		},
		preview_win = {
			update_on_cursor_moved = true,
		},
		float = {
			max_width = 0.9,
			max_height = 0.9,
		},
		keymaps = {
			["<C-h>"] = false,
			["<C-l>"] = false,
		},
	},
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	keys = {
		{
			"-",
			function()
				require("oil").open()
			end,
			desc = "Explorer: oil (split)",
		},
		{
			"<leader>O",
			function()
				require("oil").open_float()
			end,
			desc = "Explorer: oil (float)",
		},
	},
	config = function(_, opts)
		require("oil").setup(opts)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "oil",
			callback = function()
				vim.wo.winbar = ""
			end,
		})
	end,
}

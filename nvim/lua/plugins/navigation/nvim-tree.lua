-- ================================================================================
-- TITLE: nvim-tree/nvim-tree.lua
-- ABOUT: File Explorer for Neovim
-- LINKS: https://github.com/nvim-tree/nvim-tree.lua
-- ================================================================================

local anchor = require("config.navigation.nvim-tree-anchor")

return {
	"nvim-tree/nvim-tree.lua",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	---@module "nvim_tree"
	---@type nvim_tree.config
	opts = {
		sort = {
			sorter = "case_sensitive",
		},
		view = {
			width = 45,
			cursorlineopt = "line",
		},
		renderer = {
			highlight_git = "name",
			group_empty = true,
			icons = {
				git_placement = "right_align",
				glyphs = {
					git = {
						unstaged = "!",
						staged = "✓",
						unmerged = "",
						renamed = "R",
						untracked = "?",
						deleted = "D",
						ignored = "",
					},
				},
			},
		},
		filters = {
			dotfiles = false,
			git_ignored = false,
			custom = {
				"^\\.git$",
				"node_modules",
				"dist-newstyle",
			},
		},
		git = {
			enable = true,
			show_on_dirs = true,
			show_on_open_dirs = true,
			timeout = 1000,
		},
		prefer_startup_root = true,
		-- Match Telescope initial_cwd anchor; do not follow :cd.
		sync_root_with_cwd = false,
		update_focused_file = {
			enable = true,
			update_root = {
				-- Root is set manually in nvim-tree-open; auto update_root races with change_root.
				enable = false,
				ignore_list = { "dashboard", "NvimTree" },
			},
		},
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")
			api.map.on_attach.default(bufnr)
		end,
	},
	config = function(_, opts)
		opts.update_focused_file.exclude = function(args)
			local ft = vim.bo[args.buf].filetype
			if ft == "dashboard" or ft == "NvimTree" or ft == "" then
				return true
			end
			local path = vim.api.nvim_buf_get_name(args.buf)
			if path == "" then
				return true
			end
			-- Skip tree updates for files outside the startup project.
			return not anchor.under_root(path, anchor.get_anchor_root())
		end

		require("nvim-tree").setup(opts)

		vim.keymap.set("n", "<leader>e", function()
			local api = require("nvim-tree.api")
			local view = require("nvim-tree.view")
			if view.is_visible() then
				api.tree.close()
			else
				local root = anchor.get_anchor_root()
				api.tree.open({ find_file = true, update_root = false })
				api.tree.change_root(root)
				api.tree.find_file()
			end
		end, { desc = "Explorer: tree toggle" })
	end,
}

-- ================================================================================
-- TITLE: nvim-tree/nvim-tree.lua
-- ABOUT: File Explorer for Neovim
-- LINKS: https://github.com/nvim-tree/nvim-tree.lua
-- ================================================================================

local anchor = require("config.navigation.nvim-tree-anchor")

return {
	"nvim-tree/nvim-tree.lua",
	event = { "BufReadPost", "BufNewFile" },
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
				enable = true,
				ignore_list = { "dashboard", "NvimTree" },
			},
		},
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")
			api.map.on_attach.default(bufnr)
		end,
	},
	keys = {
		{ "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Explorer: tree toggle" },
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
		local tree_opened = false
		local buf_enter_group = vim.api.nvim_create_augroup("NvimTreeOpenOnFile", { clear = true })

		local function open_tree()
			if tree_opened then
				return
			end
			if vim.bo.filetype == "dashboard" or vim.bo.filetype == "NvimTree" then
				return
			end
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "dashboard" then
					return
				end
			end
			local api = require("nvim-tree.api")
			local root = anchor.get_anchor_root()
			if not require("nvim-tree.view").is_visible() then
				api.tree.open({ find_file = false, update_root = false })
				api.tree.change_root(root)
				api.tree.find_file()
			else
				api.tree.change_root(root)
				api.tree.find_file()
			end
			tree_opened = true
			vim.api.nvim_clear_autocmds({ group = buf_enter_group, event = "BufEnter" })

			-- focus on Editor pane
			vim.schedule(function()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
					if ft ~= "NvimTree" then
						vim.api.nvim_set_current_win(win)
						break
					end
				end
			end)
		end

		local function has_startup_files()
			for i = 0, vim.fn.argc() - 1 do
				local arg = vim.fn.argv(i)
				if arg ~= nil and arg ~= "" then
					return true
				end
			end
			return false
		end

		-- When open Neovim with specified file
		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,
			callback = function()
				if has_startup_files() then
					vim.defer_fn(open_tree, 50)
				end
			end,
		})
		-- When open file from dashboard (cleared after first open)
		vim.api.nvim_create_autocmd("BufEnter", {
			group = buf_enter_group,
			callback = function(args)
				if tree_opened then
					return
				end
				local ft = vim.bo[args.buf].filetype
				if ft == "dashboard" or ft == "NvimTree" or ft == "" then
					return
				end
				vim.schedule(open_tree)
			end,
		})
	end,
}

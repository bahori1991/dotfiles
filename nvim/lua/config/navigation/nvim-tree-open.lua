-- ================================================================================
-- TITLE: nvim-tree-open
-- ABOUT: Auto-open nvim-tree when entering a real file buffer (independent of lazy timing)
-- ================================================================================

local anchor = require("config.navigation.nvim-tree-anchor")

local M = {}

local tree_opened = false
local opening = false
local autocmd_group = nil

---@param buf? number
---@return boolean
function M.should_open(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	if not vim.api.nvim_buf_is_valid(buf) then
		return false
	end
	if vim.bo[buf].buftype ~= "" then
		return false
	end
	local ft = vim.bo[buf].filetype
	if ft == "dashboard" or ft == "NvimTree" or ft == "" then
		return false
	end
	if vim.api.nvim_buf_get_name(buf) == "" then
		return false
	end
	return true
end

function M.open_tree()
	if tree_opened or opening then
		return
	end
	if not M.should_open() then
		return
	end

	opening = true

	require("lazy").load({ plugins = { "nvim-tree.lua" } })

	vim.schedule(function()
		if tree_opened then
			opening = false
			return
		end
		if not M.should_open() then
			opening = false
			return
		end

		local ok, err = pcall(function()
			local api = require("nvim-tree.api")
			local root = anchor.get_anchor_root()
			if not require("nvim-tree.view").is_visible() then
				api.tree.open({ find_file = false, update_root = false })
			end
			api.tree.change_root(root)
			api.tree.find_file()
		end)

		if not ok then
			opening = false
			vim.notify("nvim-tree: " .. tostring(err), vim.log.levels.ERROR)
			return
		end

		tree_opened = true
		opening = false

		if autocmd_group then
			vim.api.nvim_clear_autocmds({ group = autocmd_group })
		end

		vim.schedule(function()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
				if ft ~= "NvimTree" then
					vim.api.nvim_set_current_win(win)
					break
				end
			end
		end)
	end)
end

---@param args? vim.api.keyset.create_autocmd.callback_args
local function try_open_tree(args)
	if tree_opened then
		return
	end
	if not M.should_open(args and args.buf) then
		return
	end
	M.open_tree()
end

function M.setup()
	autocmd_group = vim.api.nvim_create_augroup("NvimTreeOpenOnFile", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost", "FileType" }, {
		group = autocmd_group,
		callback = try_open_tree,
	})
end

return M

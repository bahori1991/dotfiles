-- ================================================================================
-- TITLE: nvim-tree-anchor
-- ABOUT: Anchor root resolution for nvim-tree (git root or startup cwd)
-- ================================================================================

local M = {}

local anchor_root = nil

---@param path string
---@return string
function M.normalize_path(path)
	if path == "" then
		return ""
	end
	return vim.fn.fnamemodify(path, ":p"):gsub("/+$", "")
end

---@param path string
---@param root string
---@return boolean
function M.under_root(path, root)
	path = M.normalize_path(path)
	root = M.normalize_path(root)
	if path == "" or root == "" then
		return false
	end
	return path == root or path:find(root .. "/", 1, true) == 1
end

---@param path string
---@return string
function M.resolve_anchor_root(path)
	path = M.normalize_path(path)
	if path == "" then
		return M.normalize_path(vim.fn.getcwd())
	end
	if vim.fn.isdirectory(path) == 0 then
		path = vim.fn.fnamemodify(path, ":h")
	end
	local git_dir = vim.fs.find(".git", { path = path, upward = true })[1]
	if git_dir then
		return M.normalize_path(vim.fn.fnamemodify(git_dir, ":h"))
	end
	return M.normalize_path(vim.fn.getcwd())
end

---@return string
function M.get_anchor_root()
	if anchor_root then
		return anchor_root
	end
	local path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	anchor_root = M.resolve_anchor_root(path)
	return anchor_root
end

return M

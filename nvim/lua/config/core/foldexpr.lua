local M = {}

--- Safe treesitter foldexpr; returns "0" before parsers are available.
function M.expr()
	local ok, result = pcall(vim.treesitter.foldexpr)
	return ok and result or "0"
end

return M

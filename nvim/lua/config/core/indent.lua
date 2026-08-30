local M = {}

--- Treesitter indent with fallback to the previous non-blank line's indent.
function M.expr()
	local ok, result = pcall(require("nvim-treesitter").indentexpr)
	if ok and type(result) == "number" and result > 0 then
		return result
	end

	local lnum = vim.v.lnum
	local prev = vim.fn.prevnonblank(lnum - 1)
	if prev > 0 then
		return vim.fn.indent(prev)
	end
	return 0
end

return M

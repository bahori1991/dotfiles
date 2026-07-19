-- ================================================================================
-- TITLE: startup/argv.lua
-- ABOUT: Drop empty argv entries (e.g. Cursor embed) before argc() checks
-- ================================================================================

-- Reverse order: argdelete! shifts later indices; backward walk keeps them stable.
for i = vim.fn.argc() - 1, 0, -1 do
	local arg = vim.fn.argv(i)
	if arg == "" then
		pcall(vim.cmd, string.format("%dargdelete!", i + 1))
	end
end

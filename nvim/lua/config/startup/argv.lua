-- ================================================================================
-- TITLE: startup/argv.lua
-- ABOUT: Drop empty argv entries (e.g. Cursor embed) before argc() checks
-- ================================================================================

for i = vim.fn.argc() - 1, 0, -1 do
  if vim.fn.argv(i) == "" then
    pcall(vim.cmd, string.format("%dargdelete!", i + 1))
  end
end

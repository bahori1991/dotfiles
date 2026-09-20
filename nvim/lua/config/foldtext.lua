-- =====================================================================================================
-- TITLE: foldtext
-- ABOUT: set message of folded text
-- =====================================================================================================

local M = {}

function M.get()
  local start = vim.v.foldstart
  local count = vim.v.foldend - start + 1
  local line = vim.fn.getline(start):gsub("\t", " ")
  if #line > 60 then
    line = line:sub(1, 57) .. "..."
  end
  return string.format("%s --- %d lines folded ---", line, count)
end

return M

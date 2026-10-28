-- =====================================================================================================
-- TITLE: csharp-semicolon.lua
-- ABOUT: Insert missnig semicolons (CS1002) in C# files on save via LSP code actions
-- =====================================================================================================

local M = {}

function M.fix_missing_semicolons(bufnr)
  local diagnostics = vim.tbl_filter(function(d)
    return tostring(d.code) == "CS1002"
  end, vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }))

  table.sort(diagnostics, function(a, b)
    if a.lnum == b.lnum then
      return a.col > b.col
    end
    return a.lnum > b.lnum
  end)

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for _, d in ipairs(diagnostics) do
    local row, col = d.lnum, d.col

    -- CS1002 at end of file or on a blank line: the ';' belongs to the nearest preceding non-blank line
    if row >= #lines or lines[row + 1]:match("^%s*$") then
      row = math.min(row, #lines) - 1
      while row >= 0 and lines[row + 1]:match("^%s*$") do
        row = row - 1
      end
      col = row >= 0 and #lines[row + 1] or 0
    end

    -- Diagnostics can be stale (the buffer changed since the last LSP publish), so skip positions that no longer exist
    if row >= 0 and col <= #lines[row + 1] then
      vim.api.nvim_buf_set_text(bufnr, row, col, row, col, { ";" })
    end
  end
end

return M

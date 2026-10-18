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

  for _, d in ipairs(diagnostics) do
    vim.api.nvim_buf_set_text(bufnr, d.lnum, d.col, d.lnum, d.col, { ";" })
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.cs",
  callback = function(args)
    M.fix_missing_semicolons(args.buf)
  end,
})

return M

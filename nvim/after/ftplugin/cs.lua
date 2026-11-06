-- =====================================================================================================
-- TITLE: cs.lua
-- ABOUT: C# (Allman style): <CR> between "{}" moves "{" onto its own line
-- =====================================================================================================

vim.keymap.set("i", "<CR>", function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  if line:sub(col, col) ~= "{" or line:sub(col + 1, col + 1) ~= "}" then
    local global = vim.iter(vim.api.nvim_get_keymap("i")):find(function(m)
      return m.lhs == "<CR>"
    end)
    local keys = global and (global.callback and global.callback() or global.rhs) or "<CR>"
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
    return
  end
  local indent = line:match("^%s*")
  local head = line:sub(1, col - 1):gsub("%s+$", "")
  local unit = string.rep(" ", vim.fn.shiftwidth())
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, {
    head,
    indent .. "{",
    indent .. unit,
    indent .. "}" .. line:sub(col + 2),
  })
  vim.api.nvim_win_set_cursor(0, { row + 2, #indent + #unit })
end, { buffer = true, desc = "C#: Allman brace on <CR>" })

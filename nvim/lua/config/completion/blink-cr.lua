-- ======================================================================================
-- TITLE: saghen/blink-cr
-- ABOUT: Indent guides with scope on every keystroke
-- LINKS: https://github.com/saghen/blink.indent
-- ======================================================================================

local M = {}
function M.fix_indent(keys)
  if not keys then return nil end
  if keys:find("<C%-o>O") then
    return vim.api.nvim_replace_termcodes(
      "<c-g>u<cr><cmd>normal! ====<cr><up><end><cr>",
      true, true, true
    )
  end
  if keys:find("<C%-%]><cr>") or keys == vim.api.nvim_replace_termcodes("<cr>", true, true, true) then
    return vim.api.nvim_replace_termcodes(
      "<cr><cmd>normal! ==<cr>",
      true, true, true
    )
  end
  return keys
end
return M

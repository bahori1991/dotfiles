-- =====================================================================================================
-- TITLE: indent.lua
-- ABOUT: set indent by filetype
-- =====================================================================================================

local function set_indent(width)
  vim.bo.expandtab = true
  vim.bo.tabstop = width
  vim.bo.shiftwidth = width
  vim.bo.softtabstop = width
end

local indent_4 = {
  cs = true,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function(args)
    local ft = args.match
    if indent_4[ft] then
      set_indent(4)
    else
      set_indent(2)
    end
  end,
})

-- =====================================================================================================
-- TITLE: lukas-reineke/virt-column.nvim
-- ABOUT: Display a character as the colorcolumn
-- LINKS: https://github.com/lukas-reineke/virt-column.nvim
-- =====================================================================================================

return {
  "lukas-reineke/virt-column.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    char = "┊",
    virtcolumn = "100",
    highlight = "VirtColumn",
  },
}

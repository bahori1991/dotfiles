-- =====================================================================================================
-- TITLE: Wansmer/treesj
-- ABOUT: Split/join blocks of code (arrays, objects, arguments, etc...)
-- LINKS: https://github.com/Wansmer/treesj
-- =====================================================================================================

return {
  "Wansmer/treesj",
  version = "*",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    {
      "<leader>j",
      function()
        require("treesj").toggle()
      end,
      desc = "Toggle Split/Join (TreeSJ)",
    },
    {
      "<leader>J",
      function()
        require("treesj").toggle({ split = { recursive = true } })
      end,
      desc = "Toggle Recursive (TreeSJ)",
    },
  },
  opts = {
    use_default_keymaps = false,
    check_syntax_error = true,
    max_join_length = 120,
    cursor_behavior = "hold",
    notify = true,
    dot_repeat = false,
  },
}

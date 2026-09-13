-- =====================================================================================================
-- TITLE: saghen/blink.indent 
-- ABOUT: Indent guides with scope on every keystroke
-- LINKS: https://github.com/saghen/blink.indent
-- =====================================================================================================

return {
  "saghen/blink.indent",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    static = {
      enabled = true,
      char = "┊",
      highlights = { "BlinkIndent" },
    },
    scope = {
      enabled = true,
      char = "┊",
      highlights = { "BlinkIndentBlue" },
      underline = {
        enabled = false,
      }
    },
    blocked = {
      buftypes = { include_defaults = true },
      filetypes = {
        include_defaults = true,
        "oil",
      }
    }
  }
}

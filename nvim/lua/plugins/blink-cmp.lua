-- =====================================================================================================
-- TITLE: saghen/blink.cmp
-- ABOUT: Completion plugin with support for LSPs, cmdline, signature help and snippets
-- LINKS: https://github.com/saghen/blink.cmp
-- =====================================================================================================

local blink_cmp_transform = require("config.blink-cmp-transform")

return {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdLineEnter" },
  opts = {
    keymap = {
      preset = "super-tab",
    },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      documentation = { auto_show = false },
      menu = {
        border = "none",
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", gap = 1 },
            { "kind" },
          },
        },
      },
    },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        lsp = {
          transform_items = blink_cmp_transform.single_to_double_quoted,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
}

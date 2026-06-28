-- ======================================================================================
-- TITLE: saghen/blink.cmp
-- ABOUT: Completion plugin with support for LSPs, cmdline, signature help and snippets.
-- LINKS: https://github.com/saghen/blink.cmp
-- ======================================================================================

return {
  "saghen/blink.cmp",
  version = "1.*",
  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "select_and_accept", "fallback" },
      ["<C-CR>"] = { "fallback" },
      ["<Up>"] = { "fallback" },
      ["<Down>"] = { "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    signature = {
      window = { winblend = 15 },
    },
    completion = {
      keyword = { range = "full" },
      accept = { auto_brackets = { enabled = true }, },
      list = { selection = { preselect = true, auto_insert = true } },
      menu = { winblend = 15 },
      documentation = {
        window = {
          winblend = 15
        },
      },
    },
    sources = {
      default = { "lazydev", "lsp", "path", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning"
    },
  },
  opts_extend = { "sources.default" },
  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
}


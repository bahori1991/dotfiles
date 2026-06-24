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
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      keyword = { range = "full" },
      accept = { auto_brackets = { enabled = true }, },
      list = { selection = { preselect = true, auto_insert = true } },
    },
    sources = {
      default = { "lsp", "path" },
    },
    fuzzy = {
      implementation = "prefer_rust_with_warning"
    },
  },
  opts_extend = { "sources.default" },
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1f2335" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "#1f2335", fg = "#3b4261" })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#2b324a", fg = "NONE" })
  end,
}


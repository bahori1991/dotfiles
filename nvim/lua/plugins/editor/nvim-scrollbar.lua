-- ================================================================================
-- TITLE: petertriho/nvim-scrollbar
-- ABOUT: Extensible Neovim Scrollbar
-- LINKS: https://github.com/petertriho/nvim-scrollbar
-- ================================================================================

local colors = require("config.colors")

return {
  "petertriho/nvim-scrollbar",
  event = { "BufReadPre", "BufNewFile"},
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "kevinhwang91/nvim-hlslens",
  },
  opts = {
    handle = {
      text = " ",
      blend = 0,
      priority = 10,
      color = colors.gray,
    },
    handlers = {
      gitsigns = true,
      hlslens = true,
    },
    marks = {
      Cursor = {
        priority = 0,
        text = "*",
        color = colors.fg,
      },
      Search = { text = { "✔", "✔" }, color = colors.cyan },
      Error = { text = { "✘", "✘" } },
      Warn = { text = { "!", "!" } },
      Info = { text = { "i", "i" } },
      Hint = { text = { "★", "★" } },
      Misc = { text = { " ", " " } },
      GitAdd = {
        text = "█",
        priority = 7,
        gui = nil,
        color = colors.green,
        cterm = nil,
        color_nr = nil, -- cterm
        highlight = "GitSignsAdd",
      },
      GitChange = {
        text = "█",
        priority = 7,
        gui = nil,
        color = colors.yellow,
        cterm = nil,
        color_nr = nil, -- cterm
        highlight = "GitSignsChange",
      },
      GitDelete = {
        text = "█",
        priority = 7,
        gui = nil,
        color = colors.red,
        cterm = nil,
        color_nr = nil, -- cterm
        highlight = "GitSignsDelete",
      },
    },
    excluded_filetypes = {
      "neo-tree",
      "dashboard",
      "dropbar_menu",
      "TelescopePrompt",
    }
  },
  config = function(_, opts)
    require("scrollbar").setup(opts)
  end,
}

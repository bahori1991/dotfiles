-- =====================================================================================================
-- TITLE: Bekaboo/dropbar.nvim
-- ABOUT: IDE-like breadcrumbs, out of the box
-- LINKS: https://github.com/Bekaboo/dropbar.nvim
-- =====================================================================================================

local settings = require("config.dropbar")
return {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  opts = {
    bar = {
      hover = false,
      enable = settings.enable,
      sources = settings.sources,
    },
    sources = {
      path = {
        relative_to = settings.path_relative_to,
      },
    },
    symbol = { on_click = false },
    menu = {
      hover = false,
      keymaps = {
        ["<LeftMouse>"] = "<Nop>",
        ["<MouseMove>"] = "<Nop>",
      },
    },
    fzf = {
      fuzzy_find_on_click = false,
      keymaps = {
        ["<LeftMouse>"] = "<Nop>",
        ["<MouseMove>"] = "<Nop>",
      },
    },
  },
  config = function(_, opts)
    require("dropbar").setup(opts)
    local api = require("dropbar.api")
    vim.keymap.set("n", "<leader>;", api.goto_context_start, {
      desc = "Go to start of current context (Dropbar)",
    })
  end,
}

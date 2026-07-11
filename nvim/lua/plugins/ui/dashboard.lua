-- ======================================================================================
-- TITLE: nvimdev/dashboard-nvim
-- ABOUT: Fancy and Blazing Fast start screen plugin of Neovim
-- LINKS: https://github.com/nvimdev/dashboard-nvim
-- ======================================================================================

local logo = [[
                ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗                
                ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║                
█████╗█████╗    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║    █████╗█████╗
╚════╝╚════╝    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║    ╚════╝╚════╝
                ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║                
                ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝                
]]

logo = string.rep("\n", 2) .. logo .. "\n\n"

-- local find_dotfiles = function()
--   local builtin = require("telescope.builtin")
--   builtin.find_files({
--     cwd = "~/.config/dotfiles",
--     hidden = true,
--   })
-- end

return {
  "nvimdev/dashboard-nvim",
  lazy = false,
  priority = 999,
  opts = {
    theme = "hyper",
    project = { enable = false },
    config = {
      header = vim.split(logo, "\n"),
      shortcut = {
        { desc = " update", group = "@property", action = "Lazy update", key = "u" },
        {
          icon = " ",
          icon_hl = "@variable",
          desc = "files",
          group = "Label",
          action = "Telescope find_files",
          key = "f",
        },
        {
          desc = "󰗊 Grep",
          group = "DiagnosticHint",
          action = "Telescope live_grep",
          key = "g",
        },
        {
          desc = " dotfiles",
          group = "Number",
          action = "Telescope find_dotfiles",
          key = "d",
        },
      },
      footer = {},
    },
  },
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
  config = function(_, opts)
    require("dashboard").setup(opts)
  end,
}

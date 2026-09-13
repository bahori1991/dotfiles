-- =====================================================================================================
-- TITLE: rcarriga/nvim-notify
-- ABOUT: Fancy notification manager for Neovim
-- LINKS: https://github.com/rcarriga/nvim-notify
-- =====================================================================================================

return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  opts = {
    top_down = false,
    render = "default",
    stages = "static",
    timeout = 2000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    icons = {
      ERROR = " ",
      WARN = " ",
      INFO = " ",
      DEBUG = " ",
      TRACE = "✎ ",
    },
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}

-- =====================================================================================================
-- TITLE: GustavEikaas/easy-dotnet.nvim
-- ABOUT: .NET development in Neovim
-- LINKS: https://github.com/GustavEikaas/easy-dotnet.nvim
-- =====================================================================================================

local env = require("config.lsp-env")
return {
  "GustavEikaas/easy-dotnet.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-dap",
  },
  lazy = false,
  cond = function()
    return env.dotnet_lsp_available()
  end,
  cmd = "Dotnet",
  opts = {
    picker = "telescope",
    lsp = {
      enabled = true,
      auto_refresh_codelens = false,
    },
    notifications = {
      -- 起動時の "Initializing..." 通知を出さず、失敗時のみ通知する
      handler = function()
        return function(finished_event)
          if not finished_event.success then
            vim.notify(finished_event.result.msg, vim.log.levels.ERROR)
          end
        end
      end,
    },
  },
  config = function(_, opts)
    require("easy-dotnet").setup(opts)
  end,
}

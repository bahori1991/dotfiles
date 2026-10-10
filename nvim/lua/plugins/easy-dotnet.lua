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
  ft = { "cs", "csharp", "cshtml", "csproj", "dotnetprops" },
  cond = function()
    return env.dotnet_lsp_available()
  end,
  cmd = "Dotnet",
  opts = {
    picker = "telescope",
    lsp = {
      enabled = true,
    },
  },
  config = function(_, opts)
    require("easy-dotnet").setup(opts)
  end,
}

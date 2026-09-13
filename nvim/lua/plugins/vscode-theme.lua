-- =====================================================================================================
-- TITLE: mofiqul/vscode.nvim
-- ABOUT: Neovim color theme like VsCode
-- LINKS: https://github.com/mofiqul/vscode.nvim
-- =====================================================================================================

local overrides = require("config.vscode-overrides")
return {
  "mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  opts = function()
    local c = require("vscode.colors").get_colors()
    return {
      color_overrides = overrides.color_overrides,
      group_overrides = overrides.build_group_overrides(c),
    }
  end,
  config = function(_, opts)
    require("vscode").setup(opts)
    vim.cmd.colorscheme("vscode")
  end,
}

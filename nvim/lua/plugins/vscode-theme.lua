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
  opts = {
    color_overrides = overrides.color_overrides,
  },
  config = function(_, opts)
    require("vscode").setup(opts)
    local vscode_config = require("vscode.config")
    local c = require("vscode.colors").get_colors()
    vscode_config.opts.group_overrides = overrides.build_group_overrides(c)
    vim.cmd.colorscheme("vscode")
  end,
}

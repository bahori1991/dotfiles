-- =====================================================================================================
-- TITLE: nvim-tree/nvim-web-devicons
-- ABOUT: Provides Nerd Font icons (glyphs) for use by Neovim plugins
-- LINKS: https://github.com/nvim-tree/nvim-web-devicons
-- =====================================================================================================

local node_js = {
  icon = "",
  color = "#417e38",
  cterm_color = "28",
  name = "PackageJson",
}

local docker_compose = {
  icon = "󰡨",
  color = "#38a89d",
  cterm_color = "68",
  name = "DockerCompose",
}

return {
  "nvim-tree/nvim-web-devicons",
  lazy = false,
  priority = 1000,
  config = function()
    require("nvim-web-devicons").setup({
      override_by_filename = {
        ["package.json"] = node_js,
        ["compose.yaml"] = docker_compose,
        ["compose.personal.yaml"] = docker_compose,
      },
    })
  end,
}

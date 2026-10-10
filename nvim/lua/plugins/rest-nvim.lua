-- =====================================================================================================
-- TITLE: rest-nvim/rest.nvim
-- ABOUT: HTTP client in Neovim
-- LINKS: https://github.com/rest-nvim/rest.nvim
-- =====================================================================================================

local function luarocks_style_path(plugin)
  package.path = plugin.dir .. "/?.lua;" .. plugin.dir .. "/?/init.lua;" .. package.path
end

return {
  "rest-nvim/rest.nvim",
  ft = { "http" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "j-hui/fidget.nvim",
    {
      "lunarmodules/lua-mimetypes",
      init = luarocks_style_path,
    },
    {
      "manoelcampos/xml2lua",
      init = luarocks_style_path,
    },
  },
  config = function()
    vim.g.rest_nvim = {
      _log_level = "DEBUG",
      env = {
        enable = true,
        pattern = ".*%.env.*",
      },
      response = {
        hooks = {
          format = true,
        },
      },
    }
    vim.keymap.set("n", "<leader>rr", "<cmd>belowright horizontal Rest run<cr>", {
      buffer = true,
      desc = "Run HTTP Request (rest.nvim)",
    })
  end,
}

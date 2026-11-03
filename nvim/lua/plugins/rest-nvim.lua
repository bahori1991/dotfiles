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
    local fidget_handle = require("fidget.progress.handle")
    local create = fidget_handle.create
    fidget_handle.create = function(msg)
      if msg and msg.lsp_client and msg.lsp_client.name == "rest.nvim" then
        return {
          report = function() end,
          finish = function() end,
          cancel = function() end,
        }
      end
      return create(msg)
    end
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
    vim.keymap.set("n", "<leader>rr", function()
      vim.cmd("belowright horizontal Rest run")
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.b[buf].__pane_group == "rest_nvim_result" then
          vim.api.nvim_set_current_win(win)
          break
        end
      end
    end, {
      buffer = true,
      desc = "Run HTTP Request (rest.nvim)",
    })
  end,
}

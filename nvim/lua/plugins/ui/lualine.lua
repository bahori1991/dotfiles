-- ================================================================================
-- TITLE: nvim-lualine/lualine.nvim
-- ABOUT: configure Neovim statusline written in lua
-- LINKS: https://github.com/nvim-lualine/lualine.nvim
-- ================================================================================

local lualine_theme = require("config.ui.lualine-theme")

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0})
  if next(clients) == nil then return "no LSP" end
  local client_names = {}
  for _, client in pairs(clients) do
    table.insert(client_names, client.name)
  end
  return "LSP: " .. table.concat(client_names, ", ")
end

local function current_time()
  return " " .. os.date("%Y/%m/%d %H:%M")
end

local function line_status()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return "row:" .. vim.fn.line(".") .. "/" .. vim.fn.line("$") .. " col:" .. (col + 1)
end

local sections = {
  lualine_a = {
    { "mode" },
  },
  lualine_b = {
    { "branch" },
  },
  lualine_c = {
    { "diagnostics", symbols = { error = ' ', warn = ' ', info = ' ', hint = ' '} },
    { "diff", symbols = { added = "+", modified = '*', removed = "-" } },
  },
  lualine_x = {},
  lualine_y = {
    "encoding",
    "filetype",
    { line_status },
  },
  lualine_z = {
    { lsp_clients },
    { current_time },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup {
      options = {
        theme = lualine_theme.build,
        always_divide_middle = true,
        disabled_filetypes = { "NvimTree" },
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = sections,
      tabline = {},
      extensions = {},
    }
  end,
}

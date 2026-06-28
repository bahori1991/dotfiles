-- ================================================================================
-- TITLE: nvim-lualine/lualine.nvim
-- ABOUT: configure Neovim statusline written in lua
-- LINKS: https://github.com/nvim-lualine/lualine.nvim
-- ================================================================================

local colors = require("config.colors")


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

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local theme = require("lualine.themes.auto")
    local function set_mode_colors(mode, accent)
      theme[mode].a = { fg = colors.bg, bg = accent, gui = "bold" }
      theme[mode].b = { fg = colors.fg, bg = colors.gray }
      theme[mode].c = { fg = colors.fg, bg = colors.bg }
    end

    set_mode_colors("normal", colors.green)
    set_mode_colors("insert", colors.blue)
    set_mode_colors("visual", colors.orange)
    set_mode_colors("replace", colors.violet)
    set_mode_colors("terminal", colors.yellow)
    set_mode_colors("command", colors.cyan)

    require("lualine").setup {
      options = {
        theme = theme,
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {
          { "mode" },
        },
        lualine_b = {
          { "branch" },
        },
        lualine_c = {
          { "diagnostics", symbols = { error = ' ', warn = ' ', info = ' ', hint = ' '} },
          { "diff", symbols = { added = "+", modified = '*', removed = "-" } },
          { "filename", path = 1 },
        },
        lualine_x = {
        },
        lualine_y = {
          "encoding",
          "filetype",
          { line_status },
        },
        lualine_z = {
          { lsp_clients },
          { current_time },
        }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}


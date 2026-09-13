-- =====================================================================================================
-- TITLE: nvim-lualine/lualine.nvim
-- ABOUT: Configure Neovim statusline
-- LINKS: https://github.com/nvim-lualine/lualine.nvim
-- =====================================================================================================

local function line_status()
  local row = vim.fn.line(".") .. "/" .. vim.fn.line("$")
  local col = vim.fn.virtcol(".")
  return "row:" .. row .. " col:" .. col
end

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return "no LSP"
  end
  local names = {}
  for _, client in pairs(clients) do
    table.insert(names, client.name)
  end
  return "LSP: " .. table.concat(names, ", ")
end

local function lsp_status()
  local noice = package.loaded["noice"] and require("noice")
  ---@diagnostic disable-next-line: undefined-field
  if noice and noice.api.status.lsp_progress.has() then
    ---@diagnostic disable-next-line: undefined-field
    local msg = noice.api.status.lsp_progress.get() or ""
    if msg:lower():find("workspace") then
      return lsp_clients()
    end
    if #msg > 40 then
      return msg:sub(1, 37) .. "..."
    end
    return msg
  end
  return lsp_clients()
end

local overrides = require("config.vscode-overrides")
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "mofiqul/vscode.nvim",
  },
  opts = function()
    local c = require("vscode.colors").get_colors()
    return {
      options = {
        theme = overrides.build_lualine_theme(c),
        globalstatus = true,
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "filename",
            path = 0,
            file_status = true,
            shorting_target = 40,
            symbols = {
              modified = "[Modified]",
              readonly = "[Readonly]",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
          },
        },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { lsp_status },
        lualine_z = { line_status },
      },
    }
  end,
}

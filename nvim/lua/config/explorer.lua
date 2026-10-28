-- =====================================================================================================
-- TITLE: explorer.lua
-- ABOUT: Pick the C# solution explorer or nvim-tree, toggle it, and open it when a file is opened
-- =====================================================================================================

local env = require("config.lsp-env")

local M = {}

local function has_solution_in_cwd()
  local cwd = vim.fn.getcwd()
  return vim.fn.glob(cwd .. "/*.slnx") ~= "" or vim.fn.glob(cwd .. "/*.sln") ~= ""
end

function M.use_solution_explorer()
  return env.dotnet_lsp_available() and has_solution_in_cwd()
end

-- run fn and return focus to the window that was active before it
local function keep_focus(fn)
  local prev_win = vim.api.nvim_get_current_win()
  fn()
  if vim.api.nvim_win_is_valid(prev_win) then
    vim.api.nvim_set_current_win(prev_win)
  end
end

local function toggle_nvim_tree()
  require("nvim-tree.api").tree.toggle({ focus = false, find_file = true })
end

local function toggle_solution_explorer()
  -- csharp-explorer moves focus into its split on open; return focus to the editor
  keep_focus(function()
    vim.cmd("CSharpExplorer")
  end)
end

function M.toggle()
  if M.use_solution_explorer() then
    toggle_solution_explorer()
  else
    toggle_nvim_tree()
  end
end

local function explorer_is_open()
  if M.use_solution_explorer() then
    local csharp = package.loaded["csharp-explorer"]
    return csharp ~= nil and csharp.win ~= nil and vim.api.nvim_win_is_valid(csharp.win)
  end
  return require("nvim-tree.api").tree.is_visible()
end

-- open the explorer whenever a file buffer is shown (startup or selecting a file), unless it is already open
vim.api.nvim_create_autocmd("BufWinEnter", {
  desc = "Open file explorer when a file is opened",
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" or vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end
    if explorer_is_open() then
      return
    end
    if M.use_solution_explorer() then
      toggle_solution_explorer()
    else
      require("nvim-tree.api").tree.open({ focus = false, find_file = true })
    end
  end,
})

return M

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
    if M.use_solution_explorer() then
      if explorer_is_open() then
        return
      end
      toggle_solution_explorer()
    else
      -- collapse other expanded dirs, then reveal only the opened file's path
      local api = require("nvim-tree.api")
      api.tree.collapse_all()
      api.tree.open({ focus = false, find_file = true })
    end
  end,
})

-- update csharp-explorer when file-tree has changed
local uv = vim.uv or vim.loop
local IGNORED_DIRS = {
  bin = true,
  obj = true,
  [".git"] = true,
  [".vs"] = true,
  node_modules = true,
}

local watchers = {}
local snapshots = {}
local dirty = {}
local refresh_timer
local watch_tree

local function list_entries(path)
  local names = {}
  local iter = uv.fs_scandir(path)
  if not iter then
    return names
  end
  while true do
    local name = uv.fs_scandir_next(iter)
    if not name then
      break
    end
    names[name] = true
  end
  return names
end

local function same_entries(a, b)
  for name in pairs(a) do
    if not b[name] then
      return false
    end
  end
  for name in pairs(b) do
    if not a[name] then
      return false
    end
  end
  return true
end

local function stop_watchers()
  for _, handle in ipairs(watchers) do
    handle:stop()
    handle:close()
  end
  watchers = {}
  dirty = {}
end

local function entries_changed()
  local changed = false
  for path in pairs(dirty) do
    if not same_entries(snapshots[path] or {}, list_entries(path)) then
      changed = true
    end
  end
  dirty = {}
  return changed
end

local function schedule_check()
  if not refresh_timer then
    refresh_timer = uv.new_timer()
  end
  refresh_timer:stop()
  refresh_timer:start(
    300,
    0,
    vim.schedule_wrap(function()
      if not entries_changed() then
        return
      end
      local csharp = package.loaded["csharp-explorer"]
      if csharp and csharp.tree then
        csharp.refresh()
      end
      watch_tree(vim.fn.getcwd())
    end)
  )
end

watch_tree = function(dir)
  stop_watchers()
  snapshots = {}

  local function watch_dir(path)
    snapshots[path] = list_entries(path)
    local handle = uv.new_fs_event()
    if not handle then
      return
    end
    local ok = handle:start(path, {}, function(err, _, events)
      if not err and events.rename then
        dirty[path] = true
        schedule_check()
      end
    end)
    if not ok then
      handle:close()
      return
    end
    table.insert(watchers, handle)
  end

  local function walk(path)
    watch_dir(path)
    local iter = uv.fs_scandir(path)
    if not iter then
      return
    end
    while true do
      local name, typ = uv.fs_scandir_next(iter)
      if not name then
        break
      end
      if typ == "directory" and not IGNORED_DIRS[name] then
        walk(path .. "/" .. name)
      end
    end
  end

  walk(dir)
end

local watch_group = vim.api.nvim_create_augroup("SolutionDirWatch", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  group = watch_group,
  desc = "Watch solution directories and refresh csharp-explorer on create/rename/delete",
  callback = function()
    if M.use_solution_explorer() then
      watch_tree(vim.fn.getcwd())
    else
      stop_watchers()
    end
  end,
})

return M

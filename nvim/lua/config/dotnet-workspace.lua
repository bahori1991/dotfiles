-- =====================================================================================================
-- TITLE: dotnet-workspace.lua
-- ABOUT: confirm .sln or .slnx file
-- =====================================================================================================

local env = require("config.lsp-env")
local M = {}
local MARKERS = { "*.sln", "*.slnx", "*.csproj" }

---@param dir string
---@return boolean
local function glob_has_markers(dir)
  dir = vim.fn.fnamemodify(dir, ":p")
  for _, marker in ipairs(MARKERS) do
    if vim.fn.glob(dir .. marker, false, true)[1] then
      return true
    end
  end
  return false
end

--- Dev container cwd is often /app while *.slnx lives in /app/<project>/.
---@param start_dir string normalized path without trailing slash
---@return boolean
local function has_marker_under_container_workspace(start_dir)
  local workspace = vim.env.WORKSPACE or "/app"
  workspace = vim.fn.fnamemodify(workspace, ":p"):gsub("/+$", "")
  if start_dir ~= workspace and not vim.startswith(start_dir, workspace .. "/") then
    return false
  end
  if glob_has_markers(workspace .. "/") then
    return true
  end
  for _, child in ipairs(vim.fn.glob(workspace .. "/*", false, true)) do
    if vim.fn.isdirectory(child) == 1 and glob_has_markers(child .. "/") then
      return true
    end
  end
  return false
end

---@param start_dir string|nil
---@return boolean
function M.has_solution_root(start_dir)
  if not env.in_container() then
    return false
  end
  start_dir = start_dir or vim.fn.getcwd()
  start_dir = vim.fn.fnamemodify(start_dir, ":p"):gsub("/+$", "")

  if vim.fs.root(start_dir, MARKERS) then
    return true
  end

  return has_marker_under_container_workspace(start_dir)
end

return M

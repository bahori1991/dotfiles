-- =====================================================================================================
-- TITLE: sqls-config.lua
-- ABOUT: automatically make config.yml of sqls
-- =====================================================================================================

local M = {}
local function yaml_quote(s)
  return '"' .. s:gsub("\\", "\\\\"):gsub('"', '\\"') .. '"'
end

function M.write(root, connections)
  local dir = vim.fs.joinpath(vim.fn.stdpath("data"), "sqls", vim.fn.sha256(vim.fn.fnamemodify(root, ":p")):sub(1, 16))
  vim.fn.mkdir(dir, "p")
  local path = vim.fs.joinpath(dir, "config.yml")
  local lines = { "lowercaseKeywords: false", "connections:" }
  for _, c in ipairs(connections) do
    table.insert(lines, "  - driver: postgresql")
    table.insert(lines, "    proto: tcp")
    table.insert(lines, "    host: " .. yaml_quote(c.host))
    table.insert(lines, "    port: " .. tostring(c.port))
    table.insert(lines, "    user: " .. yaml_quote(c.user))
    table.insert(lines, "    passwd: " .. yaml_quote(c.passwd or ""))
    table.insert(lines, "    dbName: " .. yaml_quote(c.dbName))
    table.insert(lines, "    params:")
    table.insert(lines, "      sslmode: " .. yaml_quote((c.params and c.params.sslmode) or "disable"))
  end
  if #connections == 0 then
    lines = { "lowercaseKeywords: false", "connections: []" }
  end
  vim.fn.writefile(lines, path)
  return path
end

return M

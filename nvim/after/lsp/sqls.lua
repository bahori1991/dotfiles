-- =====================================================================================================
-- TITLE: sqls.lua
-- ABOUT: settings of sqls
-- =====================================================================================================

local getenv = require("config.getenv")
local sqls_config = require("config.sqls-config")
local notified = {}

return {
  filetypes = { "sql" },
  root_markers = { ".env" },
  cmd = function(dispatchers, config)
    local root = config.root_dir or vim.fn.getcwd()
    local connections, err = getenv.connections_for_root(root)
    if not connections then
      if not notified[root] then
        notified[root] = true
        vim.notify("[sqls] " .. err .. " - using empty connections (" .. root .. ")", vim.log.levels.WARN)
      end
      connections = {}
    end
    local cfg_path = sqls_config.write(root, connections)
    return vim.lsp.rpc.start({ "sqls", "-config", cfg_path }, dispatchers)
  end,
}

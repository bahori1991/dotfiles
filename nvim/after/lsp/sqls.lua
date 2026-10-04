-- =====================================================================================================
-- TITLE: sqls.lua
-- ABOUT: settings of sqls
-- =====================================================================================================

local dburl = require("config.databaseurl")
local sqls_config = require("config.sqls-config")
local notified = {}

return {
  filetypes = { "sql" },
  root_markers = { ".lazysql.toml" },
  cmd = function(dispatchers, config)
    local root = config.root_dir or vim.fn.getcwd()
    local connections, err, config_root = dburl.connections_for_root(root)
    if not connections then
      if not notified[root] then
        notified[root] = true
        vim.notify("[sqls] " .. err .. " - using empty connections (" .. root .. ")", vim.log.levels.WARN)
      end
      connections = {}
    end
    local cfg_path = sqls_config.write(config_root or root, connections)
    return vim.lsp.rpc.start({ "sqls", "-config", cfg_path }, dispatchers)
  end,
}

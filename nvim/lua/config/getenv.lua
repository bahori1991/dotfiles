-- =====================================================================================================
-- TITLE: getenv
-- ABOUT: get environment variables from .env
-- =====================================================================================================

local M = {}

local function getenv(vars, name, default)
  local v = vars[name]
  if v and v ~= "" then
    return v
  end
  return default
end

local KEYS = {
  host = "POSTGRES_HOST",
  port = "POSTGRES_PORT",
  user = "POSTGRES_USER",
  password = "POSTGRES_PASSWORD",
  db = "POSTGRES_DB",
  sslmode = "POSTGRES_SSLMODE",
}

function M.parse_dotenv(path)
  local vars = {}
  if vim.fn.filereadable(path) ~= 1 then
    return vars
  end
  for line in io.lines(path) do
    line = line:match("^%s*(.-)%s*$")
    if line ~= "" and not line:match("^#") then
      local key, val = line:match("^([^=]+)=(.*)$")
      if key then
        val = val:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
        vars[key] = val
      end
    end
  end
  return vars
end

function M.connections_for_root(root)
  local vars = M.parse_dotenv(vim.fs.joinpath(root, ".env"))
  local host = getenv(vars, KEYS.host, "127.0.0.1")
  local port = tonumber(getenv(vars, KEYS.port, "5432"))
  local user = getenv(vars, KEYS.user, nil)
  local passwd = getenv(vars, KEYS.password, nil)
  local dbName = getenv(vars, KEYS.db, nil)
  local sslmode = getenv(vars, KEYS.sslmode, "disable")
  if not user or not dbName then
    return nil, "POSTGRES_USER or POSTGRES_DB required in .env"
  end
  return {
    {
      driver = "postgresql",
      proto = "tcp",
      host = host,
      port = port,
      user = user,
      passwd = passwd,
      dbName = dbName,
      params = { sslmode = sslmode },
    },
  }
end

return M

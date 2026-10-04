-- =====================================================================================================
-- TITLE: databaseurl
-- ABOUT: get database url from .lazysql.toml
-- =====================================================================================================

local M = {}

local function trim_line(line)
  return (line:match("^%s*(.-)%s*$") or line)
end

local function url_decode(s)
  if not s or s == "" then
    return s
  end
  if vim.uri_decode then
    return vim.uri_decode(s)
  end
  return (s:gsub("%%(%x%x)", function(h)
    return string.char(tonumber(h, 16))
  end))
end

local function expand_env_in_url(url)
  return (url:gsub("%${env:([^}]+)}", function(name)
    return os.getenv(name) or ""
  end))
end

local function parse_sslmode_from_query(query)
  if not query or query == "" then
    return "disable"
  end
  for pair in query:gmatch("[^&]+") do
    local k, v = pair:match("^([^=]+)=(.*)$")
    if k == "sslmode" and v and v ~= "" then
      return url_decode(v)
    end
  end
  return "disable"
end

local function parse_postgres_url(raw_url)
  if not raw_url or raw_url == "" then
    return nil
  end
  local url = expand_env_in_url(raw_url)
  url = url:gsub("^postgres://", ""):gsub("^pg://", "")
  local query = ""
  local qpos = url:find("?", 1, true)
  if qpos then
    query = url:sub(qpos + 1)
    url = url:sub(1, qpos - 1)
  end
  local sslmode = parse_sslmode_from_query(query)
  local user, passwd
  local hostportpath
  local at = url:find("@", 1, true)
  if at then
    local auth = url:sub(1, at - 1)
    hostportpath = url:sub(at + 1)
    local colon = auth:find(":", 1, true)
    if colon then
      user = url_decode(auth:sub(1, colon - 1))
      passwd = url_decode(auth:sub(colon + 1))
    else
      user = url_decode(auth)
    end
  else
    hostportpath = url
  end
  if hostportpath == "" then
    return nil
  end
  local slash = hostportpath:find("/", 1, true)
  local hostport, dbName
  if slash then
    hostport = hostportpath:sub(1, slash - 1)
    dbName = url_decode(hostportpath:sub(slash + 1))
  else
    hostport = hostportpath
    dbName = nil
  end
  if dbName == "" then
    dbName = nil
  end
  local host, port
  if hostport:sub(1, 1) == "[" then
    local endbr = hostport:find("]", 1, true)
    if not endbr then
      return nil
    end
    host = hostport:sub(2, endbr - 1)
    local rest = hostport:sub(endbr + 1)
    if rest:sub(1, 1) == ":" then
      port = tonumber(rest:sub(2)) or 5432
    else
      port = 5432
    end
  else
    local colon = hostport:find(":", 1, true)
    if colon then
      host = hostport:sub(1, colon - 1)
      port = tonumber(hostport:sub(colon + 1)) or 5432
    else
      host = hostport
      port = 5432
    end
  end
  if host == "" then
    host = "127.0.0.1"
  end
  if not user or not dbName then
    return nil
  end

  return {
    driver = "postgresql",
    proto = "tcp",
    host = host,
    port = port,
    user = user,
    passwd = passwd,
    dbName = dbName,
    params = { sslmode = sslmode },
  }
end

local function first_postgres_url_in_lazysql(path)
  local in_block = false
  local provider, url = nil, nil
  local function first_postgres_url()
    if provider and url and provider:lower() == "postgres" and url ~= "" then
      return url
    end
    return nil
  end
  for line in io.lines(path) do
    line = trim_line(line)
    if line == "" then
      -- skip
    elseif line == "[[database]]" then
      if in_block then
        local u = first_postgres_url()
        if u then
          return u
        end
      end
      in_block = true
      provider, url = nil, nil
    elseif in_block then
      if line:match("^%[%[") or line:match("^%[[^%[]") then
        local u = first_postgres_url()
        if u then
          return u
        end
        in_block = false
        provider, url = nil, nil
      else
        local p = line:match("^Provider%s*=%s*[\"']([^\"']+)[\"']")
        if p then
          provider = p
        end
        local u = line:match("^URL%s*=%s*[\"']([^\"']+)[\"']")
        if u then
          url = u
        end
        local got = first_postgres_url()
        if got then
          return got
        end
      end
    end
  end
  if in_block then
    return first_postgres_url()
  end
  return nil
end

local function find_lazysql_toml(start_dir)
  if not start_dir or start_dir == "" then
    return nil, "invalid root directory"
  end
  local found = vim.fs.find({ ".lazysql.toml" }, {
    upward = true,
    path = start_dir,
    limit = 1,
    type = "file",
  })
  local path = found[1]
  if not path or vim.fn.filereadable(path) ~= 1 then
    return nil, ".lazysql.toml not found"
  end
  return path, nil
end

function M.connections_for_root(root)
  local path, find_err = find_lazysql_toml(root)
  if not path then
    return nil, find_err
  end
  local raw_url = first_postgres_url_in_lazysql(path)
  if not raw_url then
    return nil, "no postgres [[database]] with URL in .lazysql.toml"
  end
  local conn = parse_postgres_url(raw_url)
  if not conn then
    return nil, "invalid postgres URL in .lazysql.toml"
  end
  local config_root = vim.fs.dirname(path)
  return { conn }, nil, config_root
end

return M

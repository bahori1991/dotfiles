-- =====================================================================================================
-- TITLE: viteplus-oxc
-- ABOUT: Settings of oxlint and oxfmt in Vite+
-- =====================================================================================================

local M = {}

local function has_vite_plus(root)
  return vim.fn.isdirectory(root .. "/node_modules/vite-plus") == 1
end

local function vite_plus_bin(root, name)
  local path = root .. "/node_modules/vite-plus/node_modules/.bin/" .. name
  return vim.fn.executable(path) == 1 and path or nil
end

function M.project_root(bufnr)
  assert(type(bufnr) == "number" and bufnr > 0, "project_root requires a valid bufnr")
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    name = vim.fn.getcwd()
  end
  return vim.fs.root(name, { "vite.config.ts", "package.json" }) or vim.fn.getcwd()
end

function M.resolve_ox_tool(root, name)
  if has_vite_plus(root) then
    return vite_plus_bin(root, name)
  else
    return nil
  end
end

function M.vite_config_args(root)
  local cfg = root .. "/vite.config.ts"
  if vim.fn.filereadable(cfg) == 1 then
    return { "--config", cfg }
  end
  return {}
end

return M

-- =====================================================================================================
-- TITLE: lsp-env.lua
-- ABOUT:
-- =====================================================================================================

local M = {}

function M.in_container()
  return vim.fn.filereadable("/.dockerenv") == 1 or vim.env.DEVCONTAINER == "true"
end

function M.has_node()
  return vim.fn.executable("node") == 1
end

function M.has_dotnet()
  return vim.fn.executable("dotnet") == 1
end

function M.typescript_lsp_available()
  return M.in_container() and M.has_node()
end

function M.roslyn_lsp_available()
  return M.in_container() and M.has_dotnet()
end

return M

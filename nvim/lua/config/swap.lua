-- =====================================================================================================
-- TITLE: swap.lua
-- ABOUT: make swap directory when creating new session
-- =====================================================================================================

local M = {}

local function swap_container_segment()
  local name = vim.env.CONTAINER_NAME or ""
  if name == "" then
    name = vim.trim(vim.fn.hostname()):gsub("%..*$", "")
  end
  if name ~= "" and name:match("^[%w%-]+$") then
    return name
  end
  return "local"
end

local function swap_dir()
  return vim.fn.stdpath("state") .. "/swap/" .. swap_container_segment()
end

function M.setup_directory()
  vim.fn.mkdir(swap_dir(), "p")
  vim.o.directory = swap_dir() .. "//"
end

M.setup_directory()
return M

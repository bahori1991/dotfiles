-- =====================================================================================================
-- TITLE: dropbar.lua
-- ABOUT: settings for dropbar.nvim
-- =====================================================================================================

local M = {}

function M.enable(buf, win, _)
  buf = vim._resolve_bufnr(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
    return false
  end
  if vim.fn.win_gettype(win) ~= "" or vim.wo[win].winbar ~= "" or vim.bo[buf].ft == "help" then
    return false
  end
  if vim.api.nvim_buf_get_name(buf) == "" then
    return false
  end
  if vim.bo[buf].buftype == "nofile" then
    return false
  end
  local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
  if stat and stat.size > 1024 * 1024 then
    return false
  end
  return vim.bo[buf].bt == "terminal"
    or vim.bo[buf].ft == "markdown"
    or vim.bo[buf].ft == "oil"
    or (function()
      local ok, parser = pcall(vim.treesitter.get_parser, buf)
      return ok and parser ~= nil
    end)()
    or not vim.tbl_isempty(vim.lsp.get_clients({
      bufnr = buf,
      method = "textDocument/documentSymbol",
    }))
end

function M.sources(buf, _)
  local sources = require("dropbar.sources")
  local utils = require("dropbar.utils")
  if vim.bo[buf].ft == "oil" then
    return { sources.path }
  end
  if vim.bo[buf].ft == "markdown" then
    return { sources.path, sources.markdown }
  end
  if vim.bo[buf].buftype == "terminal" then
    return { sources.terminal }
  end
  return {
    sources.path,
    utils.source.fallback({ sources.lsp, sources.treesitter }),
  }
end

function M.path_relative_to(buf, win)
  local bufname = vim.api.nvim_buf_get_name(buf)
  if vim.startswith(bufname, "oil://") or vim.startswith(bufname, "fugitive://") then
    local root = bufname:gsub("^%S+://", "", 1)
    while root and root ~= vim.fs.dirname(root) do
      root = vim.fs.dirname(root)
    end
    return root
  end
  local ok, cwd = pcall(vim.fn.getcwd, win)
  return ok and cwd or vim.fn.getcwd()
end

return M

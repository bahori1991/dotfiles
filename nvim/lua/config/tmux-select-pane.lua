-- ================================================================================
-- TITLE: tmux-select-pane
-- ABOUT: select tmux pane from Neovim
-- ================================================================================

local M = {}

local function tmux_cmd(socket, ...)
  return vim.system(vim.list_extend({ "tmux", "-S", socket }, { ... })):wait()
end

local function pane_is_zoomed(socket, pane)
  local r = tmux_cmd(socket, "display-message", "-t", pane, "-p", "#{window_zoomed_flag}")
  if r.code ~= 0 then
    return false
  end
  return vim.trim(r.stdout or "") == "1"
end

local function disable_when_zoomed()
  return vim.g.tmux_navigator_disable_when_zoomed == 1
end

function M.select_pane(direction)
  return function(_prompt_bufnr)
    local tmux = vim.env.TMUX
    local pane = vim.env.TMUX_PANE
    if not tmux or not pane then
      return
    end
    local socket = vim.split(tmux, ",")[1]
    if disable_when_zoomed() and pane_is_zoomed(socket, pane) then
      return
    end
    local flag = ({ h = "L", j = "D", k = "U", l = "R" })[direction]
    if not flag then
      return
    end
    tmux_cmd(socket, "select-pane", "-t", pane, "-" .. flag)
  end
end

return M

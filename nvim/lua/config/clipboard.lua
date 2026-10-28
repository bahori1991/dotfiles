-- =====================================================================================================
-- TITLE: clipboard.lua
-- ABOUT: set clipboard mode as below
--        inner tmux -> OSC52 + unnamedplus (by tmux)
--        outer tmux -> clip.exe / Powershell, other mode off
-- =====================================================================================================

local M = {}

function M.wsl_clipboard_available()
  if vim.fn.executable("clip.exe") ~= 1 then
    return false
  end
  if vim.fn.filereadable("/proc/version") ~= 1 then
    return false
  end
  local line = vim.fn.readfile("/proc/version", "", 1)[1] or ""
  return line:lower():find("microsoft") ~= nil
end

function M.setup_wsl_clipboard()
  local function copy_to_windows(lines, _)
    local text = table.concat(lines, "\n")
    if text == "" then
      return
    end
    vim.fn.system({ "clip.exe" }, text)
  end
  local function paste_from_windows()
    if vim.fn.executable("powershell.exe") ~= 1 then
      return { "" }
    end
    local out = vim.fn.system({
      "powershell.exe",
      "-NoProfile",
      "-Command",
      "Get-Clipboard -Raw",
    })
    if vim.v.shell_error ~= 0 then
      return { "" }
    end
    out = out:gsub("\r\n", "\n"):gsub("\r$", "")
    if out == "" then
      return { "" }
    end
    return vim.split(out, "\n", { plain = true })
  end
  vim.g.clipboard = {
    name = "WSL clip.exe",
    copy = {
      ["+"] = copy_to_windows,
      ["*"] = copy_to_windows,
    },
    paste = {
      ["+"] = paste_from_windows,
      ["*"] = paste_from_windows,
    },
  }
  vim.opt.clipboard = "unnamedplus"
end

function M.setup_osc52()
  vim.g.clipboard = "osc52"
  vim.opt.clipboard = "unnamedplus"
end

function M.setup_disabled()
  vim.g.clipboard = nil
  vim.opt.clipboard = ""
end

if M.wsl_clipboard_available() then
  M.setup_wsl_clipboard()
else
  M.setup_osc52()
end

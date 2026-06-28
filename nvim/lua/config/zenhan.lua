-- ================================================================================
-- TITLE: zenhan.lua
-- ABOUT: Switch the mode of input method editor from terminal.
-- LINKS: https://neovim.io/doc/user/options/
-- ================================================================================

local ime_off = function()
  local zenhan_path = "/mnt/c/users/bahori1991/bin/zenhan/zenhan.exe"
  if vim.fn.executable(zenhan_path) == 1 then
    vim.fn.system(zenhan_path .. " 0")
  else
    print("cannot find zenhan_path")
  end
end

if vim.fn.has("wsl") == 1 then
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = ime_off
  })
  vim.keymap.set("n", "<Esc>", ime_off, { desc = "IME off" })
end


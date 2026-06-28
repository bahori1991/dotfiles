-- ================================================================================
-- TITLE: options.lua
-- ABOUT: settings options of Neovim
-- LINKS: https://neovim.io/doc/user/options/
-- ================================================================================

-- encode
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "utf-8,sjis,euc-jp,iso-2022-jp"

-- cursor
vim.opt.guicursor = {
  "n:block",
  "i:ver25",
  "v:block-vCursor",
  "r:hor20",
  "c:block",
  "t:block",
}

-- cursoline
vim.opt.cursorline = true

-- guicolors
vim.opt.termguicolors = true

-- semi-transparent floating windows (LSP hover, diagnostics, etc.)
vim.opt.winblend = 15

-- show line number
vim.opt.number = true
vim.opt.relativenumber = true

-- indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- signcolumn
vim.opt.signcolumn = "yes:1"

-- clipboard
vim.opt.clipboard = "unnamedplus"
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end

-- disable resize editor size when closed window
vim.opt.equalalways = false

-- encode
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "utf-8,sjis,euc-jp,iso-2022-jp"

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

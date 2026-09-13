-- ================================================================================
-- TITLE: options.lua
-- ABOUT: settings options of Neovim
-- LINKS: https://neovim.io/doc/user/options/
-- ================================================================================

-- encode
vim.opt.fileencodings = "utf-8,sjis,euc-jp,iso-2022-jp"

-- cursorline
vim.opt.cursorline = true

-- hide command line height
vim.opt.cmdheight = 0

-- show line number
vim.opt.number = true
vim.opt.relativenumber = true

-- hiden tabs
vim.opt.showtabline = 0

-- show border to hover
vim.o.winborder = "single"

-- no comment leader on new line
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- guicolors
vim.opt.termguicolors = true

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

-- wrap
vim.opt.wrap = false

-- scroll
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- signcolumn
vim.opt.signcolumn = "yes:1"

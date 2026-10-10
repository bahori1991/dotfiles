-- =====================================================================================================
-- TITLE: folke.lazy.nvim
-- ABOUT: Modern plugins manager for Neovim
-- LINKS: https://github.com/folke/lazy.nvim, https://lazy.folke.io/installation
-- =====================================================================================================

-- leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- on first Neovim start in container, seed lock from ro config into data
local env = require("config.lsp-env")
local config_lock = vim.fn.stdpath("config") .. "/lazy-lock.json"
local data_lock = vim.fn.stdpath("data") .. "/lazy-lock.json"
if env.in_container() then
  vim.fn.mkdir(vim.fn.stdpath("data"), "p")
  if vim.fn.filereadable(data_lock) == 0 and vim.fn.filereadable(config_lock) == 1 then
    vim.fn.writefile(vim.fn.readfile(config_lock), data_lock)
  end
end

-- Bootstrap of lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- set up lazy.nvim
require("lazy").setup({
  lockfile = env.in_container() and data_lock or config_lock,
  spec = require("plugins.init"),
  checker = {
    enabled = not env.in_container(),
    notify = false,
  },
  change_detection = { enabled = false },
  pkg = {
    enabled = true,
    sources = { "lazy", "packspec" },
  },
  rocks = {
    enabled = false,
  },
})

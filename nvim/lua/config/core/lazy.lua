-- ================================================================================
-- TITLE: folke/lazy.nvim
-- ABOUT: Modern plugin manager for Neovim
-- LINKS: https://github.com/folke/lazy.nvim
-- ================================================================================

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw at the very start of init
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  checker = {
    enabled = true,
    notify = false
  },
  change_detection = {
    notify = false,
  },
})

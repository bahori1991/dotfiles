-- ================================================================================
-- TITLE: ui2.lua
-- ABOUT: Neovim core UI2 (requires Neovim 0.11+)
-- LINKS: https://github.com/folke/noice.nvim/issues/1201
-- ================================================================================

-- UI2 and noice.nvim both render cmdline/messages via vim.ui_attach.
-- With both enabled, the native UI2 cmdline window shows the same text at the
-- bottom-left while noice shows cmdline_popup in the center.
if vim.fn.has("nvim-0.11") == 1 and vim.env.NVIM_ENABLE_UI2 == "1" then
	require("vim._core.ui2").enable({})
end

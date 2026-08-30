-- ================================================================================
-- TITLE: ui2.lua
-- ABOUT: Neovim core UI2 (requires Neovim 0.11+)
-- ================================================================================

if vim.fn.has("nvim-0.11") == 1 and vim.env.NVIM_ENABLE_UI2 == "1" then
	require("vim._core.ui2").enable({})
end

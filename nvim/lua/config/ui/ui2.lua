-- ================================================================================
-- TITLE: ui2.lua
-- ABOUT: Enable Neovim core UI2 (requires Neovim 0.11+)
-- ================================================================================

if vim.fn.has("nvim-0.11") == 1 then
	require("vim._core.ui2").enable({})
end

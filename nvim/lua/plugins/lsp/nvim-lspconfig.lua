-- ========================================================================================
-- TITLE: neovim/nvim-lspconfig
-- ABOUT: collection of LSP server configurations for the Neovim LSP client
-- LINKS: https://github.com/neovim/nvim-lspconfig
-- ========================================================================================
--
-- Role split (automatic_enable = false on mason-lspconfig):
--   mason-lspconfig    → LSP binary install (ensure_installed) + Mason↔lspconfig mapping
--   nvim-lspconfig     → server settings, blink capabilities, vim.lsp.enable() (here)
--   config/lsp/lsp.lua → diagnostics + LspAttach keymaps / inlay hints (all servers)
--   lazydev.nvim         → lua_ls workspace library only (Lua ft); no per-server on_attach here
--
-- Migrated from nvim/after/lsp/lua_ls.lua (settings only; root_markers use lspconfig defaults).

local function lsp_capabilities(base)
	local capabilities = base or vim.lsp.protocol.make_client_capabilities()
	local ok, blink = pcall(require, "blink.cmp")
	if ok then
		capabilities = blink.get_lsp_capabilities(capabilities)
	end
	return capabilities
end

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		servers = {
			-- Static lua_ls settings; workspace library paths are lazydev's job (see lazydev.lua).
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			},
			-- Binary installed via mason-lspconfig ensure_installed (not mason-tool-installer).
			hls = {},
			-- oxlint
			oxlint = {},
		},
	},
	config = function(_, opts)
		for server, config in pairs(opts.servers) do
			config.capabilities = lsp_capabilities(config.capabilities)
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end
	end,
}

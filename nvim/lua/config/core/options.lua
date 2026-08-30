-- ================================================================================
-- TITLE: options.lua
-- ABOUT: settings options of Neovim
-- LINKS: https://neovim.io/doc/user/options/
-- ================================================================================

-- encode
vim.opt.fileencodings = "utf-8,sjis,euc-jp,iso-2022-jp"

-- mode in lualine; native cmdline for :, /, ?
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1

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

-- keep terminal buffers when their window is closed
vim.opt.hidden = true

-- scroll window before reaching the edge
vim.opt.scrolloff = 0

-- show line number
vim.opt.number = true
vim.opt.relativenumber = true

local number_group = vim.api.nvim_create_augroup("UserNumberToggle", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
	group = number_group,
	callback = function()
		vim.opt.relativenumber = false
	end,
})
vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter" }, {
	group = number_group,
	callback = function()
		local ft = vim.bo.filetype
		if ft == "NvimTree" or ft == "dashboard" or ft:match("^Telescope") then
			return
		end
		if vim.api.nvim_get_mode().mode:sub(1, 1) ~= "i" then
			vim.opt.relativenumber = true
		end
	end,
})

-- fold
vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.require'config.core.foldexpr'.expr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.opt.fillchars = {
	eob = " ",
	foldclose = "",
	foldopen = "",
	foldsep = " ",
	foldinner = " ",
}

-- reset foldlevel once per buffer (treesitter foldexpr; no zx to preserve manual folds)
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function(args)
		local buf = args.buf
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end
		if vim.b[buf].fold_initialized then
			return
		end
		if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].filetype == "" then
			return
		end
		if not pcall(vim.treesitter.get_parser, buf) then
			return
		end
		vim.b[buf].fold_initialized = true
		vim.wo.foldlevel = vim.o.foldlevelstart
	end,
})

-- ensure files end with a newline on write (POSIX; see also .editorconfig)
vim.opt.fixendofline = true

-- conform.nvim respects vim.bo.eol when formatting; noeol buffers keep no trailing newline
local ensure_eol_group = vim.api.nvim_create_augroup("UserEnsureFinalNewline", { clear = true })
local function ensure_final_newline(bufnr)
	if vim.bo[bufnr].modifiable and vim.bo[bufnr].buftype == "" then
		vim.bo[bufnr].eol = true
	end
end
vim.api.nvim_create_autocmd("BufWritePre", {
	group = ensure_eol_group,
	callback = function(args)
		ensure_final_newline(args.buf)
	end,
})
vim.api.nvim_create_autocmd("User", {
	group = ensure_eol_group,
	pattern = "ConformFormatPre",
	callback = function()
		ensure_final_newline(vim.api.nvim_get_current_buf())
	end,
})

-- indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = "haskell",
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
	end,
})

-- comment auto-insert (formatoptions r/o); toggle with <leader>ci
require("config.core.comment-auto-insert").setup()

-- not wrap
vim.opt.wrap = false

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

if vim.env.NVIM_IN_TMUX == "1" and not vim.o.shortmess:find("W", 1, true) then
	vim.o.shortmess = vim.o.shortmess .. "W"
end

-- Viteplus settings
local vp_home = vim.env.VP_HOME or (vim.env.HOME .. "/.local/share/.vite-plus")
vim.env.VP_HOME = vp_home
local vp_bin = vp_home .. "/bin"
if vim.uv.fs_stat(vp_bin) then
	vim.env.PATH = vp_bin .. ":" .. (vim.env.PATH or "")
end

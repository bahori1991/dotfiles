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

-- keep terminal buffers when their window is closed
vim.opt.hidden = true

-- semi-transparent floating windows (LSP hover, diagnostics, etc.)
vim.opt.winblend = 10

-- show line number
vim.opt.number = true
vim.opt.relativenumber = true

-- fold
vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
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

-- reset fold foldlevel
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function(args)
		local buf = args.buf
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end
		if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].filetype == "" then
			return
		end
		if not pcall(vim.treesitter.get_parser, buf) then
			return
		end
		vim.wo.foldlevel = vim.o.foldlevelstart
		vim.cmd("normal! zx")
	end,
})

-- indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

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

-- autoread stays enabled in tmux; scratch-cleanup handles empty buffers before checktime.

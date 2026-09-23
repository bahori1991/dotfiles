-- =====================================================================================================
-- TITLE: unmodifiable
-- ABOUT: Set file to be unmodifiable (to unlock `:setlocal modifiable noreadonly` in Neovim)
-- =====================================================================================================

local globs = {
  "**/lazy-lock.json",
  "**/.tanstack/**",
  "**/.vite-hooks/_/**",
  "**/dist/**",
  "**/pnpm-lock.yaml",
  "**/routeTree.gen.ts",
}

local function matches_any_glob(path, _globs)
  path = vim.fn.fnamemodify(path, ":p")
  for _, glob in ipairs(_globs) do
    if vim.glob.to_lpeg(glob):match(path) then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name == "" or not matches_any_glob(name, globs) then
      return
    end
    vim.bo[args.buf].modifiable = false
    vim.bo[args.buf].readonly = true
    vim.bo[args.buf].autoread = true
  end,
})

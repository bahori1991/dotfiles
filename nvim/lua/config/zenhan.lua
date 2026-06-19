if vim.fn.has("wsl") == 1 then
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      local zenhan_path = "/mnt/c/users/bahori1991/bin/zenhan/zenhan.exe"
      if vim.fn.executable(zenhan_path) == 1 then
        vim.fn.system(zenhan_path .. " 0")
      else
        print("cannot find zenhan_path")
      end
    end,
  })
end


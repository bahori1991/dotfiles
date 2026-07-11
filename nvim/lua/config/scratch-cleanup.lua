-- ================================================================================
-- TITLE: scratch-cleanup
-- ABOUT: Remove empty scratch buffers that trigger W13 on tmux focus changes
-- ================================================================================

local M = {}

local SCRATCH_NAME = "[nvim-dev-scratch]"

--- Drop "" file arguments (e.g. from Cursor embed: nvim --embed "").
function M.drop_empty_argv()
  for i = vim.fn.argc() - 1, 0, -1 do
    if vim.fn.argv(i) == "" then
      pcall(vim.cmd, string.format("%dargdelete!", i + 1))
    end
  end
end

--- Remove every checktime autocommand (FocusGained + VimResume both fire it).
function M.disable_all_checktime()
  pcall(vim.cmd, "autocmd! * checktime")
end

function M.apply_shortmess()
  if vim.env.NVIM_IN_TMUX ~= "1" then
    return
  end
  if not vim.o.shortmess:find("W", 1, true) then
    vim.o.shortmess = vim.o.shortmess .. "W"
  end
end

function M.delete_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.bo[buf].modified = false
  vim.bo[buf].buflisted = false
  vim.bo[buf].bufhidden = "wipe"

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      local alt = vim.fn.bufnr("#")
      if alt > 0 and alt ~= buf and vim.api.nvim_buf_is_valid(alt) then
        pcall(vim.api.nvim_win_set_buf, win, alt)
      end
    end
  end

  pcall(vim.api.nvim_buf_delete, buf, { force = true })
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "silent! bwipeout! " .. buf)
  end
end

--- W13 targets File ""; nofile buffers often reject nvim_buf_set_name.
function M.neutralize_scratch_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if vim.bo[buf].filetype == "dashboard" then
    return
  end
  if vim.bo[buf].buftype == "terminal" then
    return
  end

  pcall(vim.api.nvim_buf_call, buf, function()
    vim.bo.modified = false
    local saved_buftype = vim.bo.buftype
    if saved_buftype == "nofile" then
      vim.bo.buftype = ""
    end
    if vim.api.nvim_buf_get_name(0) == "" then
      vim.cmd("silent! file " .. vim.fn.fnameescape(SCRATCH_NAME))
    end
    if saved_buftype == "nofile" then
      vim.bo.buftype = "nofile"
    end
    vim.bo.modifiable = false
    vim.bo.buflisted = false
    vim.bo.bufhidden = "hide"
    vim.bo.swapfile = false
  end)
end

function M.is_scratch_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if name ~= "" and name ~= SCRATCH_NAME then
    return false
  end
  if vim.bo[buf].filetype == "dashboard" then
    return false
  end
  if vim.bo[buf].buftype == "terminal" then
    return false
  end
  return true
end

function M.clean_scratch_buffer(buf)
  if not M.is_scratch_buffer(buf) then
    return
  end
  M.delete_buffer(buf)
  if vim.api.nvim_buf_is_valid(buf) and M.is_scratch_buffer(buf) then
    M.neutralize_scratch_buffer(buf)
  end
end

function M.wipe_scratch_buffers()
  local dashboard_buf
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "dashboard" then
      dashboard_buf = buf
      break
    end
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if dashboard_buf and buf == dashboard_buf then
      goto continue
    end
    M.clean_scratch_buffer(buf)
    ::continue::
  end
end

function M.schedule_startup_wipes()
  for _, ms in ipairs({ 0, 50, 200, 500, 1000 }) do
    vim.defer_fn(function()
      M.disable_all_checktime()
      M.wipe_scratch_buffers()
    end, ms)
  end
end

function M.normalize_dashboard_buffer()
  if vim.bo.filetype ~= "dashboard" then
    return
  end
  vim.bo.modified = false
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  local name = vim.api.nvim_buf_get_name(0)
  if name ~= "" and vim.fn.isdirectory(name) == 1 then
    pcall(vim.api.nvim_buf_set_name, 0, "")
  end
end

function M.on_focus_event()
  M.disable_all_checktime()
  M.wipe_scratch_buffers()
end

function M.setup_autocmds()
  local group = vim.api.nvim_create_augroup("ScratchCleanup", { clear = true })

  if vim.env.NVIM_IN_TMUX == "1" then
    M.apply_shortmess()
    M.disable_all_checktime()
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "dashboard",
    callback = function()
      M.disable_all_checktime()
      M.normalize_dashboard_buffer()
      M.wipe_scratch_buffers()
      M.schedule_startup_wipes()
    end,
  })

  vim.api.nvim_create_autocmd("BufAdd", {
    group = group,
    callback = function(args)
      vim.defer_fn(function()
        M.clean_scratch_buffer(args.buf)
      end, 0)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LazyDone",
    callback = function()
      if vim.env.NVIM_IN_TMUX == "1" then
        M.apply_shortmess()
      end
      M.disable_all_checktime()
      M.wipe_scratch_buffers()
      M.schedule_startup_wipes()
    end,
  })

  if vim.env.NVIM_IN_TMUX == "1" then
    vim.api.nvim_create_autocmd({ "FocusLost", "FocusGained", "VimSuspend", "VimResume" }, {
      group = group,
      callback = M.on_focus_event,
    })
  end

  vim.api.nvim_create_autocmd("FileChangedShell", {
    group = group,
    callback = function(args)
      M.clean_scratch_buffer(args.buf)
    end,
  })
end

return M

local augroup_cnt = 0
local function augroup(fn)
  augroup_cnt = augroup_cnt + 1
  local group_name = string.format('%s_internal_%d', plugin_name, augroup_cnt)
  local cmd = vim.api.nvim_command
  cmd(string.format('augroup %s', group_name))
  cmd('autocmd!')
  fn()
  cmd('augroup END')
  return group_name
end

local function setup_autocmd()
  local cmd = vim.api.nvim_command
  local redraw_vim = string.format(
    'lua %s; if (vim.fn.getcmdwintype() == \'\' and (%s)) then %s end',
    'require"visual-eof".clean_buf(vim.fn.bufnr())',
    'require"visual-eof".check_buf(vim.fn.bufnr())',
    'require"visual-eof".redraw_buf(vim.fn.bufnr())'
  )
  local hl_def_vim = string.format(
    'lua %s',
    'require"visual-eof".hl_default()'
  )
  local group_name = augroup(function()
    cmd(string.format(
      'autocmd %s %s %s',
      'BufWritePost,BufWinEnter',
      '*',
      redraw_vim
    ))
    cmd(string.format(
      'autocmd %s %s %s',
      'OptionSet',
      'endofline,fixendofline,binary',
      redraw_vim
    ))
    cmd(string.format(
      'autocmd %s %s %s',
      'ColorScheme',
      '*',
      hl_def_vim
    ))
  end)
  return group_name
end

return setup_autocmd

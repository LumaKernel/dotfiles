if has('nvim')
  lua pp = vim.print
  lua pprint = vim.print
  command! -nargs=+ PP lua pp(<q-args>)
endif

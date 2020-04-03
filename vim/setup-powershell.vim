
function! g:SetupPwsh() abort
  colorscheme darkblue
  set nocursorline
  set nocursorcolumn
endfunction

if g:from_pwsh
  call g:SetupPwsh()
endif

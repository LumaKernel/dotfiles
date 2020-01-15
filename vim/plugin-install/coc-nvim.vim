if !has("python3")
  finish
endif

call dein#add('neoclide/coc.nvim', {
      \   'rev': 'release',
      \ })


function! s:check_back_space() abort
  let col = col('.') - 1
  return col < 1 || getline('.')[col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <silent><expr> <S-TAB>
      \ pumvisible() ? "\<C-p>" :
      \ "\<S-TAB>"

let g:coc_snippet_next = '<tab>'

inoremap <silent><expr> <C-SPACE>
      \ coc#refresh()


nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent><unique> gd <Plug>(coc-definition)
nmap <silent><unique> gu <Plug>(coc-declaration)
nmap <silent><unique> gy <Plug>(coc-type-definition)
nmap <silent><unique> gi <Plug>(coc-implementation)
nmap <silent><unique> gr <Plug>(coc-references)
nmap <silent><unique> gn <Plug>(coc-rename)

nmap <silent> <F8> <Plug>(coc-format)
nmap <silent> <Leader>p <Plug>(coc-format-selected)

nmap <silent><unique> go <Plug>(coc-openlink)


function! CocNvimHiDef()
  hi CocUnderline    cterm=underline gui=underline
  hi CocErrorSign    ctermfg=Red     guifg=#ff0000
  hi CocWarningSign  ctermfg=Brown   guifg=#ff922b
  hi CocInfoSign     ctermfg=Yellow  guifg=#fab005
  hi CocHintSign     ctermfg=Blue    guifg=#15aabf
  hi CocSelectedText ctermfg=Red     guifg=#fb4934
  hi CocCodeLens     ctermfg=Gray    guifg=#999999
  hi link cocerrorfloat       CocFloating
  hi link cocwarningfloat     CocFloating
  hi link cocinfofloat        CocFloating
  hi link cochintfloat        CocFloating
  hi link CocErrorHighlight   Error
  hi link CocWarningHighlight Warning
  hi link CocInfoHighlight    CocUnderline
  hi link CocHintHighlight    CocUnderline
  hi link CocListMode ModeMsg
  hi link CocListPath Comment
  hi link CocHighlightText  CursorColumn

  if has('nvim')
    hi link CocFloating NormalFloat
  else
    hi link CocFloating Pmenu
  endif

  hi link CocHoverRange     Search
  hi link CocCursorRange    Search
  hi link CocHighlightRead  CocHighlightText
  hi link CocHighlightWrite CocHighlightText
endfunction


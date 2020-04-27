
" @see rhysd/accelerated-jk
" nnoremap j gj
" nnoremap k gk

noremap <LEFT> <NOP>
noremap <RIGHT> <NOP>
noremap <UP> <NOP>
noremap <DOWN> <NOP>

noremap ZZ <NOP>
noremap ZQ <NOP>

nnoremap th <C-W>h
nnoremap tj <C-W>j
nnoremap tk <C-W>k
nnoremap tl <C-W>l
nnoremap tw <C-W>w

nnoremap tH <C-W>H
nnoremap tJ <C-W>J
nnoremap tK <C-W>K
nnoremap tL <C-W>L
nnoremap tr <C-W>r

nnoremap t= <C-W>=
nnoremap t> <C-W>>
nnoremap t< <C-W><
nnoremap t+ <C-W>+
nnoremap t- <C-W>-

" タブで開く、を上書き
nnoremap tt <Nop>

nnoremap s <Nop>
xnoremap s <Nop>

nnoremap <silent> <Leader>r :reg<CR>

inoremap <C-L> <DEL>
cnoremap <C-D> <DEL>

noremap <F1> <Nop>
noremap! <F1> <Nop>
xnoremap <F1> <Nop>

nnoremap <A-:> :
inoremap <A-:> <C-o>:
tnoremap <A-:> <C-\><C-n>:

nnoremap <A-/> /
inoremap <A-/> <C-o>/
tnoremap <A-/> <C-\><C-n>/

nnoremap <A-ESC> <ESC>
inoremap <A-ESC> <ESC>
tnoremap <A-ESC> <C-\><C-n>

nnoremap <A-]> <ESC>
inoremap <A-]> <ESC>
tnoremap <A-]> <C-\><C-n>

for s:wincmd in split('hjkl', '\zs')
  exe 'nnoremap <silent> <A-' .. s:wincmd .. "> :<C-u>silent! call VimAndTmuxMove('" .. s:wincmd .. "', 0)<CR>"
  exe 'xnoremap <silent> <A-' .. s:wincmd .. "> :<C-u>silent! call VimAndTmuxMove('" .. s:wincmd .. "', 0)<CR>gv"
  exe 'inoremap <silent> <A-' .. s:wincmd .. "> <C-r>=<C-u>VimAndTmuxMove('" .. s:wincmd .. "', 0)<CR>"
  exe 'cnoremap <silent> <A-' .. s:wincmd .. "> <C-r>=<C-u>VimAndTmuxMove('" .. s:wincmd .. "', 1)<CR>"
  exe 'tnoremap <silent> <A-' .. s:wincmd .. "> <C-\><C-n>:<C-u>silent! call VimAndTmuxMove('" .. s:wincmd .. "', 0)<CR>"
endfor

nnoremap <Leader>sw :<C-u>SSave!__1<CR>
nnoremap <Leader>sp :<C-u>SLoad __1<CR>

nnoremap <silent> <Leader>y :<C-u>%y+<CR>
nnoremap <silent> <Leader>v ggVGs<ESC>"+P

xnoremap <silent> <LT> <LT>gv
xnoremap <silent> > >gv

noremap <expr> 0 getline('.')[: col('.') - 2] =~# '^\s\+$' ? '0' : '^'

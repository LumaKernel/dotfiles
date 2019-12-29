
nnoremap j gj
nnoremap k gk

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

nnoremap <silent> <Leader>r :reg<CR>

" + Delキー
inoremap <C-L> <DEL>
cnoremap <C-D> <DEL>

" バッファ切り替え
nnoremap <silent> H :bprevious<CR>
nnoremap <silent> L :bnext<CR>
" C-L をmap
nnoremap <silent> <C-K> <C-L>

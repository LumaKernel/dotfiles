
nnoremap j gj
nnoremap k gk

noremap <LEFT> <NOP>
noremap <RIGHT> <NOP>
noremap <UP> <NOP>
noremap <DOWN> <NOP>

noremap ZZ <NOP>
noremap ZQ <NOP>

let s:wincmds = split('hjklwHJKLr=><+-', '\zs')

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

" C-L をmap
nnoremap <silent> <C-K> <C-L>

noremap <F1> <Nop>
noremap! <F1> <Nop>
xnoremap <F1> <Nop>

nnoremap <unique> <A-:> :
inoremap <unique> <A-:> <C-o>:
tnoremap <unique> <A-:> <C-\><C-n>:

nnoremap <unique> <A-/> /
inoremap <unique> <A-/> <C-o>/
tnoremap <unique> <A-/> <C-\><C-n>/

nnoremap <unique> <A-q>: q:
inoremap <unique> <A-q>: <C-o>q:
tnoremap <unique> <A-q>: <C-\><C-n>q:

nnoremap <unique> <A-q>/ q/
inoremap <unique> <A-q>/ <C-o>q/
tnoremap <unique> <A-q>/ <C-\><C-n>q/

nnoremap <unique> <A-ESC> <ESC>
inoremap <unique> <A-ESC> <ESC>
tnoremap <unique> <A-ESC> <C-\><C-n>

nnoremap <unique> <A-]> <ESC>
inoremap <unique> <A-]> <ESC>
tnoremap <unique> <A-]> <C-\><C-n>

for s:wincmd in s:wincmds
  exe 'nnoremap <unique> <A-' .. s:wincmd .. '> <C-w>' .. s:wincmd
  exe 'inoremap <unique> <A-' .. s:wincmd .. '> <ESC><C-w>' .. s:wincmd 
  exe 'tnoremap <unique> <A-' .. s:wincmd .. '> <C-\><C-n><C-w>' .. s:wincmd 
endfor

tnoremap <unique> <A-p> <C-\><C-n>pi


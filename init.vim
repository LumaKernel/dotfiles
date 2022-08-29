" set encoding=utf-8
" scriptencoding utf-8

augroup init_vim
  autocmd!
augroup END

function! IsPrivateMode() abort
  return $PRIVATE_MODE == '1'
endfunction

" "huge" | "light"
let g:mode = "huge"
if !empty($VIM_MODE)
  let g:mode = $VIM_MODE
endif

" "ddc" | "coc" | "none"
let g:complete_mode = "coc"
if !empty($VIM_COMPLETE_MODE)
  let g:complete_mode = $VIM_COMPLETE_MODE
endif

" "vim-lsp" | "coc" | "none"
let g:lsp_mode = "coc"
if !empty($VIM_LSP_MODE)
  let g:lsp_mode = $VIM_LSP_MODE
endif

" "tsu" | "lsp" | "none"
let g:ts_lsp_mode = "none"
if !empty($VIM_TS_LSP_MODE)
  let g:ts_lsp_mode = $VIM_TS_LSP_MODE
endif


if g:mode is# "light"
  let g:complete_mode = "none"
  let g:lsp_mode = "none"
  let g:ts_lsp_mode = "none"
endif

if g:complete_mode is# "coc"
  let g:lsp_mode = "coc"
endif

if g:complete_mode isnot# "coc" && g:lsp_mode is# "coc"
  let g:lsp_mode = "none"
endif

if g:lsp_mode is# "none"
  \ || g:complete_mode is# "none"
  let g:ts_lsp_mode = "none"
endif

if g:complete_mode is# "coc"
  let g:ts_lsp_mode = "lsp"
endif


let g:from_pwsh = 0
let g:is_wsl = 0
silent! let g:from_pwsh = !has('nvim') && $RunFromPowershell ==# '1'
silent! let g:is_wsl =
      \ has('unix')
      \ && system('uname -r') =~? 'microsoft'

" option basic {{{
let g:mapleader = "\<SPACE>"
syntax enable

if has('nvim') && g:mode is# 'huge'
  set foldmethod=expr
  set foldexpr=nvim_treesitter#foldexpr()
endif

set number
set cursorline
set cursorcolumn
set virtualedit=block
set smartindent
set laststatus=2
set notitle
set wrap

set completeopt=menu

set noshowmatch
set novisualbell

set background=dark

set conceallevel=0
set concealcursor=
augroup my-help-conceal
  autocmd!
  autocmd BufWinEnter *
        \   if &filetype is# 'help'
        \   | setlocal conceallevel=0 concealcursor=
        \ | endif
augroup END

let g:loaded_matchparen = 1

set iskeyword+=-
set isfname+=@-@

set fileencodings=utf-8,cp932,utf-16le,euc-jp,sjis
set fileformats=unix,dos
set noswapfile
set noautoread
set hidden
set showcmd
if has('nvim')
  set wildmode=full
else
  set wildmode=list:full
endif
set wildignorecase

set foldmethod=marker
set foldlevel=2

set backup

let s:backupdir = expand('~/.tmp/vim/backup')
if !isdirectory(s:backupdir)
  silent! call mkdir(s:backupdir, 'p')
endif

if isdirectory(s:backupdir)
  let &backupdir = s:backupdir
endif

set undofile

let s:undofiledir = has('nvim') ? expand('~/.tmp/nvim/undofile') : expand('~/.tmp/vim/undofile')

if !isdirectory(s:undofiledir)
  silent! call mkdir(s:undofiledir, 'p')
endif

if isdirectory(s:undofiledir)
  let &undodir = s:undofiledir
endif

set matchpairs+=<:>

set scrolloff=7

set backspace=indent,eol,start

set belloff=all

set ttimeout
set notimeout

set mouse=

set viewdir=$HOME/.vim_view/

set splitbelow
set splitright

set shortmess=asToOFcI


augroup my_IME_setting
  autocmd!
  autocmd InsertLeave * set iminsert=0
augroup END
set iminsert=0


set ignorecase
set nosmartcase
set incsearch
set wrapscan
set hlsearch
nnoremap <silent> <ESC><ESC> :<C-u>nohlsearch<CR><ESC>
nnoremap <silent> <C-c> :<C-u>nohlsearch<CR><ESC>
nnoremap <silent> <SPACE>j :ccl<CR>

set diffopt+=vertical

set nofixeol


" 不可視文字表示
set list
" 不可視文字を可視化
set listchars=tab:>-,eol:$,extends:≫,precedes:≪,nbsp:%
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅(スペースいくつ分)
set tabstop=4
" 行頭でのTab文字の表示幅
set shiftwidth=2

" K でカーソル下のワードを :help
set keywordprg=:help


if !has('guirunning') && exists('&termguicolors') && has('nvim')
  set termguicolors
endif

if has('guirunning') || exists('&termguicolors')
  if exists('&pumblend') | set pumblend=20 | endif
  if exists('&winblend') | set winblend=20 | endif
endif



if exists('&inccommand') | set inccommand=nosplit | endif

" -- Windows でのクリップボード
if (has('win32') || has('win32unix')) && has('nvim')
  let g:clipboard = {
        \   'name': 'clip.exe + win32yank.exe for Windows',
        \   'copy': {
        \      '+': 'clip.exe',
        \      '*': 'clip.exe',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o',
        \      '*': 'win32yank.exe -o',
        \   },
        \   'cache_enabled': 1,
        \ }
endif
" -- WSL でのクリップボード
if g:is_wsl && has('nvim')
  let g:clipboard = {
        \   'name': 'win32yank.exe from WSL',
        \   'copy': {
        \      '+': 'win32yank.exe -i',
        \      '*': 'win32yank.exe -i',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o',
        \      '*': 'win32yank.exe -o',
        \   },
        \   'cache_enabled': 1,
        \ }
endif

function! s:setup_my_colo()
  if !exists('g:colors_name') | return | endif
  if g:colors_name ==? 'hybrid'
    " :help group-name
    hi Special ctermfg=DarkRed guifg=Orange
    hi SpecialChar ctermfg=DarkRed guifg=Orange
    hi SpecialComment ctermfg=DarkRed guifg=Orange
    hi Tag ctermfg=DarkRed guifg=Orange
    hi Delimiter ctermfg=DarkRed guifg=Orange
    hi Debug ctermfg=DarkRed guifg=Orange
  endif
endfunction

augroup my_colo
  autocmd ColorScheme * :call <SID>setup_my_colo()
augroup END

if has('win32')
  let g:scoop_dir = exists('$SCOOP') ? $SCOOP : expand('~\scoop')
  let g:scoop_global_apps = exists('$SCOOP_GLOBAL') ? $SCOOP_GLOBAL : expand('C:\ProgramData\scoop\apps')
endif



if has('nvim')
  let g:python3_host_prog = systemlist('which python3')[0]
else
  if has('win32unix')
    " 対応しない！
  elseif has('win32')
    let s:candidates = [
          \   expand(g:scoop_dir .. '\apps\python36\current\python36.dll'),
          \   expand(g:scoop_global_apps .. '\python36\current\python36.dll'),
          \ ]
    for s:candidate in s:candidates
      if has('python3') | break | endif
      let &pythonthreedll = s:candidate
    endfor

    if !has('python3')
      echom 'Not found python36 dll.'
      echom 'NOTE: "scoop install python36"'
      echom 'NOTE: and "scoop reset python36" to use pip of this version'
      echom 'NOTE: Use neovim.'
    endif
  endif
endif

command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
      \ | diffthis | wincmd p | diffthis
" }}}

" mapping {{{
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
  exe 'inoremap <silent> <A-' .. s:wincmd .. "> <C-o>:<C-u>call VimAndTmuxMove('" .. s:wincmd .. "', 0)<CR>"
  exe 'cnoremap <silent> <A-' .. s:wincmd .. "> <C-r>=<C-u>VimAndTmuxMove('" .. s:wincmd .. "', 1)<CR>"
  exe 'tnoremap <silent> <A-' .. s:wincmd .. "> <C-\><C-n>:<C-u>silent! call VimAndTmuxMove('" .. s:wincmd .. "', 0)<CR>"
endfor

nnoremap <Leader>sw :<C-u>SSave!__1<CR>
nnoremap <Leader>sp :<C-u>SLoad __1<CR>

nnoremap <silent> <Leader>y :<C-u>%y+<CR>
nnoremap <silent> <Leader>v ggVGs<ESC>"+P

inoremap # X<C-h>#

function s:n_GTGT()
  let smartindent_save = &smartindent
  set nosmartindent
  normal! >>
  let &smartindent = smartindent_save
endfunction

function s:x_GT()
  let smartindent_save = &smartindent
  set nosmartindent
  normal! >gv
  let &smartindent = smartindent_save
endfunction

nnoremap <silent> >> <CMD>:call <SID>n_GTGT()<CR>
xnoremap <silent> > <CMD>:call <SID>x_GT()<CR>

xnoremap <silent> <LT> <LT>gv

noremap <expr> 0 getline('.')[: col('.') - 2] =~# '^\s\+$' ? '0' : '^'
" }}}

if (v:version < 802 && !has('nvim')) || (v:version < 800 && has('nvim'))
  augroup init-vim
    autocmd VimEnter * echomsg "Version of vim is old. Update your vim."
  augroup END
  finish
endif

" nvim {{{
if has('nvim')
  if has('win32unix') || has('win32')
    let g:nvim_python3 = expand('$HOME/.pyenv/pyenv-win/versions/3.8.3/python.exe')
    if filereadable(g:nvim_python3)
      let g:python3_host_prog = g:nvim_python3
    endif
  elseif has('unix')
    let g:nvim_python3 = expand('$HOME/.local/venvs/nvim/bin/python3')
    if filereadable(g:nvim_python3)
      let g:python3_host_prog = g:nvim_python3
    else
      echohl WarningMsg
      echomsg "[>_<] You didn't run $HOME/dotfiles/scripts/setup-nvim-python3.sh"
      echohl None
    endif
  endif
endif
" }}}

source ~/dotfiles/vim/dein-setting.vim

" gvim {{{
if has('gui_running')
  set guioptions+=e
  " メニューバーを消す
  set guioptions-=m
  " ツールバーを消す
  set guioptions-=T
  " スクロールバーを消す
  set guioptions-=r
  set guioptions-=R
  set guioptions-=l
  set guioptions-=L

  set guifont=RictyDiminished\ NF:h11
endif
" }}}

" powershel {{{
function! g:SetupPwsh() abort
  colorscheme darkblue
  set nocursorline
  set nocursorcolumn
endfunction

if g:from_pwsh
  call g:SetupPwsh()
endif

if !g:from_pwsh && g:mode is# 'huge'
  augroup init-vim
    autocmd VimEnter * ++once ++nested
        \ if exists(':LoadColorScheme')
        \ |  LoadColorScheme
        \ | endif
  augroup END
endif
" }}}

" vim:foldmethod=marker

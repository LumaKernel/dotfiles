
let g:mapleader = "\<SPACE>"

syntax enable

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
if (has('win32') || has('win32unix')) && has('nvim') && executable('win32yank.exe') && executable('clip.exe')
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
if g:is_wsl && has('nvim') && executable('win32yank.exe')
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

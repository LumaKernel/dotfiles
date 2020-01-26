
let g:mapleader = "\<SPACE>"

cd ~

syntax enable

set number
set cursorline
set cursorcolumn
set virtualedit=block,onemore
set smartindent
set laststatus=2
set notitle
set wrap

set noshowmatch
set novisualbell

set conceallevel=0
" modeline の後
augroup MyConcealLevel
  au!
  au FileType help au BufEnter * ++once set conceallevel=0
augroup END

let g:loaded_matchparen = 1

set fileencodings=utf-8,cp932,utf-16le,euc-jp,sjis
set noswapfile
set autoread
set hidden
set showcmd
set wildmode=list:full
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

let s:undofiledir = expand('~/.tmp/vim/undofile')

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
nmap <silent> <ESC><ESC> :nohlsearch<CR><ESC>

set diffopt+=vertical



" 不可視文字表示
set list
" 不可視文字を可視化
set listchars=tab:\≫-,eol:$,extends:≫,precedes:≪,nbsp:%
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅(スペースいくつ分)
set tabstop=2
set shiftwidth=2 " 行頭でのTab文字の表示幅

" K でカーソル下のワードを :help
set keywordprg=:help


if has('nvim') && !g:is_wsl
  set pumblend=20
  set winblend=20
endif


" -- WSL でのクリップボード

if g:is_wsl && has('nvim') && executable('win32yank.exe')
  let g:clipboard = {
        \   'name': 'myClipboard',
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


if has('nvim')
  if has('win32unix')
    let g:python3_host_prog = system('which python3')
  elseif (has('win32') || has('win64'))
    let g:python3_host_prog = split(system('where python'), "\n")[0]
  endif
else
  if has('win32unix')
    " TODO : MSYS2 のpython 対応をどうするかはなやましい
    " Win 側の python に即席でパスを通すのもありかもしれないけど…
  elseif (has('win32') || has('win64'))
    let &pythonthreedll = expand('~\scoop\apps\python36\current\python36.dll')
    if !has('python3')
      echom 'Not found python36 dll.'
      echom 'NOTE: "scoop install python36"'
      echom 'NOTE: and "scoop reset python36" to use pip of this version'
    endif
  endif
endif


command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
      \ | diffthis | wincmd p | diffthis



" 自分で入れた win32yank があると壊れてしまうので
" 調整する…

let s:scoop_dir = expand('~/scoop')
let s:global_scoop_dir = expand('~/scoop')

if has('nvim') && has('win32')
  let l:paths = split($PATH, ';')


  let $PATH = join(l:paths, ';')
endif



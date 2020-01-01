
let g:mapleader = "\<SPACE>"

cd ~

syntax enable

set number
set cursorline
set cursorcolumn
set virtualedit=onemore
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

set fileencodings=utf-8,cp932,euc-jp,sjis
set noswapfile
set autoread
set hidden
set showcmd
set wildmode=list:full

set foldmethod=marker

set backup
set backupdir=~/.tmp/vim/backup

set undofile
set undodir=~/.tmp/vim/undofile

set matchpairs+=<:>

set scrolloff=7

set backspace=indent,eol,start

set belloff=all

set ttimeout
set notimeout

set mouse=

set viewdir=$HOME/.vim_view/


augroup my_IME_setting
  autocmd!
  autocmd InsertLeave * set iminsert=0
augroup END
set iminsert=0


set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
nmap <silent> <ESC><ESC> :nohlsearch<CR><ESC>


" 不可視文字表示
set list
" 不可視文字を可視化
set listchars=tab:\≫-,eol:$,extends:≫,precedes:≪,nbsp:%
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅(スペースいくつ分)
set tabstop=2
set shiftwidth=2 " 行頭でのTab文字の表示幅

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
  if (has('win32') || has('win64'))
    set pythonthreedll=~/scoop/apps/python36/current/python36.dll
    if !has('python3')
      echom 'Not found python37 dll.'
      echom 'NOTE: scoop install python37'
      echom 'NOTE: and scoop reset python37 to use pip of this version'
    endif
  endif
endif




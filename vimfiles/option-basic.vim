
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




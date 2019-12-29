set encoding=utf-8
scriptencoding utf-8

let g:mapleader = "\<SPACE>"

" コメント方針 : 適当に書く．日本語で書く．
"   ぶっちゃけ理解したものは消す
"   :help を，見ろ

source ~/dotfiles/vimfiles/dein-setting.vim
source ~/dotfiles/vimfiles/option-basic.vim
source ~/dotfiles/vimfiles/mapping.vim

" 全角スペース・行末のスペース・タブの可視化
" 全角スペース可視化のみ抜粋
if has("syntax")
    " PODバグ対策
    syn sync fromstart
    function! ActivateInvisibleIndicator()
        " 下の行の"　"は全角スペース
        syntax match InvisibleJISX0208Space "　" display containedin=ALL
        highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=darkgray gui=underline
    endfunction
    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif


" Vim と explorer, Finder, terminal への橋渡し{{{
if has('mac')
  nnoremap <silent> <Leader>u :!open .<CR>
  nnoremap <silent> <Leader>o :!open -a Terminal.app .<CR>
elseif has('win32') || has('win64')
  if has('gui')
    nnoremap <silent> <expr> <Leader>u ":silent !start explorer .\<CR>"
    nnoremap <silent> <Leader>o :silent !start cmd<CR>
    nnoremap <silent> <expr> <Leader>i ":silent !start " . $LocalAppData . "\\wsltty\\bin\\mintty.exe --WSL=\"Ubuntu\" --configdir=\"" . $AppData . "\\wsltty\"\<CR>"

    let s:msys_path = "C:/msys64/msys2_shell.cmd"
    if executable(s:msys_path)
      let s:to_reset = ["VIM", "VIMRUNTIME", "MYVIMRC", "MYGVIMRC"]
      let s:env_reset = join(map(s:to_reset, '"set \"" . v:val . "=\" && "'), "")
      let g:msys_run_cmd = ":silent !start cmd /k " . s:env_reset . s:msys_path . " -where . -mingw64 -mintty -no-start && exit" . "\<CR>"
      nnoremap <silent> <expr> <Leader>b g:msys_run_cmd
    endif
  endif
elseif has('unix')
  " --working-directory=は必要なし
  nnoremap <silent> <Leader>u :!xdg-open .<CR>
  nnoremap <silent> <Leader>o :!gnome-terminal<CR>
endif
"}}}

" GVIMの設定{{{
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

  if has('unix')
    set guifont=MyricaM\ M\ 14,Source\ Code\ Pro\ for\ Powerline\ 11,Source\ Code\ Pro\ 11
  else
    set guifont=Myrica\ M:h12,Osaka-Mono:h14
  endif
endif
set iminsert=0
" }}}

" c++ {{{

" private:とかのインデントを作らない(たぶん
set cinoptions=g0

augroup cpp-namespace
  autocmd!
  autocmd FileType cpp inoremap <buffer><expr>; <SID>expand_namespace()
augroup END
function! s:expand_namespace()
  let s = getline('.')[0:col('.')-2]
  if s =~# '\<b;$'
    return "\<BS>oost::"
  elseif s =~# '\<s;$'
    return "\<BS>td::"
  elseif s =~# '\<z;$'
    return "\<BS>\<BS>size_t "
  else
    return ';'
  endif
endfunction

" }}}

" 競プロ向け設定{{{

au FileType vimshell imap <buffer> <C-K> <Plug>(neosnippet_expand_or_jump)

au FileType text nnoremap <silent> <Leader>w :w!<CR>
let s:creg = has('unix') ? "+" : "*"

function! s:copyall()
  let l:cursor = getcurpos()
  execute 'normal! ggVG"' . s:creg . 'y'
  call setpos('.', l:cursor)
endfunction

nnoremap <silent> <Leader>c :call <SID>copyall()<CR>
if has('unix')
  nnoremap <silent> <Leader>v ggVGs<ESC>"+P:w!<CR>
else
  nnoremap <silent> <Leader>v ggVGs<ESC>"*P:w!<CR>
endif
nmap <Leader>t ggVGstemp

" <Leader>f#{a} で :e #{a}.cpp
for i in range(char2nr("a"), char2nr("z"))
  execute
        \"nnoremap <Leader>f" . nr2char(i) . " " .
        \":e " . nr2char(i) . ".cpp\<CR>"
endfor

function! s:cp_cpp()
  " <Leader><F#{i}>
  " clipboard を "%:r" . _in#{i} に F#{i} キーで保存
  for i in range(1, 9)
    let l:file_expand = '" . expand("%:r") . "_in' . i
    execute
          \"nnoremap <silent> <expr><buffer> <Leader><F" . i .
          \'> ":e ' . l:file_expand . '<CR>' .
          \'ggVG\"' . s:creg . 'P:w!<CR>2<C-O>' .
          \':bd ' . l:file_expand . '<CR>' .
          \':echo \"ready, ' . l:file_expand . '\"<CR>"'
  endfor

  " <Leader>e<F#{i}>
  " "%:r" . _in#{i} を開く
  for i in range(1, 9)
    let l:file_expand = '" . expand("%:r") . "_in' . i
    execute
          \"nnoremap <expr><buffer> <Leader>e" . i .
          \' ":e ' . l:file_expand . '<CR>"'
  endfor

  " <Leader>#{i} で "%:r" . _in#{i} を input として % を実行
  for i in range(1, 9)
    execute
          \'nnoremap <expr><buffer> <Leader>' . i .
          \' ":ccl\|QuickRun -input " . expand("%:r") . "_in' . i .
          \'\<CR>"'
  endfor
  nnoremap <F1> <Nop>
endfunction

augroup my_cpp
  au!
  autocmd Filetype cpp call <SID>cp_cpp()
augroup END

" }}}

" 一時的な最大化 {{{

augroup MaxmizeWindow
  autocmd!
  autocmd WinNew,WinLeave,BufLeave,BufDelete * call MaximizeInactivate(1)
augroup END

function! MaximizeInactivate(showMessage)
  if exists("s:maximize_processing") && s:maximize_processing
    return
  endif
  let s:maximize_processing = 1
  if exists("s:maximize_session")
    silent! call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
    if a:showMessage
      redraw | echo "最大化モードを中止します"
    endif
  endif
  unlet s:maximize_processing
endfunction

function! MaximizeToggle()
  if exists("s:maximize_processing") && s:maximize_processing
    return
  endif
  let s:maximize_processing = 1
  if exists("s:maximize_session")

    " 現在編集しているバッファの状態を保存する
    " &viewdir の設定が必要
    mkview

    silent! exec "source " . s:maximize_session
    silent! call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save

    let l:win = win_getid()

    if s:maximize_nerdtree_open
      if exists(":NERDTree") == 2
        :NERDTree
        cal win_gotoid(l:win)
      endif
    endif

    unlet s:maximize_nerdtree_open


    if &ft == "qf"
      copen
    endif

    " 編集していたバッファの状態を復元する
    loadview

    redraw | echo "全画面モードを終了します"
  else
    if winnr('$') == 1
      redraw | echo "既にウィンドウは1つしかありません. 全画面モードを開始できません"
    else
      let s:maximize_hidden_save = &hidden
      let s:maximize_session = tempname()
      silent! let s:maximize_nerdtree_open = <SID>CloseNERDTree() > 0

      silent! call <SID>NameAllBuffers()

      set hidden
      
      let l:save_sesssionops = &sessionoptions
      " options の set guifont は windows においてリサイズと同じで
      " 副作用があるので無効化
      set sessionoptions=blank,buffers,folds,help,tabpages,terminal

      exec "mksession! " . s:maximize_session

      let &sessionoptions = l:save_sesssionops

      let l:foldenable = &foldenable

      if l:foldenable
        set nofoldenable
      endif

      silent! only

      if l:foldenable
        set foldenable
      endif

      redraw | echo "全画面モードを開始します"
    endif
  endif
  unlet s:maximize_processing
endfunction

" }}}

" reference : https://stackoverflow.com/questions/3155461/how-to-delete-multiple-buffers-in-vim
" NERDTREEを閉じて数える {{{

function! <SID>CloseNERDTree()
  let l:bufNr = bufnr("$")
  let l:cnt = 0
  while l:bufNr > 0
    if bufwinid(l:bufNr) != -1
      if bufname(l:bufNr) =~? "nerd_tree*"
        execute "bd ".l:bufNr
        let l:cnt = l:cnt + 1
      endif
    endif
    let l:bufNr = l:bufNr - 1
  endwhile
  return l:cnt
endfunction

" }}}

" すべてのウィンドウに表示されているバッファに名前をつける {{{

function! <SID>NameAllBuffers()
  let l:bufNr = bufnr("$")
  let l:cnt = 0
  let l:now = bufnr("%")

  while l:bufNr > 0
    if bufwinid(l:bufNr) != -1
      if bufname(l:bufNr) == ""
        exec "buf " . l:bufNr
        exec "file __auto_" . l:bufNr . <SID>timestamp()
        let l:cnt = l:cnt + 1
      endif
    endif
    let l:bufNr = l:bufNr - 1
  endwhile

  exec "buf " . l:now
  return l:cnt
endfunction

" }}}

" timestanmp {{{

function! <SID>timestamp()
  return strftime("%Y/%m/%d (%a) %H:%M")
endfunction

" }}}

" debug commands
" VimShowHlGroup: Show highlight group name under a cursor
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
" VimShowHlItem: Show highlight item name under a cursor
command! VimShowHlItem echo synIDattr(synID(line("."), col("."), 1), "name")

nnoremap <Leader>; :VimShowHlGroup<CR>
nnoremap <Leader>: :VimShowHlItem<CR>

function! s:setup_my_colo()
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


" debug

finish

command! GO cd ~/.cache/dein/repos/github.com/LumaKernel/coquille/dev/coq-examples
command! MES :new | :put =execute('mes') | :only
command! M :new | :put =g:mymes | :only
command! MC :let g:mymes=[]

GO

let g:coquille_strict_check = 0
let g:coquille_cursor_ceiling = 1
let g:coquille_update_status_always = 1

if has('win32unix')
  " let g:coquille_coq_executable = '/c/Coq/bin/coqtop.exe'
  let g:coquille_coq_executable = '/c/Coq8.10/bin/coqidetop'
elseif has('win32') || has('win64')
  " let g:coquille_coq_executable = 'C:/Coq8.9/bin/coqidetop.opt'
  " let g:coquille_coq_executable = 'C:/Coq8.9/bin/coqidetop'
  let g:coquille_coq_executable = 'C:/Coq8.10/bin/coqidetop'
  " let g:coquille_coq_executable = 'C:/Coq8.5pl3/bin/coqtop'
  " let g:coquille_coq_executable = 'C:/Coq8.11beta/bin/coqidetop'
  " let g:coquille_coq_executable = 'C:/Coq8.11beta/bin/coqidetop.opt'
endif

let g:PowerAssert = vital#vital#import('Vim.PowerAssert')
let g:Assert = g:PowerAssert.assert

let g:mymes = []
command! -nargs=1 ECHO :exe 'echom "' .. escape(<q-args>, '\"') .. ' = " .. ' .. 'webapi#json#encode(<args>)'


function! g:CreateElement(name, attr, ...) abort
  let element = webapi#xml#createElement(a:name)
  let element.attr = a:attr
  if a:0
    call element.value(a:000[0])
  endif
  return element
endfunction










function! Dev()
  " silent! edit ~/hoge.v
  silent! edit ./nasty_notations.v
  call coquille#register()
  hi CheckedByCoq guibg=#111130
  hi SentToCoq guibg=#336633

  let g:coquille_debug = 1

  " call coquille#launch()
  " let g:IDE = b:coquilleIDE
  " let g:CT = b:coquilleIDE.coqtop_handler

endfunction

call Dev()

call coquille#test#runTest()



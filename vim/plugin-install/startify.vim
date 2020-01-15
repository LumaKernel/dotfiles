call dein#add('mhinz/vim-startify', {
      \   'hook_post_source': function('s:post_source'),
      \ })

function s:repeat(str, num)
  return join(map(range(a:num), 'a:str'), '')
endfunction

" g:mapping_descriptions でマッピングの説明を管理
" let g:mapping_descriptions = ['マッピング名', '説明']
" で自由に追加できる

function! g:MappingDescriptions()
  let s:S = vital#vital#import('Data.String')
  let left_width = max(map(deepcopy(g:mapping_descriptions), 'strlen(v:val[0])')) + 4
  let width = max(map(deepcopy(g:mapping_descriptions), 'l:left_width + strlen(v:val[1])'))
  let strs = map(deepcopy(g:mapping_descriptions), '"|  " .. s:S.pad_right(s:S.pad_right(v:val[0], l:left_width) .. v:val[1], l:width) .. "  |"')

  return [
        \   '+' .. s:repeat('-', 2 + width + 2) .. '+',
        \ ] + strs + [
        \   '+' .. s:repeat('-', 2 + width + 2) .. '+',
        \ ]
endfunction

let g:my_startify_message = [
      \   "\uf120  Welcome to \ue7c5",
      \   "",
      \   "Sessions.vim をプロジェクトフォルダ内に置くことでセッションを保存",
      \   "もしくは :SSave を使う",
      \   "",
      \ ]

let g:startify_enable_special = 0
let g:startify_session_dir = '~/.tmp/vim/startify-session'

let g:startify_custom_header = 'startify#pad(g:my_startify_message + g:MappingDescriptions())'

" .git とか (VCS) が見つかるまで上に登って change directory する
let g:startify_change_to_dir = 1
let g:startify_change_to_vcs_root = 1


" 最新の状態にする
let g:startify_update_oldfiles = 0

let g:startify_session_persistence = 1

let g:startify_bookmarks = [
      \   '~/cp',
      \   '~/mystudy',
      \   '~/work',
      \   '~/dotfiles',
      \   '~/.cache/dein/repos',
      \]

function! s:MyColorSelections()
  return [
        \   { 'line': 'tender' , 'cmd': 'colo tender' },
        \   { 'line': 'darkblue' , 'cmd': 'colo darkblue' },
        \ ]
endfunction


let g:startify_commands = [
      \   ':DeinClean',
      \   ':call dein#recache_runtimepath()',
      \   ':CocConfig',
      \ ]

let g:startify_lists = [
      \ { 'type': 'bookmarks', 'header': ['   \uf461 ブックマーク'] },
      \ { 'type': 'files',     'header': ['   \uf490 最近開いたファイル'] },
      \ { 'type': 'dir',       'header': ['   \uf490 最近開いたファイル in ' .. getcwd()] },
      \ { 'type': 'sessions',  'header': ['   \ue706 セッション'] },
      \ { 'type': 'commands',  'header': ['   \uf489 コマンド'] },
      \ { 'type': function('s:MyColorSelections'),  'header': ['   \u26a1 カラーテーマ'] },
      \ ]


function! s:post_source() abort
  augroup init_vim
    au User StartifyReady silent! nunmap <buffer> q
    au User StartifyReady silent! nunmap <buffer> t
    au User StartifyReady silent! nunmap <buffer> T
  augroup END
endfunction


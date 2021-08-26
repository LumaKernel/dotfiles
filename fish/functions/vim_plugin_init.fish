function vim_plugin_init
  set -l path local_init.vim
  if test -f $path
    echo "ERROR: $path already exists.";
    return 1
  end

  echo "if exists('s:loaded')
  finish
endif
let s:loaded = 1

function! HelloFunc() abort
  unsilent echom \"HelloFunc\"
endfunction

let g:HelloLambda = {-> execute('unsilent echom \"HelloLambda\"', '')}

unsilent echom '--- local_init.vim debugging'

\" let &rtp = expand('<sfile>:p:h') . ',' . &rtp
\" vsplit scheme://foo/bar
" > $path
end

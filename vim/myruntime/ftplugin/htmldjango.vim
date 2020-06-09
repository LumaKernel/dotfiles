
" splitjoin.vim の設定

let b:splitjoin_split_callbacks = [
      \ 'sj#html#SplitTags',
      \ 'sj#html#SplitAttributes'
      \ ]

let b:splitjoin_join_callbacks = [
      \ 'sj#html#JoinAttributes',
      \ 'sj#html#JoinTags'
      \ ]

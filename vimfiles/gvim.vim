
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

# 参考
# /etc/skel/.bashrc
# http://www.unixuser.org/~euske/doc/bashtips/bashrc.html

# インタラクティブではない場合，終了
case $- in
    *i*) ;;
      *) return;;
esac

echo '.bashrc'
echo '    - for macOS'

# -- vim の環境変数を削除
unset VIM
unset VIMRUNTIME
unset MYVIMRC
unset MYGVIMRC

# -- user installed bin
export PATH=$PATH:$HOME/bin

# -- delete my fish envs
export powerline_fish_key_bindings=
export powerline_fish_bind_mode=

# -- tmux and fish
if [[ -z $NO_TMUX ]] ; then
  export NO_TMUX=1
  command -v fish >/dev/null 2>&1 && exec tmux
fi

if [[ -z $NO_FISH ]] ; then
  export NO_FISH=
  command -v fish >/dev/null 2>&1 && exec fish
fi


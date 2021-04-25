function nvim_reload
  nvim +"call dein#recache_runtimepath()" +qa!
  and nvim +":UpdateRemotePlugins" +qa!
end

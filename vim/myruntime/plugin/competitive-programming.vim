
command! Compete call competitive#compete(getcwd())
if competitive#ready(getcwd())
  call competitive#start()
endif


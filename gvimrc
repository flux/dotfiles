" Disable toolbar
set go-=T

" Local config
if filereadable($HOME . "/.gvimrc.local")
  source $HOME/.gvimrc.local
endif

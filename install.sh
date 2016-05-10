#!/usr/bin/env zsh

set -e

dotfiles_dir="$(cd "${0%/*}"; pwd)"
skip=("README.markdown" "install.sh" "termsupport")

for file in "$dotfiles_dir"/*; do
  name="$(basename "$file")"
  dotname=".${name}"

  if (($skip[(Ie)$name])); then
    echo "Skipping: $name"
    continue
  else
    ln -sfnv ${file} "${HOME}/${dotname}"
  fi
done

# Allow nvim to use vim files/folder
mkdir -p $HOME/.config
ln -sfnv $HOME/.vim $HOME/.config/nvim
ln -sfnv $HOME/.vimrc $HOME/.config/nvim/init.vim

if [ ! -e $HOME/.vim/tmp ]; then
  echo "Creating ~/.vim/tmp folder"
  mkdir -p $HOME/.vim/tmp
fi

if [ ! -e $HOME/.vim/autoload/plug.vim ]; then
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Does this machine support truecolor?
_append_truecolor_config() {
  # Enable true color for neovim
  echo 'if hash("nvim")' >> $HOME/.vimrc.local
  echo '  let $NVIM_TUI_ENABLE_TRUE_COLOR=1' >> $HOME/.vimrc.local
  echo 'endif' >> $HOME/.vimrc.local

  # Enable truecolor in tmux 2.2+
  echo 'set-option -ga terminal-overrides ",xterm-256color:Tc"' >> $HOME/.tmux.conf.local
}

while true; do
  read "?Does this machine support truecolor in terminal? " yn
  case $yn in
    [Yy]* ) _append_truecolor_config; break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done


vim -u $HOME/.vimrc.bundles +PlugInstall +PlugClean! +qa

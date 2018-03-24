#! /bin/bash
dotfolder_names=$@
echo "[include]" >> ~/dotfiles-multiplexer/built-dots/.gitconfig
for dotfolder_name in $dotfolder_names; do
  echo "  path = ~/$dotfolder_name/.gitconfig" >> ~/dotfiles-multiplexer/built-dots/.gitconfig
done

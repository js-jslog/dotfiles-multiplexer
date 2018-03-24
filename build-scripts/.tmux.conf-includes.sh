#! /bin/bash

dotfolder_names=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

for dotfolder_name in $dotfolder_names; do
  echo "if-shell \"[ -f ~/$dotfolder_name/.tmux.conf ]\" 'source ~/$dotfolder_name/.tmux.conf'" >> $multiplexer/built-dots/.tmux.conf
done

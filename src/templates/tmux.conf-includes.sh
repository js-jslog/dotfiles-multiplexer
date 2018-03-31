#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

for dotfolder_location in $dotfolder_locations; do
  echo "if-shell \"[ -f $dotfolder_location/.tmux.conf ]\" 'source $dotfolder_location/.tmux.conf'" >> $multiplexer/build/.tmux.conf
done

#! /bin/bash

dotfolder_names=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

echo "[include]" >> $multiplexer/built-dots/.gitconfig
for dotfolder_name in $dotfolder_names; do
  echo "  path = ~/$dotfolder_name/.gitconfig" >> $multiplexer/built-dots/.gitconfig
done

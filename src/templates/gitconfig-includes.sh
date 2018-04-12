#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

echo "[include]" >> $build/.gitconfig
for dotfolder_location in $dotfolder_locations; do
  echo "  path = $dotfolder_location/.gitconfig" >> $build/.gitconfig
done

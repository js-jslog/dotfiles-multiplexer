#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

for dotfolder_location in $dotfolder_locations; do
  reponame=$(basename ${dotfolder_location/-/})
  echo "let \$$reponame=expand(\"$dotfolder_location/.vimrc\")" >> $multiplexer/build/.vimrc
  echo "if filereadable(\$$reponame)" >> $multiplexer/build/.vimrc
  echo "  source \$$reponame" >> $multiplexer/build/.vimrc
  echo "endif" >> $multiplexer/build/.vimrc
done

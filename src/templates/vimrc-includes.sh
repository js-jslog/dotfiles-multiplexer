#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

for dotfolder_location in $dotfolder_locations; do
  reponame=$(basename ${dotfolder_location/-/})
  echo "let \$$reponame=expand(\"$dotfolder_location/.vimrc\")" >> $build/.vimrc
  echo "if filereadable(\$$reponame)" >> $build/.vimrc
  echo "  source \$$reponame" >> $build/.vimrc
  echo "endif" >> $build/.vimrc
done

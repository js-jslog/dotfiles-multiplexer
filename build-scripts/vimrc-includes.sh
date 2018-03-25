#! /bin/bash

dotfolder_names=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

for dotfolder_name in $dotfolder_names; do
  echo "let \$${dotfolder_name/-/}=expand(\"~/$dotfolder_name/.vimrc\")" >> $multiplexer/built-dots/.vimrc
  echo "if filereadable(\$${dotfolder_name/-/})" >> $multiplexer/built-dots/.vimrc
  echo "  source \$${dotfolder_name/-/}" >> $multiplexer/built-dots/.vimrc
  echo "endif" >> $multiplexer/built-dots/.vimrc
done

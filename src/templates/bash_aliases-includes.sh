#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

# add some aliases for interacting with the dotfiles-multiplexer
echo "export dotfiles_multiplexer=$multiplexer" >> $multiplexer/build/.bash_aliases
echo "alias dotsmplex=\"cd \$dotfiles_multiplexer\"" >> $multiplexer/build/.bash_aliases


for dotfolder_location in $dotfolder_locations; do
  echo "if [ -f $dotfolder_location/.bash_aliases ]; then" >> $multiplexer/build/.bash_aliases
  echo "  . $dotfolder_location/.bash_aliases" >> $multiplexer/build/.bash_aliases
  echo "fi" >> $multiplexer/build/.bash_aliases
done

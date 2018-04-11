#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

. $multiplexer/src/helpers/alias-to-location.sh

# dotfiles-multiplexer aliases
echo "alias dotsmp=\"cd $multiplexer\"" >> $multiplexer/build/.bash_aliases

# aliases for imported dotfolders
for dotfolder_location in $dotfolder_locations; do
  echo "alias $(locationsToAliases $dotfolder_location)=\"cd $dotfolder_location\"" >> $multiplexer/build/.bash_aliases
  echo "if [ -f $dotfolder_location/.bash_aliases ]; then" >> $multiplexer/build/.bash_aliases
  echo "  alias $(locationsToAliases $dotfolder_location)modal=\"vim $dotfolder_location/.bash_aliases && source ~/.bashrc\"" >> $multiplexer/build/.bash_aliases
  echo "  . $dotfolder_location/.bash_aliases" >> $multiplexer/build/.bash_aliases
  echo "fi" >> $multiplexer/build/.bash_aliases
done

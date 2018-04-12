#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

. $src/helpers/config-helper.sh

# dotfiles-multiplexer aliases
echo "alias dotsmp=\"cd $multiplexer\"" >> $build/.bash_aliases

# aliases for imported dotfolders
for alias in $setup_compose_bashaliases; do
  echo "alias $alias=\"cd $multiplexer/build/repos/$alias\"" >> $build/.bash_aliases
  echo "if [ -f $build/repos/$alias/.bash_aliases ]; then" >> $build/.bash_aliases
  echo "  alias ${alias}modal=\"vim $build/repos/$alias/.bash_aliases && source ~/.bashrc\"" >> $build/.bash_aliases
  echo "  . $build/repos/$alias/.bash_aliases" >> $build/.bash_aliases
  echo "fi" >> $build/.bash_aliases
done

#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi
# TODO: fix the locationsToAliases calls below
. $multiplexer/src/helpers/config-helper.sh

# dotfiles-multiplexer aliases
echo "alias dotsmp=\"cd $multiplexer\"" >> $multiplexer/build/.bash_aliases

# aliases for imported dotfolders
for alias in $setup_compose_bashaliases; do
  echo "alias $alias=\"cd $multiplexer/build/repos/$alias\"" >> $multiplexer/build/.bash_aliases
  echo "if [ -f $multiplexer/build/repos/$alias/.bash_aliases ]; then" >> $multiplexer/build/.bash_aliases
  echo "  alias ${alias}modal=\"vim $mutliplexer/build/repos/$alias/.bash_aliases && source ~/.bashrc\"" >> $multiplexer/build/.bash_aliases
  echo "  . $multiplexer/build/repos/$alias/.bash_aliases" >> $multiplexer/build/.bash_aliases
  echo "fi" >> $multiplexer/build/.bash_aliases
done

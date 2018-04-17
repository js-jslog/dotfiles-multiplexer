#! /bin/bash

function composeBashAliases() {
  local aliases=$@
  local alias

  # including the dotfiles-multiplexer's own aliases
  echo "if [ -f $multiplexer/src/dotfiles/.bash_aliases ]; then" >> $build/.bash_aliases
  echo "  . $multiplexer/src/dotfiles/.bash_aliases" >> $build/.bash_aliases
  echo "fi" >> $build/.bash_aliases

  for alias in $aliases; do
    local dotsrepo=$(aliasesToRepoLocations $alias)
    echo "alias $alias=\"cd $dotsrepo\"" >> $build/.bash_aliases
    echo "if [ -f $dotsrepo/.bash_aliases ]; then" >> $build/.bash_aliases
    echo "  alias ${alias}modal=\"vim $dotsrepo/.bash_aliases && source ~/.bashrc\"" >> $build/.bash_aliases
    echo "  . $dotsrepo/.bash_aliases" >> $build/.bash_aliases
    echo "fi" >> $build/.bash_aliases
  done

  printf "\nComposing .bash_alises ...\n"
  if [ -f $build/.bash_aliases ]; then
    cat $build/.bash_aliases
  else
    echo "no .bash_aliases generated"
  }

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

composeBashAliases $@

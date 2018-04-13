#! /bin/bash

function composeBashAliases() {
  local aliases=$@
  local alias

  # dotfiles-multiplexer aliases
  echo "alias dotsmp=\"cd $multiplexer\"" >> $build/.bash_aliases
  for alias in $aliases; do
    local dotsrepo=$(aliasesToRepoLocations $alias)
    echo "alias $alias=\"cd $dotsrepo\"" >> $build/.bash_aliases
    echo "if [ -f $dotsrepo/.bash_aliases ]; then" >> $build/.bash_aliases
    echo "  alias ${alias}modal=\"vim $dotsrepo/.bash_aliases && source ~/.bashrc\"" >> $build/.bash_aliases
    echo "  . $dotsrepo/.bash_aliases" >> $build/.bash_aliases
    echo "fi" >> $build/.bash_aliases
  done

  printf "\nComposing .bash_alises ...\n"
  cat $build/.bash_aliases
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

composeBashAliases $@

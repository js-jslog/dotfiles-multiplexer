#! /bin/bash

function composeGitconfig() {
  local aliases=$@
  local alias

  echo "[include]" >> $build/.gitconfig
  for alias in $aliases; do
    local dotsrepo=$(aliasesToLocations $alias)
    echo "  path = $dotsrepo/.gitconfig" >> $build/.gitconfig
  done

  printf "\nComposing .gitconfig ...\n"
  cat $build/.gitconfig
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

composeGitconfig $@

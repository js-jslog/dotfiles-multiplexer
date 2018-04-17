#! /bin/bash

function composeGitconfig() {
  local aliases=$@
  local alias

  echo "[include]" >> $build/.gitconfig
  for alias in $aliases; do
    local dotsrepo=$(aliasesToRepoLocations $alias)
    echo "  path = $dotsrepo/.gitconfig" >> $build/.gitconfig
  done

  printf "\nComposing .gitconfig ...\n"
  if [ -f $build/.gitconfig ]; then
    cat $build/.gitconfig
  else
    echo "no .gitconfig generated"
  fi
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

composeGitconfig $@

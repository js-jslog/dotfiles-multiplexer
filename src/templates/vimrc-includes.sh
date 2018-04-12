#! /bin/bash

function composeVimconfig() {
  local aliases=$@
  local alias
  for alias in $aliases; do
    local dotsrepo=$(aliasesToLocations $alias)
    local cleanalias=${alias/-/}
    echo "let \$$cleanalias=expand(\"$dotsrepo/.vimrc\")" >> $build/.vimrc
    echo "if filereadable(\$$cleanalias)" >> $build/.vimrc
    echo "  source \$$cleanalias" >> $build/.vimrc
    echo "endif" >> $build/.vimrc
  done
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

composeVimconfig $@

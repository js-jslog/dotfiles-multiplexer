#! /bin/bash

function pulldots() {
  local cwd=$PWD
  for repo in $(ls $dotfiles_multiplexer/build/repos/); do
    echo "PUlling $dotfiles_multiplexer/build/repos/$repo"
    cd $dotfiles_multiplexer/build/repos/$repo
    git pull
  done
  cd $cwd
}

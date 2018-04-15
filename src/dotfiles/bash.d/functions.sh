#! /bin/bash

function pulldots() {
  local cwd=$PWD
  for repo in $(ls $dotfiles_multiplexer/build/repos/); do
    echo "Pulling $dotfiles_multiplexer/build/repos/$repo"
    cd $dotfiles_multiplexer/build/repos/$repo
    git pull
  done
  cd $cwd
}

function pushdots() {
  local cwd=$PWD
  for repo in $(ls $dotfiles_multiplexer/build/repos/); do
    echo "Pushing $dotfiles_multiplexer/build/repos/$repo"
    cd $dotfiles_multiplexer/build/repos/$repo
    git push
  done
  cd $cwd
}

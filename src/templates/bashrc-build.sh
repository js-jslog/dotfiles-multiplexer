#! /bin/bash

function buildSymlinks() {
  local bash_perm_backup=".bashrc.orig_DO-NOT-DELETE"

  if [ ! -L $HOME/.bashrc ] && [ -f $HOME/.bashrc ]; then
    mv $HOME/.bashrc $HOME/$bash_perm_backup
  fi

  if [ ! -f $HOME/$bash_perm_backup ]; then
    echo "No source .bashrc file could be found. Is it possible that you or some other process has renamed it?"
    exit 1
  fi

  cp $HOME/$bash_perm_backup $build/.bashrc
  
  echo "############# INCLUDED BY THE DOTFILES MULTIPLEXER #############" >> $build/.bashrc
  echo "############# BASH.D INCLUDE #############" >> $build/.bashrc
  echo "# runs a collection of bash scripts. this is analogeous to the " >> $build/.bashrc
  echo "# /etc/profile.d folder but for interactive bash shells rather " >> $build/.bashrc
  echo "# than login shells" >> $build/.bashrc
  echo "if [ -d ~/bash.d ]; then" >> $build/.bashrc
  echo "  for i in ~/bash.d/*.sh; do" >> $build/.bashrc
  echo "    if [ -r \$i ]; then" >> $build/.bashrc
  echo "      . \$i" >> $build/.bashrc
  echo "    fi" >> $build/.bashrc
  echo "  done" >> $build/.bashrc
  echo "  unset i" >> $build/.bashrc
  echo "fi" >> $build/.bashrc
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

buildSymlinks $@

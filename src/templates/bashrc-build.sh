#! /bin/bash

function persistUnmanagedAdditions() {
  local additions=$(sed -n '/\#\#\#\#\#\#\#\#\#\#\#\#\# END INCLUDED BY THE DOTFILES MULTIPLEXER \#\#\#\#\#\#\#\#\#\#\#\#\#/ { s///; :a; n; p; ba; }' $build_backup/.bashrc)
  if [ ! -z "$additions" ]; then
    cp $HOME/$bashrc_persist_file_name $build_backup/$bashrc_persist_file_name
    printf "\n$additions" >> $HOME/$bashrc_persist_file_name

    sourceBashrc
  fi
}

function sourceBashrc() {
  if [ ! -L $HOME/.bashrc ] && [ -f $HOME/.bashrc ]; then
    mv $HOME/.bashrc $HOME/$bashrc_persist_file_name

    echo "" >> $HOME/$bashrc_persist_file_name
    echo "############# INCLUDED BY THE DOTFILES MULTIPLEXER     #############" >> $HOME/$bashrc_persist_file_name
    echo "############# UNMANAGED ADDITIONS                      #############" >> $HOME/$bashrc_persist_file_name
    echo "# additions made by other applications and synchronised here by dotfiles-multiplexer" >> $HOME/$bashrc_persist_file_name
    echo "# persistent modifications to these values must be made in $HOME/$bashrc_persist_file_name" >> $HOME/$bashrc_persist_file_name
  fi

  if [ ! -f $HOME/$bashrc_persist_file_name ]; then
    echo "No source .bashrc file could be found. Is it possible that you, me or some other process has renamed it?"
    exit 1
  fi

  cp $HOME/$bashrc_persist_file_name $build/.bashrc
}

function buildSymlinks() {
  echo "" >> $build/.bashrc
  echo "############# END UNMANAGED ADDITIONS                  #############" >> $build/.bashrc
  echo "############# BASH.D INCLUDE                           #############" >> $build/.bashrc
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
  echo "############# END BASH.D INCLUDE                       #############" >> $build/.bashrc
  echo "############# END INCLUDED BY THE DOTFILES MULTIPLEXER #############" >> $build/.bashrc
}

function buildBashrc() {
  sourceBashrc
  persistUnmanagedAdditions
  buildSymlinks
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfiles-multiplexer"
  exit 1
fi

buildBashrc $@

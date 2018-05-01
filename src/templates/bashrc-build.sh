#! /bin/bash

function persistUnmanagedAdditions() {
  # search in the backup folder's .bashrc for lines after the ############# END BASH.D INCLUDE #############
  # if any exist then add them to the bottom of the persistent bashrc
  # put a backup in the backup folder and make the restore function put it back in place if anything goes wrong
  return
}


function sourceBashrc() {
  local bash_perm_backup=".bashrc.orig_DO-NOT-DELETE"

  if [ ! -L $HOME/.bashrc ] && [ -f $HOME/.bashrc ]; then
    mv $HOME/.bashrc $HOME/$bash_perm_backup

    echo "############# INCLUDED BY THE DOTFILES MULTIPLEXER     #############" >> $HOME/$bash_perm_backup
    echo "#############   UNMANAGED ADDITIONS                    #############" >> $HOME/$bash_perm_backup
    echo "# additions made by other applications and synchronised here by dotfiles-multiplexer" >> $HOME/$bash_perm_backup
    echo "# persistent modifications to these values must be made in $HOME/$bash_perm_backup" >> $HOME/$bash_perm_backup
  fi

  if [ ! -f $HOME/$bash_perm_backup ]; then
    echo "No source .bashrc file could be found. Is it possible that you, me or some other process has renamed it?"
    exit 1
  fi

  cp $HOME/$bash_perm_backup $build/.bashrc
}

function buildSymlinks() {
  echo "#############   END UNMANAGED ADDITIONS                #############" >> $build/.bashrc
  echo "#############   BASH.D INCLUDE                         #############" >> $build/.bashrc
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
  echo "#############   END BASH.D INCLUDE                     #############" >> $build/.bashrc
  echo "############# END INCLUDED BY THE DOTFILES MULTIPLEXER #############" >> $build/.bashrc
}

function buildBashrc() {
  persistUnmanagedAdditions
  sourceBashrc
  buildSymlinks
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfiles-multiplexer"
  exit 1
fi

buildBashrc $@

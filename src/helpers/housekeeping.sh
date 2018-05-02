#! /bin/bash

function runBackout() {
  if [ -d $build_backup ]; then
    echo "BACKING OUT - RESTORING ORIGINAL BUILD DIRECTORY"
    sudo rm -r $build 2>/dev/null || true
    mv $build_backup $build
  fi
  if [ -f $build/$bashrc_persist_file_name ]; then
    mv $build/$bashrc_persist_file_name $HOME/$bashrc_persist_file_name
  fi
  runCleanup
}

function runCleanup() {
  sudo rm -r $holding 2>/dev/null || true
  sudo rm -r $build_backup 2>/dev/null || true
}

#! /bin/bash

config_ok=true

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

for conf_category in ${!config[@]}; do
  for dotfolder in ${config[$conf_category]}; do
    if [ ! -d ~/$dotfolder ]; then
      echo "WARNING: You have configured $conf_category to use a non-existant directory at ~/$dotfolder. Please check your config at ~/.dotfiles-multiplexer.conf before we ruin your home directory"
      config_ok=false
    fi
  done
done

if [ $config_ok = false ]; then
  exit 1
fi

#! /bin/bash

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

broken_links=$(sudo find /etc/profile.d/* -xtype l)
if [ $broken_links ]; then
  echo "WARNING: The following broken links exist in the /etc/profile.d/ directory. These are possibly left over from previous runs of the dotfiles-multiplexer. Please consider removing them:"
  echo $broken_links
fi

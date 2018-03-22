#!/bin/bash

# remove existing links (this should probably just move original files if they are files)
rm ~/.bashrc || true
rm ~/.bash_aliases || true
rm ~/.vimrc || true
rm ~/.tmux.conf || true

# link file system locations to dotfiles-root issuers files
ln -s ~/dotfiles-root/.bashrc ~/.bashrc
ln -s ~/dotfiles-root/.bash_aliases ~/.bash_aliases
ln -s ~/dotfiles-root/.vimrc ~/.vimrc
ln -s ~/dotfiles-root/.tmux.conf ~/.tmux.conf

# profile files should contain exported environment variables and functions
if [ -d ~/dotfiles-rullion/profile.d/ ]; then
  for profilepath in $(find ~/dotfiles-rullion/profile.d/ \( -name '*.sh' \))
  do
    profilename=$(basename "${profilepath}")
    sudo ln -sf $profilepath /etc/profile.d/$profilename
  done
fi
if [ -d ~/dotfiles-personal/profile.d/ ]; then
  for profilepath in $(find ~/dotfiles-personal/profile.d/ \( -name '*.sh' \))
  do
    profilename=$(basename "${profilepath}")
    sudo ln -sf $profilepath /etc/profile.d/$profilename
  done
fi

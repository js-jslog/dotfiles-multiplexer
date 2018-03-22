#!/bin/bash

# remove existing links (this should probably just move original files if they are files)
rm ~/.bashrc || true
rm ~/.bash_aliases || true
rm ~/.vimrc || true
rm ~/.tmux.conf || true

# link file system locations to dotfiles-root issuers files
ln -sf ~/dotfiles-root/.bashrc ~/.bashrc
ln -sf ~/dotfiles-root/.bash_aliases ~/.bash_aliases
rm -r ~/dotfiles-root/bash.d/ || true
mkdir ~/dotfiles-root/bash.d/
ln -sf ~/dotfiles-root/bash.d ~/bash.d
ln -sf ~/dotfiles-root/.vimrc ~/.vimrc
ln -sf ~/dotfiles-root/.tmux.conf ~/.tmux.conf

# bash files should contain exported environment variables and functions for interactive shells
if [ -d ~/dotfiles-rullion/bash.d/ ]; then
  for bashpath in $(find ~/dotfiles-rullion/bash.d/ \( -name '*.sh' \))
  do
    bashname=$(basename "${bashpath}")
    sudo ln -sf $bashpath ~/bash.d/rullion-$bashname
  done
fi
if [ -d ~/dotfiles-personal/bash.d/ ]; then
  for bashpath in $(find ~/dotfiles-personal/bash.d/ \( -name '*.sh' \))
  do
    bashname=$(basename "${bashpath}")
    sudo ln -sf $bashpath ~/bash.d/personal-$bashname
  done
fi

# profile files should contain exported environment variables and functions for login shells
if [ -d ~/dotfiles-rullion/profile.d/ ]; then
  for profilepath in $(find ~/dotfiles-rullion/profile.d/ \( -name '*.sh' \))
  do
    profilename=$(basename "${profilepath}")
    sudo ln -sf $profilepath /etc/profile.d/rullion-$profilename
  done
fi
if [ -d ~/dotfiles-personal/profile.d/ ]; then
  for profilepath in $(find ~/dotfiles-personal/profile.d/ \( -name '*.sh' \))
  do
    profilename=$(basename "${profilepath}")
    sudo ln -sf $profilepath /etc/profile.d/personal-$profilename
  done
fi

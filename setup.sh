#!/bin/bash

INCLUDE_ALIASES="dotfiles-personal dotfiles-rullion"
INCLUDE_VIMRC="dotfiles-personal dotfiles-rullion"
INCLUDE_GITCONFIG="dotfiles-personal dotfiles-rullion"
INCLUDE_TMUXCONF="dotfiles-personal dotfiles-rullion"

# if any original files exist then we will just move them rather than 
# delete them
# if the file is a symlink then it will have in all likelyhood been 
# provisioned by a version controlled dotfile manager so can just
# be overwritten by stage 2 below
if [[ ! -L ~/.bashrc ]]; then
  mv ~/.bashrc ~/.bashrc.original 2>/dev/null
fi
if [[ ! -L ~/.bash_aliases ]]; then
  mv ~/.bash_aliases ~/.bash_aliases.original 2>/dev/null
fi
if [[ ! -L ~/.vimrc ]]; then
  mv ~/.vimrc ~/.vimrc.original 2>/dev/null
fi
if [[ ! -L ~/.tmux.conf ]]; then
  mv ~/.tmux.conf ~/.tmux.conf.original 2>/dev/null
fi
if [[ ! -L ~/.gitconfig ]]; then
  mv ~/.gitconfig ~/.gitconfig.original 2>/dev/null
fi
if [[ ! -L ~/.ssh/config ]]; then
  mv ~/.ssh/config ~/.ssh/config.original 2>/dev/null
fi

# build the 'include' dotfiles
rm -r ~/dotfiles-multiplexer/built-dots/ 2>/dev/null
mkdir -p ~/dotfiles-multiplexer/built-dots/
touch ~/dotfiles-multiplexer/built-dots/.bash_aliases
touch ~/dotfiles-multiplexer/built-dots/.vimrc
touch ~/dotfiles-multiplexer/built-dots/.gitconfig
./build-scripts/.bash_aliases-includes.sh $INCLUDE_ALIASES
./build-scripts/.vimrc-includes.sh $INCLUDE_VIMRC
./build-scripts/.gitconfig-includes.sh $INCLUDE_GITCONFIG
./build-scripts/.tmux.conf-includes.sh $INCLUDE_TMUXCONF

# overwrite existing symbolic links if they exist
ln -sf ~/dotfiles-multiplexer/.bashrc ~/.bashrc
ln -sf ~/dotfiles-multiplexer/built-dots/.bash_aliases ~/.bash_aliases
ln -sf ~/dotfiles-multiplexer/built-dots/.vimrc ~/.vimrc
ln -sf ~/dotfiles-multiplexer/built-dots/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles-multiplexer/built-dots/.gitconfig ~/.gitconfig
# there is no composition inclusion mechanism for ssh (possibly for security)
# so we need to build the config file instead
rm -r ~/dotfiles-multiplexer/.ssh/ || true
mkdir -p ~/dotfiles-multiplexer/.ssh && touch ~/dotfiles-multiplexer/.ssh/config
# we need to provision the .ssh folder, just in case it doesn't exist yet
mkdir -p ~/.ssh
if [[ -f ~/dotfiles-personal/.ssh/config ]]; then
  cat ~/dotfiles-personal/.ssh/config >> ~/dotfiles-multiplexer/.ssh/config
fi
if [[ -f ~/dotfiles-rullion/.ssh/config ]]; then
  cat ~/dotfiles-rullion/.ssh/config >> ~/dotfiles-multiplexer/.ssh/config
fi
ln -sf ~/dotfiles-multiplexer/.ssh/config ~/.ssh/config
# overwriting sybolic links doesn't work if they are linked to directories apparently
# need to remove it
rm ~/bash.d || true
# the bash.d directory doesn't have any of it's own files, so it is excluded from the repo and
# we need to create it during runtime
rm -r ~/dotfiles-multiplexer/bash.d/ || true
mkdir ~/dotfiles-multiplexer/bash.d/
# now we can create the link
ln -s ~/dotfiles-multiplexer/bash.d ~/bash.d

# filling the bash.d folder with scripts to be run at shell initiation
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

# filling the profile.d folder with scripts to be run at login shell initiation
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

#!/bin/bash

multiplexer="$PWD/${0%/*}"

# if no dotfile-multiplex config file exists, copy the template file
if [[ ! -f ~/dotfiles-multiplexer.conf ]]; then
  cp $multiplexer/dotfiles-multiplexer.conf.template ~/dotfiles-multiplexer.conf
fi

# load in the user configured include vars
. ~/dotfiles-multiplexer.conf

# if any original files exist then we will just move them rather than 
# delete them
# if the file is a symlink then it will have in all likelyhood been 
# provisioned by a version controlled dotfile manager so can just
# be overwritten by stage 3 below
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
  # we need to provision the .ssh folder, just in case it doesn't exist yet
  mkdir -p ~/.ssh
  mv ~/.ssh/config ~/.ssh/config.original 2>/dev/null
fi
# overwriting sybolic links doesn't work if they are linked to directories apparently
# need to remove it
rm ~/bash.d 2>/dev/null

# build the 'include' dotfiles
rm -r $multiplexer/built-dots/ 2>/dev/null
mkdir -p $multiplexer/built-dots/.ssh
mkdir -p $multiplexer/built-dots/bash.d
. $multiplexer/build-scripts/.bash_aliases-includes.sh $include_aliases
. $multiplexer/build-scripts/.vimrc-includes.sh $include_vimrc
. $multiplexer/build-scripts/.gitconfig-includes.sh $include_gitconfig
. $multiplexer/build-scripts/.tmux.conf-includes.sh $include_tmuxconf
. $multiplexer/build-scripts/.ssh-config-parts.sh $include_sshconfig
. $multiplexer/build-scripts/bash.d-symlinks.sh $include_bashd
. $multiplexer/build-scripts/profile.d-symlinks.sh $include_profiled

# overwrite existing symbolic links if they exist
ln -sf $multiplexer/.bashrc ~/.bashrc
ln -sf $multiplexer/built-dots/.bash_aliases ~/.bash_aliases
ln -sf $multiplexer/built-dots/.vimrc ~/.vimrc
ln -sf $multiplexer/built-dots/.tmux.conf ~/.tmux.conf
ln -sf $multiplexer/built-dots/.gitconfig ~/.gitconfig
ln -sf $multiplexer/built-dots/.ssh/config ~/.ssh/config
ln -s $multiplexer/built-dots/bash.d ~/bash.d

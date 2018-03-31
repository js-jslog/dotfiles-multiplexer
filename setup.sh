#! /bin/bash

set -e

multiplexer="$PWD/${0%/*}"

# if no dotfile-multiplex config file exists, copy the template file
if [ ! -f $HOME/.dotfiles-multiplexer.yml ]; then
  cp $multiplexer/.dotfiles-multiplexer.yml.template $HOME/.dotfiles-multiplexer.yml
fi

# load in the config file
. $multiplexer/src/settings/yml-parser.sh
eval $(parse_yml $HOME/.dotfiles-multiplexer.yml "setup_")

# check the setup variables
. $multiplexer/src/settings/check-setup.sh

# if any original files exist then we will just move them rather than 
# delete them
# if the file is a symlink then it will have in all likelyhood been 
# provisioned by a version controlled dotfile manager so can just
# be overwritten by stage 3 below
if [ ! -L $HOME/.bashrc ]; then
  mv $HOME/.bashrc $HOME/.bashrc.original 2>/dev/null || true
fi
if [ ! -L $HOME/.bash_aliases ]; then
  mv $HOME/.bash_aliases $HOME/.bash_aliases.original 2>/dev/null || true
fi
if [ ! -L $HOME/.vimrc ]; then
  mv $HOME/.vimrc $HOME/.vimrc.original 2>/dev/null || true
fi
if [ ! -L $HOME/.tmux.conf ]; then
  mv $HOME/.tmux.conf $HOME/.tmux.conf.original 2>/dev/null || true
fi
if [ ! -L $HOME/.gitconfig ]; then
  mv $HOME/.gitconfig $HOME/.gitconfig.original 2>/dev/null || true
fi
if [ ! -L $HOME/.ssh/config ]; then
  # we need to provision the .ssh folder, just in case it doesn't exist yet
  mkdir -p $HOME/.ssh
  mv $HOME/.ssh/config $HOME/.ssh/config.original 2>/dev/null || true
fi
# overwriting sybolic links doesn't work if they are linked to directories apparently
# need to remove it
rm $HOME/bash.d 2>/dev/null || true

# build the 'include' dotfiles
rm -r $multiplexer/build/ 2>/dev/null || true
mkdir -p $multiplexer/build/.ssh
mkdir -p $multiplexer/build/bash.d
. $multiplexer/src/helpers/alias-to-location.sh
. $multiplexer/src/templates/bash_aliases-includes.sh $(aliasesToLocations $setup_dots_bashaliases)
. $multiplexer/src/templates/vimrc-includes.sh $(aliasesToLocations $setup_dots_vimrc)
. $multiplexer/src/templates/gitconfig-includes.sh $(aliasesToLocations $setup_dots_gitconfig)
. $multiplexer/src/templates/tmux.conf-includes.sh $(aliasesToLocations $setup_dots_tmuxconf)
. $multiplexer/src/templates/ssh-config-parts.sh $(aliasesToLocations $setup_dots_sshconf)
. $multiplexer/src/templates/bash.d-symlinks.sh $(aliasesToLocations $setup_dots_bashdfolder)
. $multiplexer/src/templates/profile.d-symlinks.sh $(aliasesToLocations $setup_dots_profiledfolder)

# overwrite existing symbolic links if they exist
ln -sf $multiplexer/.bashrc $HOME/.bashrc
ln -sf $multiplexer/build/.bash_aliases $HOME/.bash_aliases
ln -sf $multiplexer/build/.vimrc $HOME/.vimrc
ln -sf $multiplexer/build/.tmux.conf $HOME/.tmux.conf
ln -sf $multiplexer/build/.gitconfig $HOME/.gitconfig
ln -sf $multiplexer/build/.ssh/config $HOME/.ssh/config
ln -s $multiplexer/build/bash.d $HOME/bash.d

# do a scan of the profile.d folder for broken links (possibly from previous runs)
. $multiplexer/src/settings/check-broken-symlinks.sh

echo "Complete"

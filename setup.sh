#! /bin/bash

set -e

multiplexer="$PWD/${0%/*}"
src="$multiplexer/src"
build="$multiplexer/build"

# import dependencies
. $src/helpers/config-helper.sh
. $src/settings/yml-parser.sh

# if no dotfile-multiplex config file exists, copy the template file
if [ ! -f $HOME/.dotfiles-multiplexer.yml ]; then
  cp $multiplexer/.dotfiles-multiplexer.yml.template $HOME/.dotfiles-multiplexer.yml
fi

# load in the config file
eval $(parse_yml $HOME/.dotfiles-multiplexer.yml "setup_")

# check the setup variables
. $src/settings/check-setup.sh

# destroy the original build directory
sudo rm -r $build 2>/dev/null || true
mkdir -p $build

# check out the repo's if configured
for alias in $setup_aliases; do
  git clone $(aliasesToRepos $alias) $(aliasesToLocations $alias)
done


# if any original files exist then we will just move them rather than 
# delete them
# if the file is a symlink then it will have in all likelyhood been 
# provisioned by a version controlled dotfile manager so can just
# be overwritten by stage 3 below
if [ ! -L $HOME/.bashrc ] && [ -f $HOME/.bashrc ]; then
  echo Backing up original .bashrc to $HOME/.bashrc.original
  mv $HOME/.bashrc $HOME/.bashrc.original 2>/dev/null || true
fi
if [ ! -L $HOME/.bash_aliases ] && [ -f $HOME/.bash_aliases ]; then
  echo Backing up original .bash_aliases to $HOME/.bash_aliases.original
  mv $HOME/.bash_aliases $HOME/.bash_aliases.original 2>/dev/null || true
fi
if [ ! -L $HOME/.vimrc ] && [ -f $HOME/.vimrc ]; then
  echo Backing up original .vimrc to $HOME/.vimrc.original
  mv $HOME/.vimrc $HOME/.vimrc.original 2>/dev/null || true
fi
if [ ! -L $HOME/.tmux.conf ] && [ -f $HOME/.tmux.conf ]; then
  echo Backing up original .tmux.conf to $HOME/.tmux.conf.original
  mv $HOME/.tmux.conf $HOME/.tmux.conf.original 2>/dev/null || true
fi
if [ ! -L $HOME/.gitconfig ] && [ -f $HOME/.gitconfig ]; then
  echo Backing up original .gitconfig to $HOME/.gitconfig.original
  mv $HOME/.gitconfig $HOME/.gitconfig.original 2>/dev/null || true
fi
if [ ! -L $HOME/.ssh/config ] && [ -f $HOME/.ssh/config ]; then
  echo Backing up original .ssh/config to $HOME/.ssh/config.original
  # we need to provision the .ssh folder, just in case it doesn't exist yet
  mkdir -p $HOME/.ssh
  mv $HOME/.ssh/config $HOME/.ssh/config.original 2>/dev/null || true
fi
# overwriting sybolic links doesn't work if they are linked to directories apparently
# need to remove it
rm $HOME/bash.d 2>/dev/null || true

# build the 'include' dotfiles
mkdir -p $build/.ssh
mkdir -p $build/bash.d
. $src/templates/bash_aliases-includes.sh $(filterExcludedAliases $setup_compose_bashaliases)
. $src/templates/vimrc-includes.sh $(filterExcludedAliases $setup_compose_vimrc)
. $src/templates/gitconfig-includes.sh $(filterExcludedAliases $setup_compose_gitconfig)
. $src/templates/tmux.conf-includes.sh $(filterExcludedAliases $setup_compose_tmuxconf)
. $src/templates/ssh-config-parts.sh $(filterExcludedAliases $setup_compose_sshconf)
. $src/templates/bash.d-symlinks.sh $(filterExcludedAliases $setup_compose_bashdfolder)
. $src/templates/profile.d-symlinks.sh $(filterExcludedAliases $setup_compose_profiledfolder)

# overwrite existing symbolic links if they exist
ln -sf $multiplexer/.bashrc $HOME/.bashrc
ln -sf $build/.bash_aliases $HOME/.bash_aliases
ln -sf $build/.vimrc $HOME/.vimrc
ln -sf $build/.tmux.conf $HOME/.tmux.conf
ln -sf $build/.gitconfig $HOME/.gitconfig
ln -sf $build/.ssh/config $HOME/.ssh/config
ln -s $build/bash.d $HOME/bash.d

# do a scan of the profile.d folder for broken links (possibly from previous runs)
. $src/settings/check-broken-symlinks.sh

echo "Complete"

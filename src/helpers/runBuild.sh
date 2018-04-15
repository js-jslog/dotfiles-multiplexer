#! /bin/bash

# check out the repo's if configured
for alias in $filtered_aliases; do
  git clone $(aliasesToRepos $alias) $(aliasesToRepoHoldingLocations $alias) 2>/dev/null || true
done

# destroy the original build directory
sudo rm -r $build 2>/dev/null || true
mv $holding $build

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

# build the 'composition' dotfiles
printf "\nBEGINNING FILE COMPOSITION\n\n"

mkdir -p $build/.ssh
mkdir -p $build/bash.d
. $src/templates/bash_aliases-includes.sh $(filterExcludedAliases ${config_compose_bashaliases:-$config_aliases})
. $src/templates/vimrc-includes.sh $(filterExcludedAliases ${config_compose_vimrc:-$config_aliases})
. $src/templates/gitconfig-includes.sh $(filterExcludedAliases ${config_compose_gitconfig:-$config_aliases})
. $src/templates/tmux.conf-includes.sh $(filterExcludedAliases ${config_compose_tmuxconf:-$config_aliases})
. $src/templates/ssh-config-parts.sh $(filterExcludedAliases ${config_compose_sshconf:-$config_aliases})
. $src/templates/bash.d-symlinks.sh $(filterExcludedAliases ${config_compose_bashdfolder:-$config_aliases})
. $src/templates/profile.d-symlinks.sh $(filterExcludedAliases ${config_compose_profiledfolder:-$config_aliases})

printf "\nFILE COMPOSITION COMPLETE\n\n"

# overwrite existing symbolic links if they exist
ln -sf $multiplexer/.bashrc $HOME/.bashrc
ln -sf $build/.bash_aliases $HOME/.bash_aliases
ln -sf $build/.vimrc $HOME/.vimrc
ln -sf $build/.tmux.conf $HOME/.tmux.conf
ln -sf $build/.gitconfig $HOME/.gitconfig
ln -sf $build/.ssh/config $HOME/.ssh/config
ln -s $build/bash.d $HOME/bash.d


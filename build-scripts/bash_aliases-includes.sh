#! /bin/bash

dotfolder_names=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

# add some aliases for interacting with the dotfiles-multiplexer
echo "export dotfiles_multiplexer=$multiplexer" >> $multiplexer/built-dots/.bash_aliases
echo "alias dotsmplex=\"cd \$dotfiles_multiplexer\"" >> $multiplexer/built-dots/.bash_aliases


for dotfolder_name in $dotfolder_names; do
  # no longer checking for the presence of these files in the build process as we want the user to 
  # have the flexibility to remove the files if they want and for the .bash_aliases file to continue
  # working.
  echo "if [ -f ~/$dotfolder_name/.bash_aliases ]; then" >> $multiplexer/built-dots/.bash_aliases
  echo "  . ~/$dotfolder_name/.bash_aliases" >> $multiplexer/built-dots/.bash_aliases
  echo "fi" >> $multiplexer/built-dots/.bash_aliases
done

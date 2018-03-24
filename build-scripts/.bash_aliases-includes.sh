#! /bin/bash
DOTS_NAMES=$@
for DOTS_NAME in $DOTS_NAMES; do
  # no longer checking for the presence of these files in the build process as we want the user to 
  # have the flexibility to remove the files if they want and for the .bash_aliases file to continue
  # working.
  echo "if [ -f ~/$DOTS_NAME/.bash_aliases ]; then" >> ~/dotfiles-multiplexer/built-dots/.bash_aliases
  echo "  . ~/$DOTS_NAME/.bash_aliases" >> ~/dotfiles-multiplexer/built-dots/.bash_aliases
  echo "fi" >> ~/dotfiles-multiplexer/built-dots/.bash_aliases
done

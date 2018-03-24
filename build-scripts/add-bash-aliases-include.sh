#! /bin/bash
DOTS_NAME=$1
if [ -f ~/$DOTS_NAME/.bash_aliases ]; then
  echo ". ~/$DOTS_NAME/.bash_aliases" >> ~/dotfiles-multiplexer/built-dots/.bash_aliases
else
  echo "~/$DOTS_NAME/.bash_aliases does not exist"
  # THIS CHECK SHOULD HAPPEN BEFORE ANY WORK IS DONE
fi

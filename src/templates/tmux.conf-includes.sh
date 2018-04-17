#! /bin/bash

function composeTmuxconf() {
  local aliases=$@
  local alias

  for alias in $aliases; do
    local dotsrepo=$(aliasesToRepoLocations $alias)
    echo "if-shell \"[ -f $dotsrepo/.tmux.conf ]\" 'source $dotsrepo/.tmux.conf'" >> $build/.tmux.conf
  done

  printf "\nComposing .tmux.conf ...\n"
  if [ -f $build/.tmux.conf ]; then
    cat $build/.tmux.conf
  else
    echo "no .tmux.conf generated"
  fi
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

composeTmuxconf $@

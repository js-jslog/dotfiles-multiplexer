#! /bin/bash

function buildSymlinks() {
  local aliases=$@
  for alias in $aliases; do
    local dotsrepo=$(aliasesToLocations $alias)
    # filling the bash.d folder with scripts to be run at shell initiation
    # bash files should contain exported environment variables and functions for interactive shells
    if [ -d $dotsrepo/bash.d/ ]; then
      for bashpath in $(find $dotsrepo/bash.d/ \( -name '*.sh' \))
      do
        bashname=$(basename "${bashpath}")
        sudo ln -s $bashpath $build/bash.d/$alias-$bashname
      done
    fi
  done
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

buildSymlinks $@

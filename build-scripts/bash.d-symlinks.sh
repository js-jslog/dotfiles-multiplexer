#! /bin/bash

dotfolder_names=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

for dotfolder_name in $dotfolder_names; do
  # filling the bash.d folder with scripts to be run at shell initiation
  # bash files should contain exported environment variables and functions for interactive shells
  if [ -d ~/$dotfolder_name/bash.d/ ]; then
    for bashpath in $(find ~/$dotfolder_name/bash.d/ \( -name '*.sh' \))
    do
      bashname=$(basename "${bashpath}")
      sudo ln -s $bashpath $multiplexer/built-dots/bash.d/${dotfolder_name/-/}-$bashname
    done
  fi
done

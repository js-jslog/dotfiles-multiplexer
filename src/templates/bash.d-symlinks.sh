#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

for dotfolder_location in $dotfolder_locations; do
  # filling the bash.d folder with scripts to be run at shell initiation
  # bash files should contain exported environment variables and functions for interactive shells
  if [ -d $dotfolder_location/bash.d/ ]; then
    for bashpath in $(find $dotfolder_location/bash.d/ \( -name '*.sh' \))
    do
      reponame=$(basename ${dotfolder_location})
      bashname=$(basename "${bashpath}")
      sudo ln -s $bashpath $multiplexer/build/bash.d/$reponame-$bashname
    done
  fi
done

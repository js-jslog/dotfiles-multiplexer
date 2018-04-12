#! /bin/bash

# filling the profile.d folder with scripts to be run at login shell initiation
# profile files should contain exported environment variables and functions for login shells
function buildSymlinks() {
  local aliases=$@
  local alias
  local profilepath
  local profilename

  printf "\nBuilding profile.d symlinks from the following sources:\n"

  for alias in $aliases; do
    local dotsrepo=$(aliasesToLocations $alias)
    if [ -d $dotsrepo/profile.d/ ]; then
      for profilepath in $(find $dotsrepo/profile.d/ \( -name '*.sh' \))
      do
        profilename=$(basename "${profilepath}")
        sudo ln -s $profilepath /etc/profile.d/$alias-$profilename

        printf "  $profilepath\n"

      done
    fi
  done
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

buildSymlinks $@

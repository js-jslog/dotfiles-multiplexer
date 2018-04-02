#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

# filling the profile.d folder with scripts to be run at login shell initiation
# profile files should contain exported environment variables and functions for login shells
for dotfolder_location in $dotfolder_locations; do
  if [ -d $dotfolder_location/profile.d/ ]; then
    for profilepath in $(find $dotfolder_location/profile.d/ \( -name '*.sh' \))
    do
      reponame=$(basename ${dotfolder_location})
      profilename=$(basename "${profilepath}")
      sudo ln -s $profilepath /etc/profile.d/$reponame-$profilename
    done
  fi
done

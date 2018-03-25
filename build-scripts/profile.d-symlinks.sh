#! /bin/bash

dotfolder_names=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

# filling the profile.d folder with scripts to be run at login shell initiation
# profile files should contain exported environment variables and functions for login shells
for dotfolder_name in $dotfolder_names; do
  if [ -d ~/$dotfolder_name/profile.d/ ]; then
    for profilepath in $(find ~/$dotfolder_name/profile.d/ \( -name '*.sh' \))
    do
      profilename=$(basename "${profilepath}")
      sudo ln -s $profilepath /etc/profile.d/${dotfolder_name/-/}-$profilename
    done
  fi
done

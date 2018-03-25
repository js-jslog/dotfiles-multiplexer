#! /bin/bash

dotfolder_names=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

for dotfolder_name in $dotfolder_names; do
  # there is no composition inclusion mechanism for ssh (possibly for security)
  # so we need to build an actual file
  if [ -f ~/$dotfolder_name/.ssh/config ]; then
    echo "# originally included from $dotfolder_name" >> $multiplexer/built-dots/.ssh/config
    cat ~/$dotfolder_name/.ssh/config >> $multiplexer/built-dots/.ssh/config
    printf "# end of file\n\n" >> $multiplexer/built-dots/.ssh/config
  fi
done

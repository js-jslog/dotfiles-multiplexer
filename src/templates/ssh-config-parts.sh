#! /bin/bash

dotfolder_locations=$@

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

for dotfolder_location in $dotfolder_locations; do
  # there is no composition inclusion mechanism for ssh (possibly for security)
  # so we need to build an actual file
  if [ -f $dotfolder_location/.ssh/config ]; then
    echo "# originally included from $dotfolder_location" >> $multiplexer/build/.ssh/config
    cat $dotfolder_location/.ssh/config >> $multiplexer/build/.ssh/config
    printf "# end of file\n\n" >> $multiplexer/build/.ssh/config
  fi
done

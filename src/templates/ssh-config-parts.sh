#! /bin/bash

# there is no composition inclusion mechanism for ssh (possibly for security)
# so we need to build an actual file
function buildSshconfig() {
  local aliases=$@
  local alias
  for alias in $aliases; do
    local dotsrepo=$(aliasesToLocations $alias)
    if [ -f $dotsrepo/.ssh/config ]; then
      echo "# originally included from $dotsrepo" >> $build/.ssh/config
      cat $dotsrepo/.ssh/config >> $build/.ssh/config
      printf "# end of file\n\n" >> $build/.ssh/config
    fi
  done
}

if [ ! $multiplexer ]; then
  echo "This script should only be run by the dotfile-multiplexer"
  exit 1
fi

buildSshconfig $@

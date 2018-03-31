#! /bin/bash

config_ok=true

. $multiplexer/src/helpers/alias-to-location.sh

for alias in $setup_aliases; do
  repo_directory=$(aliasesToLocations $alias)
  if [ ! -d "$repo_directory" ]; then
    echo Repository aliased as '$alias' is configured to be located at $repo_directory. Location does not exist
    config_ok=false
  fi
done 

# can also add checks here that each of the files which are supposed to exist in the repo, do exist

if [ $config_ok = false ]; then
  exit 1
fi

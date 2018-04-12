#! /bin/bash

config_ok=true

. $multiplexer/src/helpers/config-helper.sh

for alias in $setup_aliases; do
  repo=$(aliasesToRepos $alias)
  if [ $(git ls-remote $repo -q && echo $?) ]; then
    echo checked $alias at $repo exists
  else
    echo FAILURE: $alias configured repository location $repo does not exist or is not accessible
    config_ok=false
  fi
done

# can also add checks here that each of the files which are supposed to exist in the repo, do exist

if [ $config_ok = false ]; then
  exit 1
fi

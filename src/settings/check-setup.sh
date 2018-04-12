#! /bin/bash

config_ok=true

. $src/helpers/config-helper.sh

for alias in $setup_aliases; do
  repo=$(aliasesToRepos $alias)
  if [ $(git ls-remote $repo -q && echo $?) ]; then
    printf "\nChecked $alias at $repo exists\n\n"
  else
    printf "\nFAILURE: the configured repository for $alias at \"$repo\" does not exist or is not accessible\n\n"
    config_ok=false
  fi
done

# can also add checks here that each of the files which are supposed to exist in the repo, do exist

if [ $config_ok = false ]; then
  exit 1
fi

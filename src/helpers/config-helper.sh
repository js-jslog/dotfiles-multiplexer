#! /bin/bash

function aliasesToRepos() {
  for alias in $@; do
    local repo_var=setup_${alias}_repo
    local repo=${!repo_var}
    echo $repo
  done
}

function aliasesToLocations() {
  for alias in $@; do
    echo "$multiplexer/build/repos/$alias/"
  done
}

function filterExcludedAliases() {
  local aliases=$@
  local exclude_found=false
  for alias in $aliases; do
    for exclude in $setup_exclude; do
      if [ "$alias" = "$exclude" ]; then
        exclude_found=true
      fi
    done
    if [ "$exclude_found" = "false" ]; then
      echo $alias
    fi
    exclude_found=false
  done
}

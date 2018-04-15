#! /bin/bash

function aliasesToRepos() {
  for alias in $@; do
    local repo_var=config_${alias}_repo
    local repo=${!repo_var}
    echo $repo
  done
}

function aliasesToRepoLocations() {
  for alias in $@; do
    echo "$build/repos/$alias/"
  done
}

function aliasesToRepoHoldingLocations() {
  for alias in $@; do
    echo "$holding/repos/$alias/"
  done
}

function filterExcludedAliases() {
  local aliases=$@
  local exclude_found=false
  for alias in $aliases; do
    for exclude in $config_exclude; do
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

function countParams() {
  echo $@ | wc -w
}

function countClonedRepos() {
  echo $(countParams $(ls $build/repos))
} 

#! /bin/bash

function aliasesToRepos() {
  for alias in $@; do
    local repo_var=setup_${alias}_repo
    local repo=${!repo_var}
    echo $repo
  done

function aliasesToLocations() {
  for alias in $@; do
    echo "$multiplexer/build/repos/$alias/"
  done
}

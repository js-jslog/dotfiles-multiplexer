#! /bin/bash

function checkConfig() {

  local config_ok=true

  if [ $config_dots_repo = "ENTER-THE-ADDRESS-OF-YOUR-REPOSITORY-HERE" ]; then
    echo "!!!INCOMPLETE CONFIGURATION!!!"
    echo "We have placed an example configuration file at ~/.dotfiles-multiplexer.yml"
    echo "Please add your dotfiles repository source to this file and rerun this setup"
    config_ok=false
  fi

  for alias in $filtered_aliases; do
    configured_repo_var=config_${alias}_repo
    if [ ! ${!configured_repo_var} ]; then
      echo "!!!INCOMPLETE CONFIGURATION!!!"
      echo "You have not configured a repository source for the alias $alias"
      echo "Please check your config at ~/.dotfiles-multiplexer.yml"
      config_ok=false
    fi
  done

  if [ $config_ok = false ]; then
    exit 1
  fi
}

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

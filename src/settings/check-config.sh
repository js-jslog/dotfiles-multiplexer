#! /bin/bash

config_ok=true

. $src/helpers/config-helper.sh

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

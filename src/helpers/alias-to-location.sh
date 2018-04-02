#! /bin/bash

function aliasesToLocations() {
  for alias in $@; do
    local location_var=setup_${alias}_location
    local location=${!location_var}
    echo $location
  done
}

function locationsToAliases() {
  for location in $@; do
    for alias in $setup_aliases; do
      if [ "$(aliasesToLocations $alias)" = "$location" ]; then
        echo $alias
      fi
    done
  done
}

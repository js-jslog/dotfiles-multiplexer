#! /bin/bash

function aliasesToLocations() {
  for alias in $@; do
    local location_var=setup_${alias}_location
    local location=${!location_var}
    echo $location
  done
}

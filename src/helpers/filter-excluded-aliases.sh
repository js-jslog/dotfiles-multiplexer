#! /bin/bash

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

#!/bin/bash
. src/helpers/yml-parser.sh
eval $(parse_yaml test_input.yml "config_")

echo $config_aliases
echo $config_dotsme_location
echo $config_dots_sshconf
echo $config_dots_profiledfolder

for alias in $config_aliases; do
  temp=config_${alias}_location
  echo ${!temp}
done

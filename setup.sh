#! /bin/bash

set -e

multiplexer="$PWD/${0%/*}"
src="$multiplexer/src"
build="$multiplexer/build"
holding="$multiplexer/holding"
build_backup="$multiplexer/build_backup"

# just in case some progress folders were left over from a previous failed run
sudo rm -r $holding 2>/dev/null || true
sudo rm -r $build_backup 2>/dev/null || true

# import dependencies
. $src/helpers/yml-parser.sh
. $src/helpers/config-helper.sh
. $src/helpers/run-build.sh
. $src/helpers/check-broken-symlinks.sh

# if no dotfile-multiplex config file exists, copy the template file
if [ ! -f $HOME/.dotfiles-multiplexer.yml ]; then
  cp $multiplexer/.dotfiles-multiplexer.yml.template $HOME/.dotfiles-multiplexer.yml
fi

# load in the config file
eval $(parse_yml $HOME/.dotfiles-multiplexer.yml "config_")

# create the list of aliases which we actually care about
filtered_aliases=$(filterExcludedAliases $config_aliases | tr '\n' ' ')

# check the config variables
checkConfig

# register a variable to track how many repos were available after the previous iteration
repos_cloned="0"

# backup the build folder until we have completed the required clone attempts
cp -r $build $build_backup 2>/dev/null || true

# attempt to clone repos until they are all available or we stop making progress
while [ $repos_cloned -lt $(countParams $filtered_aliases) ]; do
  runBuild
  if [ $repos_cloned = $(countClonedRepos) ]; then
    echo "!!!FAILURE!!!"
    echo "It appears that at least one of your configured repos is unaccessible"
    echo "Please check that you have access to the configured repo from your location"
    echo "-------"
    echo "Repos required: $filtered_aliases"
    echo "Repos cloned: $(ls $build/repos)"
    echo ""
    echo "REVERTING to previous config if available"
    sudo rm -r $build 2>/dev/null || true
    mv $build_backup $build 2>/dev/null || true
    exit 1
  fi
  repos_cloned=$(countClonedRepos)
  if [ $repos_cloned -lt $(countParams $filtered_aliases) ]; then
    echo "Some repos were unclonable during this pass of the config - this may be resolved with another pass"
    echo "-------"
    echo "Repos required: $filtered_aliases"
    echo "Repos cloned: $(ls $build/repos)"
  fi
done

sudo rm -r $build_backup 2>/dev/null || true

# do a scan of the profile.d folder for broken links (possibly from previous runs)
checkBrokenSymlinks

echo "Complete"

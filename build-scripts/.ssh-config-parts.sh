#! /bin/bash
dotfolder_names=$@
for dotfolder_name in $dotfolder_names; do
  # there is no composition inclusion mechanism for ssh (possibly for security)
  # so we need to build an actual file
  if [[ -f ~/$dotfolder_name/.ssh/config ]]; then
    echo "# originally included from $dotfolder_name" >> ~/dotfiles-multiplexer/built-dots/.ssh/config
    cat ~/$dotfolder_name/.ssh/config >> ~/dotfiles-multiplexer/built-dots/.ssh/config
    printf "# end of file\n\n" >> ~/dotfiles-multiplexer/built-dots/.ssh/config
  fi
done

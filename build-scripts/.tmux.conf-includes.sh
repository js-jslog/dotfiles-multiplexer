#! /bin/bash
dotfolder_names=$@
for dotfolder_name in $dotfolder_names; do
  echo "if-shell \"[ -f ~/$dotfolder_name/.tmux.conf ]\" 'source ~/$dotfolder_name/.tmux.conf'" >> ~/dotfiles-multiplexer/built-dots/.tmux.conf
done

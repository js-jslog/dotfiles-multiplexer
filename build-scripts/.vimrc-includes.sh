#! /bin/bash
dotfolder_names=$@
for dotfolder_name in $dotfolder_names; do
  echo "let \$${dotfolder_name/-/}=expand(\"~/$dotfolder_name/.vimrc\")" >> ~/dotfiles-multiplexer/built-dots/.vimrc
  echo "if filereadable(\$${dotfolder_name/-/})" >> ~/dotfiles-multiplexer/built-dots/.vimrc
  echo "  source \$${dotfolder_name/-/}" >> ~/dotfiles-multiplexer/built-dots/.vimrc
  echo "endif" >> ~/dotfiles-multiplexer/built-dots/.vimrc
done

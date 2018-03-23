let $RULLIONFILE=expand("~/dotfiles-rullion/.vimrc")
if filereadable($RULLIONFILE)
    source $RULLIONFILE
endif

let $PERSONALFILE=expand("~/dotfiles-personal/.vimrc")
if filereadable($PERSONALFILE)
    source $PERSONALFILE
endif

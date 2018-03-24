# Dotfiles-multiplexer
A dotfile multiplexer

## Usage
### minimum setup
Useable with minimum configuration with a single dotfile repository by placing that repository at `~/dotfiles` with the folder structure defined below, and checking this dotfiles-multiplexer repository out at `~/dotfiles-multiplexer`.

### Multiplexing
Multiplexing of files from multiple repos is achieved by defining a set of configuration variables at `~/dotfiles-multiplexer.conf`.

A sample of the configuration file exists in this repository at `./dotfiles-multiplexer.conf.template`.

Each variable defines a list of dotfile repos from which the multiplexed configuration files will be generated. Each entry in the variable string refers to a folder name which must be defined at `~` with the appropriate folder structure (defined below), and the order in which the folder names are defined determines which order the folders will be interrogated to build the multiplexed config file. This may be important when multiple dotfile repos define the same thing differently. Most often the later defined configuration will take precedence.

## Dotfile folder structure
Only dotfile repos with the following structure are currently compatible with the dotfiles-multiplexer.

dotfiles-folder
|
--.ssh/
 |
 --config
--bash.d
 |
 --<any script name>.sh
 --<any script name>.sh
 ...
 ...
--.bash_aliases
--.gitconfig
--.tmux.conf
--.vimrc

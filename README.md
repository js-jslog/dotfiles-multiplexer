# Dotfiles-multiplexer
A tool for combining repositories of dotfiles and shell scripts

## Motivation
The aliases, functions and application config which I *need* vary depending on my situation, while others which I *want* way be consistent across these situations.

For example, I use the following git configuration in all of my projects, whether they are personal or professional:
```
[diff]
  tool = vimdiff
[difftool]
  prompt = false
[alias]
  d = difftool

```
And because I use vim frequently, I have a very personalised .vimrc file, including the following to autoindent by 2 spaces:
```
set shiftwidth=2
set softtabstop=2
```
Things change when I am in the office. My .gitconfig needs to include a proxy setting, and my .vimrc needs to assist with a 4 space standard indentation.

One option is to maintain 2 repositories with huge duplication across the settings which are consistent between my working contexts.

The other is to have a core set of configuration which is then augmented and overridden where necessary by context specific configuration files stored in a separate repository.

Dotfiles-multiplexer helps to achieve the latter in a way which is simple and maintainable.

## Features
* **Complete isolation of original files** - no modifications are made to your cloned repositories during multiplexing
* **Single build solutions for most file types** - ie local modifications made in your config repositories will be available to their respective applications in most cases without a subsequent rerunning of the setup script
* **Basic setup in 3 steps** - clone dotfiles-multiplexer & your config repository, then run the setup.sh
* **Advanced configuration through a simple yaml file**
* **Prioritisation of overriding config** - two files containing the same config element can be prioritised so that the latter takes effect
* **Exclude repository** - allowing for quick test removal of repo, without significant config modification

## Usage
### Basic setup (ie single config repository)
It is possible to deploy a single repositoy of configuration files using the dotfiles-multiplexer in just 3 steps. See the **Dotfile folder structure** section below which details the structure of the config repository required to work with dotfiles-multiplexer.

1. `git clone git@github.com:js-jslog/dotfiles-multiplexer.git ~/dotfiles-multiplexer`
2. `git clone {your dotfiles config repository} ~/dotfiles`
3. `cd ~/dotfiles-multiplexer && ./setup.sh`

### Multiplexing
Multiplexing of files from multiple repos is achieved by defining a set of configuration variables at `~/.dotfiles-multiplexer.yml`. Once this file has been setup and the configured repositories checked out the the configured locations, the `setup.sh` script can be run from inside the dotfiles-multiplexer folder followed by `source ~/.bashrc`

A sample of the configuration file exists in this repository at `{dotfiles-multiplexer project}/.dotfiles-multiplexer.yml.template`.

```
aliases: "dotscore"
dotscore:
  location: "$HOME/dotfiles"
dots:
  sshconf: "dotscore"
  gitconfig: "dotscore"
  vimrc: "dotscore"
  tmuxconf: "dotscore"
  bashaliases: "dotscore"
  bashdfolder: "dotscore"
  profiledfolder: "dotscore"
```

The structure requires a little explanation.

#### aliases
The first entry in the config file is a list of aliases. In the template file there is just one, called dotscore. This is the nickname of the one dotfiles config repository which the file is configured to use. Multiple aliases can be added to this list, separated by whitespace.

#### location
For each of the aliases defined in the previous section, we now define the absolute path in the file system that the repository which that aliase refers to. The syntax for this is:
```
{aliasname}:
  location: {absolute path}
```
NOTE: use `$HOME` rather than ~ to denote the users home directory

#### dots
This section defines the configuration files which will be generated and the order in which the base config files will be loaded during this generation. The order is important in cases where config files share specific config elements with different values. The latter defined file will take priority for that element.

As you can see from the example, we use the repository alias for each of the configuration file types under the `dots:` node.

#### exclude
An `exclude:` node can be included where again, the alias of the repositoy you want to exclude can be placed. Similarly to the aliases definition at the top of the file, this can be a list and must be separated by whitespace.


## Dotfile folder structure
Only dotfile repos with the following structure are currently compatible with the dotfiles-multiplexer.

* dotfiles-folder
  * .ssh/
    * config
  * bash.d
    * {any script name}.sh
    * {any script name}.sh
    * ...
    * ...
  * .bash_aliases
  * .gitconfig
  * .tmux.conf
  * .vimrc

# Limitations
* Currently the `setup.sh` script must be run from inside the dotfiles-multiplexer folder. Some other locations work, but unreliably.
* You can name the dotfiles-multiplexer folder anything you like in theory, but no significant testing has been carried out under this situation
* You can locate the contributory repositories anywhere you like, but problems may arrise if you give them the same name on different paths to each other

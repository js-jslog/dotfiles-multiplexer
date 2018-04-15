# Dotfiles-multiplexer
A tool for combining repositories of dotfiles and shell scripts

## Motivation
The aliases, functions and application config which I *need* vary depending on my situation, while others which I *want* may be consistent across these situations.

For example, I use the following git configuration in all of my projects, whether they are personal or professional:
```
[diff]
  tool = vimdiff
[difftool]
  prompt = false
[alias]
  d = difftool
[push]
  default = simple

```
And because I use vim frequently, I have a very personalised .vimrc file, including the following to autoindent by 2 spaces:
```
set shiftwidth=2
set softtabstop=2
```
Things change when I am in the office. My .gitconfig needs to include a proxy setting, and my .vimrc needs to assist with a 4 space standard indentation.

One option is to maintain 2 repositories with huge duplication where config is consistent between my working contexts.

The other is to have a core set of configuration which is then augmented and overridden where necessary by context specific configuration files stored in a separate repository.

Dotfiles-multiplexer helps to achieve the latter in a way which is simple and maintainable.

## Features
* **Complete isolation of original files** - no modifications are made to your cloned repositories during multiplexing
* **Single build solutions for most file types** - ie local modifications made in your config repositories will be available to their respective applications in most cases without a subsequent rerunning of the setup script
* **Basic setup in 3 steps** - clone dotfiles-multiplexer and compose a simple config file, then run setup
* **Advanced configuration through a simple yaml file**
* **Prioritisation of overriding config** - two files containing the same config element can be prioritised so that the latter takes effect
* **Exclude repository** - allowing for quick test removal of repo, without significant config modification
* **Helper tools included** - a library of aliases and functions are included to help you interact efficiently with dotfiles-multiplexer

## Usage
### Basic setup (ie single config repository)
It is possible to deploy a single repositoy of configuration files using the dotfiles-multiplexer in just 3 steps. See the **Dotfile folder structure** section below which details the structure of the config repository required to work with dotfiles-multiplexer.

1. `git clone git@github.com:js-jslog/dotfiles-multiplexer.git ~/dotfiles-multiplexer`
2. `cp ~/dotfiles-multiplexer/.dotfiles-multiplexer.yml.template ~/.dotfiles-multiplexer.yml`
3. Modify the text string at dots > repo to be the source of your personal dotfiles repository
4. `cd ~/dotfiles-multiplexer && ./setup.sh`

### Multiplexing
Multiplexing of files from multiple repos is achieved by defining a set of configuration variables at `~/.dotfiles-multiplexer.yml`. Once this file has been setup and the configured repositories checked out the the configured locations, the `setup.sh` script can be run from inside the dotfiles-multiplexer folder followed by `source ~/.bashrc`

A sample of the configuration file exists in this repository at `{dotfiles-multiplexer project}/.dotfiles-multiplexer.yml.template`.

```
aliases: "dots dotsother"
dots:
  repo: "{the ssh source of your repository"
dotsother:
  repo: "{the ssh source of your other repository"
compose:
  gitconfig: dotsother dots
exclude: "dotsother"
```

The structure requires a little explanation.

#### aliases
The first entry in the config file is a list of aliases. In the example above there are two but you can have any number greater than 0. Each is identified by an 'alias' which is just a shorthand reference to that dotfiles repository. 

#### repo
For each of the aliases defined in the previous section, we specify the source of the repository to be cloned. The syntax is as follows:
```
{aliasname}:
  repo: {ssh source}
```

#### compose (optional)
This section defines which order the source repositories will be referenced when generating the componsed files. By default the order in which the aliases are defined will be used, but if there is one file which you would like to compose in a different order, simply define that in this section.

In the example above, the dotsother repository will have it's .gitconfig file added to the composition before the dots repo. 

You can also exclude a particular repository from a particular file composition by leaving it out of the definition here. If you want to exclude a repository all together it is better to remove it from the aliases and repo sections, or to make use of the `exclude` section described next.

The following keys are used to reference the various composed files:

* bashaliases (for .bash_aliases)
* vimrc (for .vimrc)
* gitconfig (for .gitconfig)
* tmuxconf (for .tmux.conf)
* sshconf (for ssh/conf)
* bashdfolder (for bash.d/)
* profiledfolder (for profile.d/)

#### exclude (optional)
An `exclude:` node can be added to temporarily overlook the configuration of a repo included in the config file. This can be useful for debugging.


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
  * profile.d
    * {any script name}.sh
    * ...
  * .bash_aliases
  * .gitconfig
  * .tmux.conf
  * .vimrc

# Limitations
* Currently the `setup.sh` script must be run from inside the dotfiles-multiplexer folder. Some other locations work, but unreliably.
* You can name the dotfiles-multiplexer folder anything you like in theory, but no significant testing has been carried out in this situation

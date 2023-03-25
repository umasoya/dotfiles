# dotfiles

## Dependence

- GNU-stow

## deploy dotfiles

```
./deploy.sh
```

**When deploying for the first time**

Symbolic links for '.gitignore' are not created due to the 'stow' specification.
To avoid this, you need to deploy '.stow-global-ignore' to your home directory first.
In conclusion, you need to run the deploy.sh twice.

## removal dotfiles

```
./removal.sh
```

### MacOS

On MacOS, run this to install various thing after installing **homebrew**.

```
cd brew
brew bundle
```

## Configuration files included

- zsh
    - afx
- neovim
    - dein.vim
- tmux
- iterm2
- brew

## Directory structure

`tree -aL 3 -I \.DS_Store -I \.git -I \.netrwhist && date "+%Y/%m/%d %H:%M:%S"`

```
.
├── .gitconfig
├── .gitignore
├── README.md
├── bash
│   ├── .bash_profile
│   └── .bashrc
├── brew
│   ├── Brewfile
│   └── README.md
├── code
│   ├── keybindings.json
│   └── settings.json
├── config
│   └── .config
│       ├── afx
│       ├── cheat
│       ├── dlv
│       ├── hub
│       ├── iterm2
│       ├── karabiner
│       ├── multitail
│       ├── mume
│       ├── nvim
│       └── sh
├── deploy.sh
├── etc
│   ├── launchd
│   │   ├── umasoya.brew.upgrade.daily.plist
│   │   └── umasoya.gitomatic.daily.plist
│   └── scripts
│       └── brew_upgrade.sh
├── git
│   ├── .gitconfig
│   └── .gitignore
├── iterm2
│   ├── KeyBindings.itermkeymap
│   └── SolarizedDark.json
├── misc
│   ├── .curlrc
│   ├── .dircolors
│   └── .eslintrc.yml
├── multipass
│   └── init.yml
├── mysql
│   ├── .my.cnf
│   └── .myclirc
├── pt
│   └── .ptconfig.toml
├── removal.sh
├── tmux
│   ├── .tmux
│   │   ├── _init.tmux
│   │   ├── _keybind.tmux
│   │   ├── _pane.tmux
│   │   ├── _status.tmux
│   │   ├── _tpm.tmux
│   │   ├── _variables.tmux
│   │   └── plugins
│   └── .tmux.conf
├── vim
│   ├── .vim
│   │   ├── Makefile
│   │   ├── dein.vim
│   │   ├── doc
│   │   ├── filetype.vim
│   │   ├── ftplugin
│   │   ├── rc
│   │   ├── swap
│   │   ├── syntax
│   │   ├── template
│   │   ├── tmp
│   │   ├── toml
│   │   └── undo
│   └── .vimrc
└── zsh
    ├── .zshenv
    └── .zshrc

40 directories, 38 files
2023/01/06 15:05:03
```

# dotfiles

## install

Run this:

```
git clone git@github.com:umasoya/dotfiles.git
cd dotfiles
make install
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

## bugs

### deploy script
A symlink to the **.config/** will created.
Thus, unnecessary files may also be included in the repository.
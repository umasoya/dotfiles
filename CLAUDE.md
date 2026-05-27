# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Dotfiles managed with GNU stow. Running `./deploy.sh` creates symlinks from this repo into `$HOME`.

## Stow Targets

Only these directories are deployed via stow:

```
config  git  misc  mysql  pt  tmux  vim  zsh
```

`bash/`, `code/`, `brew/`, `iterm2/` are **not** stow targets — managed separately.

## Applying Changes

Edits are live via symlinks. No redeploy needed, but:

- **zsh config changes** → `source ~/.zshrc`
- **AFX plugin YAML changes** (`config/.config/afx/`) → `afx install`
- **tmux config changes** → `prefix + R` to reload
- **vim/neovim config changes** → `:source %` or restart

## Shell Config Load Order

Files under `config/.config/sh/zsh/` load in numeric prefix order (`01_`, `20_`, `30_`, etc.). New files must follow this naming convention.

## Adding New Config Dirs Under config/.config/

`config/.config/*` is gitignored by default. To track a new app config, add an exception to `.gitignore`:

```
!config/.config/<app-name>
```

Currently tracked: `afx`, `nvim`, `multitail`, `sh`, `cheat`, `karabiner`

## Platform Conditionals

Shell configs use `IS_MAC`, `IS_LINUX`, and `DIST` variables for platform-specific logic. Maintain these conditionals when editing `.env` or shell configs.

## Git

- `.gitconfig.local` is gitignored — contains local SSH signing config (1Password). Do not create or modify it.
- First-time deployment requires running `./deploy.sh` twice (see README for the stow-global-ignore reason).

---
name: apply-changes
description: After editing dotfiles, tell the user exactly what commands to run to activate the changes in their live shell/environment.
---

Look at what files were recently edited in this session, then tell the user what to run to activate the changes. Map file paths to commands:

- Any file under `config/.config/sh/` or `zsh/` → `source ~/.zshrc`
- Any file under `config/.config/afx/` → `afx install`
- `.tmux.conf` or any file under `tmux/` → `tmux source ~/.tmux.conf` (or `prefix + R` if inside tmux)
- Any file under `vim/` or `config/.config/nvim/` → restart nvim, or `:source %` for the edited file
- Any file under `git/` → changes are live immediately (git reads config on every command)
- `deploy.sh` itself, or adding a new stow target → run `./deploy.sh` to restow

List only the commands relevant to what was changed. If nothing requires a reload (e.g., only git config was changed), say so explicitly.

# Repository guidance

Personal dotfiles for Apple Silicon macOS and Ubuntu on WSL2.
Read README.md for the current setup.

## Current layout

- init.sh: clone/bootstrap entry point. deploy.sh: conflict-checked symlink deployment.
  init.sh installs Nix/shared CLI tools and, on Mac, Homebrew/apps via sh/setup-tools.sh.
  deploy.sh only deploys settings; GNU Stow is not used.
- Shell entry points: .bash_profile, .bashrc, .zprofile, .zshenv, .zshrc.
- sh/: shared environment, Homebrew initialization, and dircolors.
- flake.nix, flake.lock, nix/: shared CLI tools and pinned dependencies.
- brew/Brewfile: Mac GUI applications only.
- git/: shared Git settings; git/.gitconfig.local is machine-specific.
- config/: Herdr, Ghostty, Karabiner. vim/: retained Vim settings.
- agents/AGENTS.md: shared Codex and Claude Code user instructions.
- tmux/: retained reference until Herdr migration is verified; not deployed.

## Issue #15 migration

- Manage common CLI tools with Nix and Mac applications with Homebrew.
- Manage enhancd, fast-syntax-highlighting, and Pure with Nix; load them in .zshrc.
- Support Codex and Claude Code, Ghostty on Mac, Windows Terminal on Windows,
  and Herdr for agent terminal sessions.
- Keep Karabiner and Vim. VS Code uses Settings Sync. Preserve tmux until the
  user confirms the Herdr migration is complete.

## Editing and validation

- Keep shell initialization compatible with macOS and Ubuntu on WSL2.
- Guard optional tools so shells work before those tools are installed.
- Do not run init.sh or deploy.sh against the real home to validate edits.
  Use an isolated temporary home and mocked external commands for deployment checks.
- Check changed Bash files with bash -n, shellcheck --shell=bash, and
  shfmt -d -i 4 -ci. Check each changed Zsh file separately with zsh -n.
- .githooks/pre-commit checks staged shell files. Do not stage files just to test.
- Run python3 -m unittest discover -s tests -v for deployment changes.
- Run nix flake check --no-build --all-systems for Nix changes.
- Update README.md when changing setup steps or symlink destinations.
- Do not modify git/.gitconfig.local or track credentials, authentication state,
  session histories, or machine-specific configuration.

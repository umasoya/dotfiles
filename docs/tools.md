# ツールの更新

## 共通CLIの更新

依存バージョンを更新するときは、差分を確認して`flake.lock`もコミット対象に含めます。

```sh
cd "$HOME/dotfiles"
nix flake update
nix flake check --no-build --all-systems
nix profile upgrade \
  --profile "${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/dotfiles" \
  --all
```

## Macアプリの更新

アプリを明示的に更新する場合は、次を実行します。

```sh
brew bundle --file="$HOME/dotfiles/brew/Brewfile"
```

[READMEへ戻る](../README.md)

# macOSアプリ

共通CLIはNixで管理します。このBrewfileはMacアプリ専用です。
`init.sh`がHomebrew本体と不足アプリを導入します。手動で不足分を導入する場合:

```sh
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle --file="$HOME/dotfiles/brew/Brewfile" --no-upgrade
```

`brew bundle dump`でCLIや個人用アプリを混ぜないでください。

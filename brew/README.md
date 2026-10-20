# macOSアプリ

共通CLIはNixで管理します。このBrewfileはMacアプリ専用です。

```sh
brew bundle --file="$HOME/dotfiles/brew/Brewfile"
```

`brew bundle dump`でCLIや個人用アプリを混ぜないでください。

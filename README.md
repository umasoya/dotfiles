# dotfiles

Bash/Zsh、Git、Homebrew、afxなどの個人用設定を管理するdotfilesリポジトリです。

## Setup

以下のコマンドで `init.sh` を実行します。

```sh
curl https://raw.githubusercontent.com/umasoya/dotfiles/refs/heads/main/init.sh | bash
```

`init.sh` は次の処理を行います。

- OSを判定（macOS / Linux）
- macOSでHomebrewが未導入の場合はインストール
- このリポジトリを `~/dotfiles` にclone
- リポジトリで管理しているGit hookを有効化
- afxが未導入の場合は `~/bin/afx` にインストール
- シェル設定やGit設定などのシンボリックリンクを作成

既に `~/dotfiles` にcloneされている場合、リポジトリの再取得や更新は行いません。

## Post-installation

GitHubへの接続にSSHを使用する場合は、リモートURLを変更します。

```sh
git -C "$HOME/dotfiles" remote set-url origin git@github.com:umasoya/dotfiles.git
```

afxで管理しているツールとZshプラグインをインストールします。

```sh
"$HOME/bin/afx" install
```

設定を現在のシェルへ反映するには、ログインシェルを起動し直します。

```sh
exec "$SHELL" -l
```

## Symlinks

`init.sh` は次の設定を配置します。

| リポジトリ内 | 配置先 |
| --- | --- |
| `.bash_profile` | `~/.bash_profile` |
| `.bashrc` | `~/.bashrc` |
| `.zprofile` | `~/.zprofile` |
| `.zshenv` | `~/.zshenv` |
| `.zshrc` | `~/.zshrc` |
| `git/.gitconfig` | `~/.gitconfig` |
| `git/.gitignore` | `~/.gitignore` |
| `afx` | `~/.config/afx` |
| `config/iterm2` | `~/.config/iterm2` |
| `config/karabiner` | `~/.config/karabiner` |

## Homebrew packages

macOSでBrewfileに定義したパッケージを導入する場合は、次を実行します。

```sh
brew bundle --file="$HOME/dotfiles/brew/Brewfile"
```

## Git hooks

`init.sh`は`core.hooksPath`に`.githooks`を設定し、コミット前の検査を有効にします。
pre-commit hookでは、変更対象のシェルファイルに対して次の検査を行います。

- Bashの構文検査
- ShellCheckによる静的解析
- shfmtによるフォーマット検査
- Zshの構文検査

ShellCheckとshfmtはBrewfileに含まれています。macOSで個別に導入する場合は、次のコマンドを実行します。

```sh
brew install shellcheck shfmt
```

Ubuntuでは、APTで導入します。

```sh
sudo apt update
sudo apt install shellcheck shfmt
```

パッケージが見つからない場合は、`universe`リポジトリを有効にしてから導入します。

```sh
sudo add-apt-repository universe
sudo apt update
sudo apt install shellcheck shfmt
```

既にclone済みで`init.sh`を再実行しない場合は、次のコマンドでhookを有効にできます。

```sh
git config core.hooksPath .githooks
```

## Main configuration

- Bash / Zsh
  - 共通環境変数: `sh/env`
  - Homebrew環境: `sh/brew.sh`
  - dircolors: `sh/dircolors.sh`、`sh/.dircolors`
- afx
  - CLIツール、GitHub CLI拡張、Zshプラグイン
  - Pure prompt、fzf、direnv、nvmなどのシェル連携
- Git
- Homebrew
- Neovim / Vim
- tmux
- iTerm2
- Karabiner-Elements
- Visual Studio Code

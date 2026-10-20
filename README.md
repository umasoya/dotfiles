# dotfiles

Apple Silicon macOSとUbuntu on WSL2で共有する開発環境です。
共通CLIはNix、MacアプリはHomebrew、設定の配置は`deploy.sh`で管理します。

## 構成

| 場所 | 管理対象 |
| --- | --- |
| `flake.nix` / `flake.lock` / `nix/packages.nix` | CLIと固定した依存バージョン |
| `.bash*` / `.zsh*` / `sh/` | シェルと共通環境変数 |
| `git/` | 共通Git設定とローカル設定の参照 |
| `vim/` | Vim設定 |
| `config/karabiner/` | Macのキー設定 |
| `config/ghostty/` | Macの端末設定 |
| `config/herdr/` | Herdr設定 |
| `agents/AGENTS.md` | Codex・Claude Codeの共通ユーザー指示 |
| `agents/skills/` | Codexの共有スキル |
| `AGENTS.md` / `CLAUDE.md` | このリポジトリで作業するエージェントへの指示 |
| `afx/` | 段階的な移行のため残すZshプラグイン・gh拡張 |
| `tmux/` | Herdrへの移行が完了するまで保管する旧設定 |

VS Codeは[Settings Sync](https://code.visualstudio.com/docs/configure/settings-sync)に任せます。
ユーザー設定・キーバインドなどが対象ですが、マシン固有設定とWSLなどのリモート拡張機能は同期対象外です。
旧iTerm2・Neovim・pt設定、フォント、補助スクリプトは管理対象から外しました。過去の内容はGit履歴から参照できます。

## セットアップ

GitとBashが使える状態で、リポジトリを取得します。WSLではUbuntu側のホームに置きます。

```sh
git clone https://github.com/umasoya/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
bash deploy.sh --dry-run
bash deploy.sh
```

`deploy.sh`はソフトウェアをインストールしません。配置先に別のファイル・ディレクトリ・リンクがあれば、
一覧を表示して変更前に停止します。既存設定を確認し、必要なものを自分のバックアップ先へ移動してから再実行してください。
同じリンクの再配置はスキップします。`--force`で上書きする機能はありません。
`init.sh`はリポジトリ取得と`deploy.sh`呼び出し用の入口として残しています。

### 共通CLI

[Nix公式の導入手順](https://nix.dev/install-nix)に従ってNixを導入し、シェルを起動し直します。
既存のNix設定に次の項目を追加して、`nix-command`と`flakes`を有効化してください。
既存の設定ファイル全体を置き換える必要はありません。

```ini
experimental-features = nix-command flakes
```

CLI一覧は`nix/packages.nix`にあります。Git、Vim、検索・補完ツール、Dockerクライアント、
Codex、Claude Code、Herdrなどをまとめた専用プロファイルを導入します。
Claude Codeに限り、Nix評価時に非自由ライセンスのパッケージを許可しています。

```sh
mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles"
nix profile install \
  --profile "${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/dotfiles" \
  "$HOME/dotfiles#default"
exec "$SHELL" -l
```

専用プロファイルの`bin`は共通シェル設定でPATHに追加します。
一時的に使う場合は`nix develop "$HOME/dotfiles"`でも起動できます。
プログラミング言語のランタイムやプロジェクトごとの依存は、それぞれの開発環境で管理します。

依存バージョンを更新するときは、差分を確認して`flake.lock`もコミット対象に含めます。

```sh
cd "$HOME/dotfiles"
nix flake update
nix flake check --no-build --all-systems
nix profile upgrade \
  --profile "${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/dotfiles" \
  --all
```

### Macアプリ

[Homebrew](https://brew.sh/)を導入したMacで実行します。

```sh
brew bundle --file="$HOME/dotfiles/brew/Brewfile"
```

対象はGhostty、Karabiner-Elements、Docker Desktopです。
アプリの初回起動・必要なOS権限の設定は各Macで行います。
Ghosttyの`~/Library/Application Support/com.mitchellh.ghostty/`に既存設定がある場合は、
XDG側の設定より後に読み込まれるため、競合する項目を確認してください。

### Windows / WSL2

Windows TerminalはWindows側で導入し、Ubuntuプロファイルからシェルを起動します。
Nix・CLI・Herdr・エージェントはUbuntu側で使います。Windows Terminalの設定ファイル全体は上書きしません。

Docker DesktopをWindows側で使う場合は、UbuntuへのWSL連携を有効にしてください。
NixのDockerパッケージはクライアントだけで、Dockerデーモンや仮想マシンを起動しません。
接続先の確認には`docker context ls`と`docker info`を使います。

## 配置する設定

| 元ファイル | 配置先 | 対象 |
| --- | --- | --- |
| `.bash_profile` / `.bashrc` / `.zprofile` / `.zshenv` / `.zshrc` | `~/`の同名ファイル | 共通 |
| `git/.gitconfig` / `git/.gitignore` | `~/.gitconfig` / `~/.gitignore` | 共通 |
| `vim/.vimrc` / `vim/.vim` | `~/.vimrc` / `~/.vim` | 共通 |
| `afx/` | `$XDG_CONFIG_HOME/afx` | 共通 |
| `config/herdr/config.toml` | `$XDG_CONFIG_HOME/herdr/config.toml` | 共通 |
| `agents/AGENTS.md` | `$CODEX_HOME/AGENTS.md`、`~/.claude/CLAUDE.md` | 共通 |
| `agents/skills/github-pr-create/` | `$CODEX_HOME/skills/github-pr-create` | 共通 |
| `config/karabiner/karabiner.json` / `assets` | `$XDG_CONFIG_HOME/karabiner/`内 | Mac |
| `config/ghostty/` | `$XDG_CONFIG_HOME/ghostty` | Mac |

`XDG_CONFIG_HOME`の既定値は`~/.config`、`CODEX_HOME`は`~/.codex`です。
標準配置先は`~/dotfiles`です。別の場所へcloneした場合は、シェル起動前の環境で`DOT_DIR`を設定してください。
Karabinerの自動バックアップやエージェントの認証・履歴ディレクトリ全体はリンクしません。

## エージェントとローカル設定

Codex・Claude Codeは初回起動時にそれぞれログインします。
共有するのはCLIバージョンと`agents/AGENTS.md`のユーザー指示です。
Codexの共有スキルは`agents/skills/`で管理し、スキルごとにリンクします。
`github-pr-create`は`$github-pr-create 今の変更からPRを作成して`で呼び出せます。
既存の同名スキルがある場合は、内容を確認してバックアップ先へ移動してから`deploy.sh`を実行してください。
`$CODEX_HOME/skills`全体は置き換えず、他のスキルはそのまま残します。
モデル、MCP、権限、仕事用の設定は既存の`~/.codex/config.toml`や`~/.claude/settings.json`で管理します。
既存の認証情報・権限設定をセットアップスクリプトが変更することはありません。

[Codexの指示ファイル](https://developers.openai.com/codex/guides/agents-md/)と
[Claude Codeのメモリ設定](https://code.claude.com/docs/en/memory)の仕様に従い、
このリポジトリの作業指示は`AGENTS.md`に集約し、`CLAUDE.md`から参照します。

- Gitのマシン固有設定: `git/.gitconfig.local`（追跡対象外）
- 対話シェルの追加設定: `~/.bashrc.local`、`~/.zshrc.local`
- Ghosttyの追加設定: `config/ghostty/local.config`（追跡対象外）

仕事用の設定は、共有できる部分だけを後から取り込んでください。

## Herdrと移行中の設定

`herdr`で起動します。旧tmuxから`Ctrl+t`のprefixと`h/j/k/l`のペイン移動を引き継いだ初期設定です。
分割などの操作は`Ctrl+t`の後に`?`で確認できます。
[設定仕様](https://herdr.dev/docs/configuration/)に従い、変更後は`herdr server reload-config`で再読み込みします。

`tmux/`は比較用に残しており、新セットアップでは配置しません。
既存のtmuxインストールやホーム内のリンクも自動では削除しません。
Herdrの分割・コピー・ペイン移動を両環境で確認してから、tmux設定の削除を判断します。

afxのCLI定義はNixへ移しました。Zshプラグインとgh拡張の定義は移行期間中残しています。
afxが既にある環境では`afx install`で導入でき、Zsh起動時に読み込みます。
新環境ではafxは必須ではありません。afxやHomebrewの既存CLIを自動アンインストールする処理はありません。

Vimは既存のdein設定を維持しています。初回起動でプラグインを取得するためネットワーク接続が必要です。

## 検証とGit hook

`deploy.sh`は`core.hooksPath=.githooks`を設定します。
pre-commitは変更対象のシェルファイルを1つずつ構文検査し、BashにはShellCheckとshfmtも実行します。
検査ツールは共通Nixプロファイルに含めています。

```sh
python3 -m unittest discover -s tests -v
nix flake check --no-build --all-systems
```

配置テストは一時ホームと模擬コマンドを使い、実際のホーム設定を変更しません。

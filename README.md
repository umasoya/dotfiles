# dotfiles

Apple Silicon macOSとUbuntu on WSL2で共有する開発環境です。
共通CLIはNix、MacアプリはHomebrew、設定の配置は`deploy.sh`で管理します。

## 構成

| 場所 | 管理対象 |
| --- | --- |
| `flake.nix` / `flake.lock` / `nix/packages.nix` | CLIと固定した依存バージョン |
| `init.sh` / `sh/setup-tools.sh` / `deploy.sh` | 初回セットアップ・ツール導入・設定配置 |
| `.bash*` / `.zsh*` / `sh/` | シェルと共通環境変数 |
| `git/` | 共通Git設定とローカル設定の参照 |
| `config/nvim/` | Neovim設定 |
| `config/karabiner/` | Macのキー設定 |
| `config/ghostty/` | Macの端末設定 |
| `config/herdr/` | Herdr設定 |
| `agents/AGENTS.md` | Codex・Claude Codeの共通ユーザー指示 |
| `agents/skills/` | Codexの共有スキル |
| `agents/mcp/` | APMによるCodex・Claude Codeの共通MCP管理 |
| `AGENTS.md` / `CLAUDE.md` | このリポジトリで作業するエージェントへの指示 |
| [docs/deployment.md](docs/deployment.md) | 設定の配置先一覧 |
| [docs/agents.md](docs/agents.md) | エージェント・MCP・ローカル設定 |
| [docs/herdr.md](docs/herdr.md) | Herdrの操作とGit worktree |
| [docs/shell.md](docs/shell.md) | シェルプラグインの設定・移行 |
| [docs/neovim.md](docs/neovim.md) | Neovim・Vimの導入、言語支援、操作 |
| [docs/tools.md](docs/tools.md) | Nix・Macアプリの更新 |
| [docs/validation.md](docs/validation.md) | 検証手順とGit hook |

VS Codeは[Settings Sync](https://code.visualstudio.com/docs/configure/settings-sync)に任せます。
ユーザー設定・キーバインドなどが対象ですが、マシン固有設定とWSLなどのリモート拡張機能は同期対象外です。
旧iTerm2・pt設定、フォント、補助スクリプトは管理対象から外しました。過去の内容はGit履歴から参照できます。

## セットアップ

Git・curl・Bashが使える状態で、GitHubのraw URLから実行します。
WSLではUbuntu側で実行してください。

```sh
curl -fsSL https://raw.githubusercontent.com/umasoya/dotfiles/main/init.sh | bash
```

`init.sh`は`~/dotfiles`へcloneし、次の順序でセットアップします。

1. `deploy.sh --dry-run`で配置先の競合を確認
2. 未導入なら公式インストーラーでNixを導入し、共通CLIの専用プロファイルを作成
3. Macでは未導入ならHomebrewを導入し、Brewfileの不足アプリを導入
4. `deploy.sh`で設定を配置

Nix・Homebrew本体の導入時は端末からの入力と管理者権限が必要になるため、対話端末から実行してください。
公式インストーラーは一時ファイルへダウンロードして実行し、終了時に一時ファイルを削除します。
Nixの新規導入にはmulti-user方式を使います。WSL2ではsystemdを有効にしたUbuntuを使用してください。
Git・curlは事前に用意します（MacではCommand Line Toolsも必要です）。

既存のcheckoutがあればその内容を使い、自動pullやブランチ変更はしません。
Nixの既存専用プロファイルは検証して再利用し、自動更新しません。
`flake.lock`も更新せず、Macアプリは`brew bundle --no-upgrade`で不足分のみ導入します。
途中で失敗した場合は原因を解消して同じコマンドを再実行できます。既存設定は自動上書きしません。
完了後は新しいログインシェルを開いてください。
作業ブランチを試す場合はraw URLの`main`とclone対象の`DOTFILES_REF`を揃えます。

```sh
curl -fsSL https://raw.githubusercontent.com/umasoya/dotfiles/chore/nix-agent-environment/init.sh \
  | DOTFILES_REF=chore/nix-agent-environment bash
```

上のURLは変更をGitHubへpushした後に利用できます。`main`のURLはマージ後に利用してください。
パイプで渡されたスクリプトから取得元URLは分からないため、URLだけを変更してもclone対象は`main`のままです。

`DOTFILES_REF`を指定せずに実行して`Missing deploy.sh`で停止した場合は、既に作成されたcheckoutを切り替えます。
`DOTFILES_REF`を付けて再実行するだけでは、既存checkoutのブランチは変わりません。
作業中の変更がある場合は内容を確認して保存してから、次を実行してください。

```sh
git -C "$HOME/dotfiles" fetch origin chore/nix-agent-environment
git -C "$HOME/dotfiles" switch chore/nix-agent-environment
bash "$HOME/dotfiles/init.sh"
```

`DOT_DIR`を指定するとclone先を変更できます。
配置内容を先に確認したい場合は、次のように手動で取得します。

```sh
git clone https://github.com/umasoya/dotfiles.git "$HOME/dotfiles"
cd "$HOME/dotfiles"
bash deploy.sh --dry-run
bash init.sh
```

`bash init.sh --dry-run`は競合確認だけを行い、本体・パッケージの導入と設定配置はしません。
raw URLから`bash -s -- --dry-run`へ渡す場合も同様ですが、未取得のリポジトリはcloneします。
設定配置だけを行う場合は`bash deploy.sh`を使います。
配置先は[設定の配置](docs/deployment.md)、エージェントのログイン・MCP登録は[エージェントとローカル設定](docs/agents.md)を参照してください。

`deploy.sh`はソフトウェアをインストールしません。配置先に別のファイル・ディレクトリ・リンクがあれば、
一覧を表示して変更前に停止します。ただし、`~/.bashrc`が`/etc/skel/.bashrc`と完全に一致する通常ファイルなら、
未変更の標準設定としてバックアップせずdotfilesのリンクへ置き換えます。`--dry-run`では置き換え予定だけを表示します。
編集済みの`.bashrc`や別のリンクは保護します。競合した既存設定を確認し、必要なものを自分のバックアップ先へ移動してから再実行してください。
同じ実体を参照する配置先は、相対リンク・絶対リンク・親ディレクトリのリンク経由の違いに関係なく再配置をスキップします。
旧セットアップのKarabinerディレクトリリンクもそのまま使えます。
`--force`で上書きする機能はありません。
`sh/setup-tools.sh`は`init.sh`から呼ばれるツール導入処理です。

### 共通CLI

[Nix公式の導入手順](https://nix.dev/install-nix)を使う本体導入と、共通CLIの導入は`init.sh`が行います。
以下は手動導入・更新用の手順です。
`init.sh`は実行時のオプションで`nix-command`と`flakes`を有効にし、既存のNix設定を書き換えません。
下記のNixコマンドをそのまま使う場合は、既存のNix設定に次の項目を追加して有効化してください。
既存の設定ファイル全体を置き換える必要はありません。

```ini
experimental-features = nix-command flakes
```

CLI一覧は`nix/packages.nix`にあります。Git、Vim・Neovim、Language Server、検索・補完ツール、Dockerクライアント、
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

更新方法は[ツールの更新](docs/tools.md#共通cliの更新)を参照してください。

### Macアプリ

Macでは`init.sh`が[Homebrew](https://brew.sh/)本体と不足アプリを導入します。
手動で不足分だけを導入する場合は、次を実行します。

```sh
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle --file="$HOME/dotfiles/brew/Brewfile" --no-upgrade
```

アプリの更新方法は[ツールの更新](docs/tools.md#macアプリの更新)を参照してください。

対象はGhostty、Karabiner-Elements、Docker Desktopです。
アプリの初回起動・必要なOS権限の設定は各Macで行います。
Ghosttyの`~/Library/Application Support/com.mitchellh.ghostty/`に既存設定がある場合は、
XDG側の設定より後に読み込まれるため、競合する項目を確認してください。

### Windows / WSL2

Windows TerminalはWindows側で導入し、Ubuntuプロファイルからシェルを起動します。
Nix・CLI・Herdr・エージェントはUbuntu側で使います。Windows Terminalの設定ファイル全体は上書きしません。

GPG署名のパスフレーズを端末で入力できるよう、共通シェル設定は対話端末で`GPG_TTY`を設定します。
既に開いている端末でコミット時に`Inappropriate ioctl for device`が出る場合は、
`export GPG_TTY="$(tty)"`を実行してからコミットを再試行してください。

Docker DesktopをWindows側で使う場合は、UbuntuへのWSL連携を有効にしてください。
NixのDockerパッケージはクライアントだけで、Dockerデーモンや仮想マシンを起動しません。
接続先の確認には`docker context ls`と`docker info`を使います。

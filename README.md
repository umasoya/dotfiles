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
| `vim/` | Vim設定 |
| `config/karabiner/` | Macのキー設定 |
| `config/ghostty/` | Macの端末設定 |
| `config/herdr/` | Herdr設定 |
| `agents/AGENTS.md` | Codex・Claude Codeの共通ユーザー指示 |
| `agents/skills/` | Codexの共有スキル |
| `AGENTS.md` / `CLAUDE.md` | このリポジトリで作業するエージェントへの指示 |
| `tmux/` | Herdrへの移行が完了するまで保管する旧設定 |

VS Codeは[Settings Sync](https://code.visualstudio.com/docs/configure/settings-sync)に任せます。
ユーザー設定・キーバインドなどが対象ですが、マシン固有設定とWSLなどのリモート拡張機能は同期対象外です。
旧iTerm2・Neovim・pt設定、フォント、補助スクリプトは管理対象から外しました。過去の内容はGit履歴から参照できます。

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

`deploy.sh`はソフトウェアをインストールしません。配置先に別のファイル・ディレクトリ・リンクがあれば、
一覧を表示して変更前に停止します。ただし、`~/.bashrc`が`/etc/skel/.bashrc`と完全に一致する通常ファイルなら、
未変更の標準設定としてバックアップせずdotfilesのリンクへ置き換えます。`--dry-run`では置き換え予定だけを表示します。
編集済みの`.bashrc`や別のリンクは保護します。競合した既存設定を確認し、必要なものを自分のバックアップ先へ移動してから再実行してください。
同じリンクの再配置はスキップします。`--force`で上書きする機能はありません。
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

Macでは`init.sh`が[Homebrew](https://brew.sh/)本体と不足アプリを導入します。
手動で不足分だけを導入する場合は、次を実行します。

```sh
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle --file="$HOME/dotfiles/brew/Brewfile" --no-upgrade
```

アプリを明示的に更新する場合は`HOMEBREW_NO_AUTO_UPDATE=1`と`--no-upgrade`を外して実行します。

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

enhancd・fast-syntax-highlighting・PureもNixで管理し、`.zshrc`から専用プロファイル内のファイルを読み込みます。
Pureの自動fetchは、SSH認証で1Passwordの解除を求められないよう、Bash・Zsh共通の`sh/env`で`PURE_GIT_PULL=0`に設定しています。
ブランチ名・ローカル変更の表示は維持し、リモートの更新は手動の`git fetch`で取得します。
enhancdのソースは`nix/packages.nix`でコミットとハッシュを固定し、残り2つは固定済みnixpkgsのパッケージを使います。
プラグインが未導入なら読み込みをスキップします。既存プロファイルへの反映には、上記の`nix profile upgrade`を実行してください。
afxと未使用のgh-markdown-previewの定義は削除しました。
既存環境のafx本体・`~/.afx`・`$XDG_CONFIG_HOME/afx`、インストール済みのgh拡張は自動削除しません。
動作を確認した後、不要なものを手動で整理してください。

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

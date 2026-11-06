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
| `vim/` / `config/nvim/` | 最小限のVim設定 / Neovim設定 |
| `config/karabiner/` | Macのキー設定 |
| `config/ghostty/` | Macの端末設定 |
| `config/herdr/` | Herdr設定 |
| `agents/AGENTS.md` | Codex・Claude Codeの共通ユーザー指示 |
| `agents/skills/` | Codexの共有スキル |
| `agents/mcp/` | APMによるCodex・Claude Codeの共通MCP管理 |
| `AGENTS.md` / `CLAUDE.md` | このリポジトリで作業するエージェントへの指示 |

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

GPG署名のパスフレーズを端末で入力できるよう、共通シェル設定は対話端末で`GPG_TTY`を設定します。
既に開いている端末でコミット時に`Inappropriate ioctl for device`が出る場合は、
`export GPG_TTY="$(tty)"`を実行してからコミットを再試行してください。

Docker DesktopをWindows側で使う場合は、UbuntuへのWSL連携を有効にしてください。
NixのDockerパッケージはクライアントだけで、Dockerデーモンや仮想マシンを起動しません。
接続先の確認には`docker context ls`と`docker info`を使います。

## 配置する設定

| 元ファイル | 配置先 | 対象 |
| --- | --- | --- |
| `.bash_profile` / `.bashrc` / `.zprofile` / `.zshenv` / `.zshrc` | `~/`の同名ファイル | 共通 |
| `git/.gitconfig` / `git/.gitignore` | `~/.gitconfig` / `~/.gitignore` | 共通 |
| `git/.gitconfig.local`（存在する場合のみ） | `~/.gitconfig.local` | 共通 |
| `vim/.vimrc` | `~/.vimrc` | 共通 |
| `config/nvim/` | `$XDG_CONFIG_HOME/nvim` | 共通 |
| `config/herdr/config.toml` | `$XDG_CONFIG_HOME/herdr/config.toml` | 共通 |
| `agents/AGENTS.md` | `$CODEX_HOME/AGENTS.md`、`~/.claude/CLAUDE.md` | 共通 |
| `agents/mcp/apm.yml` / `run.sh` | `~/.apm/apm.yml` / `~/.apm/dotfiles-mcp.sh` | 共通 |
| `agents/skills/github-pr-create/` | `$CODEX_HOME/skills/github-pr-create` | 共通 |
| `config/karabiner/karabiner.json` / `assets` | `$XDG_CONFIG_HOME/karabiner/`内 | Mac |
| `config/ghostty/` | `$XDG_CONFIG_HOME/ghostty` | Mac |

`XDG_CONFIG_HOME`の既定値は`~/.config`、`CODEX_HOME`は`~/.codex`です。
標準配置先は`~/dotfiles`です。別の場所へcloneした場合は、シェル起動前の環境で`DOT_DIR`を設定してください。
Karabinerの自動バックアップやエージェントの認証・履歴ディレクトリ全体はリンクしません。

## エージェントとローカル設定

Codex・Claude Codeは初回起動時にそれぞれログインします。
CLIバージョン、`agents/AGENTS.md`のユーザー指示、共通MCPのサーバー定義を共有します。
Codexの共有スキルは`agents/skills/`で管理し、スキルごとにリンクします。
`github-pr-create`は`$github-pr-create 今の変更からPRを作成して`で呼び出せます。
既存の同名スキルがある場合は、内容を確認してバックアップ先へ移動してから`deploy.sh`を実行してください。
`$CODEX_HOME/skills`全体は置き換えず、他のスキルはそのまま残します。
Serena・GitHub・Docker・Cloudflare・Chrome DevToolsのMCP定義は
`agents/mcp/apm.yml`で管理し、[APM](https://github.com/microsoft/apm)で両クライアントのユーザー設定へ登録します。
`deploy.sh`はAPMの定義と起動スクリプトだけをリンクします。サーバーの登録は自動実行しません。
共通Nixプロファイルの`apm`コマンドは、uvxで`apm-cli==0.35.0`を起動します。
[登録・認証・旧設定からの移行手順](agents/mcp/README.md)を確認し、次を実行します。

```sh
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
apm install --global --only mcp --dry-run </dev/null
apm install --global --only mcp </dev/null
```

GitHubトークンは1Passwordに保管し、`op run`でエージェント起動時だけ渡します（[設定手順](agents/mcp/README.md#githubと1password)）。
Postgres MCPは既知の脆弱性のため登録・起動を停止しています。
認証情報は環境変数とローカル設定に残し、モデル・権限・仕事用設定は各クライアントで管理します。
APMのロックファイルと管理状態は`~/.apm/`に保存し、dotfilesでは追跡しません。
既存の同名定義が異なる場合はAPMが保護してエラーになりますが、他サーバーへの登録は部分的に進む場合があります。

[Codexの指示ファイル](https://developers.openai.com/codex/guides/agents-md/)と
[Claude Codeのメモリ設定](https://code.claude.com/docs/en/memory)の仕様に従い、
このリポジトリの作業指示は`AGENTS.md`に集約し、`CLAUDE.md`から参照します。

- Gitのマシン固有設定: `git/.gitconfig.local`（追跡対象外）。`deploy.sh`が`~/.gitconfig.local`へリンクし、カスタム`DOT_DIR`でも選択したcheckoutの設定を読み込みます。ファイルを後から作成した場合は`deploy.sh`を再実行してください。既存の`~/.gitconfig.local`が別の実体なら、他の設定と同様に競合として保護します。
- 対話シェルの追加設定: `~/.bashrc.local`、`~/.zshrc.local`
- Ghosttyの追加設定: `config/ghostty/local.config`（追跡対象外）

仕事用の設定は、共有できる部分だけを後から取り込んでください。

## Herdrとシェルプラグイン

`herdr`で起動します。旧tmuxから`Ctrl+t`のprefixと`h/j/k/l`のペイン移動を引き継いだ初期設定です。
既存環境のtokyo-nightテーマ・システム通知・初回案内済みの設定も共有しています。
分割などの操作は`Ctrl+t`の後に`?`で確認できます。
[設定仕様](https://herdr.dev/docs/configuration/)に従い、変更後は`herdr server reload-config`で再読み込みします。

tmuxの旧設定はHerdrへの移行に伴い削除しました。
既存環境のtmux本体やホーム内の旧リンクは自動削除しません。

### Git worktreeを作る

`bin/git-wt`は任意のGitリポジトリで使える単体のBashスクリプトです。
必要なものはBash・Git・Herdr・jqで、dotfilesの設定には依存しません。
単体で利用する場合は、PATHの通ったディレクトリへ配置します。

```sh
mkdir -p "$HOME/.local/bin"
install -m 755 bin/git-wt "$HOME/.local/bin/git-wt"
```

このdotfilesを利用する場合は共通シェル設定が`$DOT_DIR/bin`をPATHへ追加するため、コピーは不要です。
既に開いているシェルでは`source "${DOT_DIR:-$HOME/dotfiles}/sh/env"`でPATHを反映してください。
ヘルプは`git wt -h`で表示します（`git wt --help`はGitがmanページを探すため使いません）。
Herdrを起動してから、作業対象のリポジトリ内（サブディレクトリでも可）で次を実行します。

```sh
git wt feat/login              # HEADから新規ブランチを作り、Herdrで開く
git wt fix/login origin/main   # 指定した起点から作成（fetchは事前に手動実行）
git wt existing-branch         # 既存のローカルブランチでworktreeを作成
```

[Herdrのworktree機能](https://herdr.dev/tui/docs/cli-reference/)を使い、作成したワークスペースへフォーカスします。
配置先はHerdrの`worktrees.directory`設定に従います。未コミットの変更はコピーしません。
既存ブランチに起点を指定するとエラーになります。他のworktreeで使用中のブランチや配置先の競合はHerdr/Gitが検出します。
作成済みのworktreeを再び開く場合は`herdr worktree open --cwd "$PWD" --branch feat/login --focus`を使います。

不要になったworktreeは、同じリポジトリの別のcheckoutから削除します。

```sh
git wt --remove feat/login
```

Herdrで開いている場合は、そのworktreeのワークスペースも閉じます。
既に閉じているworktreeにも対応します。ブランチとコミットは残します。
未コミットの変更・未追跡ファイルがある場合や、Gitでロックされている場合は削除を拒否します。
強制削除や一括削除は行いません。Herdrサーバーは削除時も起動しておく必要があります。

enhancd・fast-syntax-highlighting・PureもNixで管理し、`.zshrc`から専用プロファイル内のファイルを読み込みます。
Pureの自動fetchは、SSH認証で1Passwordの解除を求められないよう、Bash・Zsh共通の`sh/env`で`PURE_GIT_PULL=0`に設定しています。
ブランチ名・ローカル変更の表示は維持し、リモートの更新は手動の`git fetch`で取得します。
enhancdのソースは`nix/packages.nix`でコミットとハッシュを固定し、残り2つは固定済みnixpkgsのパッケージを使います。
プラグインが未導入なら読み込みをスキップします。既存プロファイルへの反映には、上記の`nix profile upgrade`を実行してください。
afxと未使用のgh-markdown-previewの定義は削除しました。
既存環境のafx本体・`~/.afx`・`$XDG_CONFIG_HOME/afx`、インストール済みのgh拡張は自動削除しません。
動作を確認した後、不要なものを手動で整理してください。

## NeovimとVim

普段の編集は`nvim`、最小限の編集用には`vim`を使います。エイリアスで置き換えません。
Vimは同梱の`defaults.vim`を読むだけの設定です。
Neovimは`config/nvim/init.lua`だけで管理し、プラグインの取得や管理ツールは不要です。
行番号・大文字小文字を考慮した検索・検索結果の強調表示を設定しています。強調解除は`:noh`です。
配色・インデント・キー操作はNeovimの標準を使い、保存時の自動整形は行いません。

### 導入・移行

共通Nixプロファイルの導入・更新後、`bash deploy.sh --dry-run`で確認し、`bash deploy.sh`で配置します。
更新手順は「共通CLI」を参照してください。固定済みNixパッケージのNeovimを使います。
LSP設定にはNeovim 0.11以上が必要です。古いNeovimでは表示・検索の設定だけを読み込みます。
`nvim --version`と`command -v nvim`で、古い手動導入版よりNix版が優先されていることを確認してください。

既存の`$XDG_CONFIG_HOME/nvim`がある場合は配置前に競合として停止します。
内容を確認し、必要な設定をバックアップ先へ移動してから再実行してください。
既存の`~/.vimrc`が別のcheckoutを指している場合も、参照先を確認して切り替えます。
`~/.vim`は配置対象外です。旧リンクやdein本体、`~/.cache/dein`は自動削除しません。
不要な旧リンクは参照先を確認して手動で削除してください。過去の設定はGit履歴から参照できます。

### 言語別の支援

対象ファイルを開いたときに、PATH上の対応サーバーが使える場合だけLSPを起動します。
それ以外の言語や未導入サーバーの環境でも、通常の編集はできます。
対象言語でもプロジェクト解析にはCPU・メモリを使い、規模により初回解析に時間がかかります。

| 対象 | サーバー | 導入・依存 |
| --- | --- | --- |
| TypeScript・React / JavaScript | typescript-language-server | Nix。プロジェクトのTypeScript・React依存とtsconfigを使用。サーバーにはNix側のTypeScriptフォールバックも付属 |
| Go | gopls | Nix。対応するGoツールチェーンとgo.mod / go.workはプロジェクト側で用意 |
| Ruby・Rails / ERB | ruby-lsp | プロジェクトに合うRuby・Bundler環境で導入。Railsはruby-lsp-railsも使用 |
| Markdown | marksman | Nix。見出し・リンクの補完や移動。HTMLプレビューは含まない |
| JSON / JSONC | vscode-json-language-server | Nixのvscode-langservers-extractedに同梱 |
| YAML | yaml-language-server | Nix。SchemaStoreの自動利用は無効 |

Rubyは対象Ruby環境を有効にして`gem install ruby-lsp`で導入し、プロジェクトのルートから`nvim`を起動します。
Gemfileでツールも管理する場合は、開発用グループに`ruby-lsp`とRails用の`ruby-lsp-rails`を追加して
`bundle install`し、`bundle exec nvim`で起動してください。各プロジェクトの運用を優先します。
Ruby LSPは起動時に専用bundleを構成し、依存gemを取得する場合があります。
詳細は[Ruby LSPのエディタ設定](https://shopify.github.io/ruby-lsp/editors.html)を参照してください。
RailsやERBの支援範囲はサーバー・アドオンの対応状況によります。

JSONは`$schema`、YAMLは`# yaml-language-server: $schema=...`でスキーマを指定できます。
スキーマがある場合は、その定義に基づく補完・検査が利用できます。URLで指定したスキーマの取得にはネットワーク接続が必要です。
ESLint・Prettier・RuboCopなどの追加lint・整形ツールは自動導入せず、プロジェクトに合わせて別途設定します。

### 基本操作

独自のキーマップは追加せず、Neovim内蔵LSPの標準操作を使います。
機能は接続先サーバーの対応状況によります。

| 操作 | キー / コマンド |
| --- | --- |
| 補完候補 | 挿入モードで`Ctrl+x Ctrl+o`。サーバー指定の文字（`.`など）でも自動表示 |
| 補完候補の選択・確定 | `Ctrl+n` / `Ctrl+p`、`Ctrl+y`で確定、`Ctrl+e`で中止 |
| 定義へ移動・戻る | `Ctrl+]` / `Ctrl+t` |
| 説明を表示 | `K` |
| 参照検索 | `grr` |
| 名前変更 | `grn` |
| コードアクション | `gra` |
| 診断の前後へ移動 | `[d` / `]d` |
| 接続状況と問題の確認 | `:checkhealth vim.lsp` |
| 明示的に整形 | `:lua vim.lsp.buf.format()` |

設定を追加する場合は`config/nvim/init.lua`の共通オプションか`servers`テーブルを編集します。
LSP設定変更後はNeovimを再起動してください。

## 検証とGit hook

`deploy.sh`は`core.hooksPath=.githooks`を設定します。
pre-commitは変更対象のシェルファイルを1つずつ構文検査し、BashにはShellCheckとshfmtも実行します。
検査ツールは共通Nixプロファイルに含めています。

```sh
python3 -m unittest discover -s tests -v
APM_TEST_EXECUTABLE="$(command -v apm)" python3 -m unittest discover -s tests -p test_mcp.py -v
nix flake check --no-build --all-systems
```

Neovimのテストも一時ホームを使います。Neovim 0.11以上がPATH上にない場合はスキップします。
実サーバーへの接続を確認する場合は次を実行します（Rubyはプロジェクト環境で別途確認）。

```sh
NVIM_TEST_EXECUTABLE="$(command -v nvim)" NVIM_TEST_SERVER_PATH="$PATH" \
  python3 -m unittest discover -s tests -p test_nvim.py -v
```

配置テストは一時ホームと模擬コマンドを使い、実際のホーム設定を変更しません。

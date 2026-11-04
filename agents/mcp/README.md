# 共通MCP

[APM](https://github.com/microsoft/apm)の`apm.yml`を共通定義として、
CodexとClaude Codeのユーザー設定に登録します。自作の`setup.py`と`servers.json`は廃止しました。
`deploy.sh`は次の2ファイルを競合確認付きでリンクし、サーバーの登録は行いません。

- `apm.yml` → `~/.apm/apm.yml`
- `run.sh` → `~/.apm/dotfiles-mcp.sh`

| 名前 | 実装・用途 | ローカルで用意するもの |
| --- | --- | --- |
| serena | [Serena](https://github.com/oraios/serena)、起動ディレクトリをプロジェクトとして検出 | 対象言語の開発環境 |
| github | [GitHub公式](https://github.com/github/github-mcp-server/blob/main/docs/installation-guides/install-codex.md)、HTTP | 1Password内のトークン、1Password CLI (`op`) |
| docker | [mcp-server-docker](https://github.com/ckreiling/mcp-server-docker)、コンテナ・イメージ・Compose操作 | 起動済みDockerデーモン |
| cloudflare | [Cloudflare公式](https://developers.cloudflare.com/agents/model-context-protocol/cloudflare/servers-for-cloudflare/)、アカウント操作 | 各クライアントでOAuth認証 |
| chrome-devtools | [Chrome DevTools公式](https://github.com/ChromeDevTools/chrome-devtools-mcp)、ブラウザー操作 | Chrome、必要に応じて接続先・実行ファイル |

Dockerはコミュニティ実装です。Docker MCP Gatewayとは別のサーバーを使います。
SerenaはGitコミット、Python/npmのMCPはバージョンを`run.sh`で固定しています。
Serenaは両クライアントで共通の`agent`コンテキストを使い、起動ディレクトリからプロジェクトを検出します。
HTTPサーバーの実装バージョンはサービス側で管理されます。

Postgres MCPは[CVE-2026-85620](https://github.com/advisories/GHSA-cm87-gp55-7cgj)と
[依存解決の不具合](https://github.com/crystaldba/postgres-mcp/issues/237)のため、登録から除外しています。
旧登録の`run.sh postgres`も依存取得・DB接続前に停止します。検証済み修正版を採用するまで再開しません。

## 登録

共通Nixプロファイルを更新して、Python 3.13・Node.js 22・uvと`apm`を導入します。
`apm`はNixのラッパー経由で`uvx --python python3.13 --from apm-cli==0.35.0 apm`を実行します。
APM自体とPython依存の初回取得にはネットワーク接続が必要です。
ラッパーの`apm.sh`は、APM 0.35.0がClaude向けHTTPヘッダーを登録時に展開することを避けるため、
APM子プロセスから`GITHUB_MCP_TOKEN`を除外します。
登録コマンドの`</dev/null`は対話的なトークン入力も省略し、未展開の参照を維持するために必要です。
親シェルやエージェントへ渡す環境変数は変えません。他のAPM導入方法でこのラッパーを迂回しないでください。
認証付きHTTPサーバーを追加するときは、参照するトークン名をこの除外対象にも追加します。
APMのバージョン更新は`agents/mcp/apm.sh`で行い、`apm self-update`は使いません。

```sh
cd "$HOME/dotfiles"
bash deploy.sh --dry-run
bash deploy.sh
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
apm install --global --only mcp --dry-run </dev/null
apm install --global --only mcp </dev/null
```

clone先が異なる場合は`cd`先を変更してください。MCP起動はホーム内のリンクを参照するため、
設定にcheckoutの絶対パスは埋め込みません。リンクは選択したcheckoutを指します。
カスタム`XDG_CONFIG_HOME`は登録時にも設定します。Codex用のstdio設定にはAPMがその値を保存します。

`targets: [codex, claude]`で対象を固定しています。片方だけ使う場合は
`apm install --global --only mcp --target codex`（または`--target claude`）を使います。
対象を狭めると、APMが以前管理していた対象外クライアントの登録が削除される場合があります。
Codexは`${CODEX_HOME:-$HOME/.codex}/config.toml`、Claude Codeはユーザースコープへ登録します。
`CODEX_HOME`と`CLAUDE_CONFIG_DIR`は各マシンの環境変数で指定します。

APMの管理状態と`apm.lock.yaml`は`~/.apm/`内のローカルデータです。
認証状態やマシン固有情報を含めてdotfilesへ取り込みません。
MCPの追加・変更はこのリポジトリの`apm.yml`を編集して、上記のinstallを再実行します。
`apm install --global --mcp ...`もリンク先の共有定義を変更するため、実行後はGit差分を確認してください。
サーバーの削除はマニフェストから該当定義を削除し、各クライアントの`mcp remove`で該当接続だけを削除してからinstallを再実行します。

## 旧登録からの移行と競合

既存の`~/.apm/apm.yml`や`~/.apm/dotfiles-mcp.sh`が別のファイルなら、`deploy.sh`は変更前に停止します。
既存APM定義を確認・退避し、必要な個人用定義を新しいマニフェストへ統合してから配置してください。
認証値や仕事用の非公開定義は共有マニフェストに追加しないでください。

APMは内容の異なる既存接続を勝手に引き継ぎません。同一内容の既存接続も、APM管理下へ自動採用されるとは限りません。
旧`setup.py`から移行するときは、各クライアントの同名設定と追加オプションを確認・退避した上で、
移行するサーバーだけを削除して再登録します。設定ファイル全体は削除しません。

```sh
# サーバーごとに既存設定を確認・退避してから実行（例: serena）
codex mcp remove serena
claude mcp remove --scope user serena
apm install --global --only mcp </dev/null
```

旧Postgres登録も`codex mcp remove postgres`と`claude mcp remove --scope user postgres`で削除してください。
APMは自分が管理していない旧登録を自動削除しません。
競合時はエラーになりますが、それまでに成功した登録は残る場合があります。
原因を解消して同じinstallを再実行します。`--force`で既存接続の上書きを試みないでください。

## 認証と環境差

ローカルの起動設定を作成します。

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles"
cp "$HOME/dotfiles/agents/mcp/mcp.env.example" \
  "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/mcp.env"
chmod 600 "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/mcp.env"
```

このファイルは信頼するローカルのシェルファイルとして、stdioサーバーの起動時に読み込みます。
プロジェクト内の`.env`は読み込みません。

### GitHubと1Password

トークンは1Passwordに保管し、[1Password CLIの`op run`](https://developer.1password.com/docs/cli/reference/commands/run/)で
エージェント起動時に`GITHUB_MCP_TOKEN`として渡します。共通MCP定義は引き続き環境変数名だけを参照します。

1. [1Password CLI](https://developer.1password.com/docs/cli/get-started/)を各マシンに導入し、`op --version`と`op whoami`で利用できることを確認します。
2. GitHubトークンを1Passwordのアイテムに保存します。
3. トークンのフィールドから「Copy Secret Reference」で`op://...`形式の参照をコピーします。
4. 次のサンプルをローカルへコピーし、参照だけを編集します。実際の保管庫名・アイテム名・トークン値はdotfilesへ追加しません。

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles"
# 既にgithub.envがある場合はコピーせず、その内容を確認・編集します。
cp -n agents/mcp/github.env.example "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/github.env"
chmod 600 "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/github.env"
```

`github.env`の内容は次の形式です。`op://...`をコピーした参照へ置き換えます。

```dotenv
GITHUB_MCP_TOKEN="op://vault-name/item-name/field-name"
```

使いたいプロジェクトのディレクトリで、次のどちらかを実行します。

```sh
op run --env-file="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/github.env" -- codex
op run --env-file="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/github.env" -- claude
```

`op run`はトークンを子プロセスの環境変数として渡します。参照ファイルを平文トークンに書き換えません。
`github.env`をシェルからsourceしたり、`mcp.env`にトークンを保存したりする必要はありません。
以前`mcp.env`やシェルのローカル設定にトークンを保存した場合は、その記述を削除して`unset GITHUB_MCP_TOKEN`を実行します。
APMの登録時には1Password認証は不要です。登録は通常どおり`apm.sh`経由で行い、`op run`で包みません。
この環境に`op`がない場合は導入・認証を先に行ってください。1Passwordへのアイテム作成やログインは各マシンで行います。

### Context7の削除

Context7は共通定義から削除しました。既存クライアントの登録が残っている場合は、次で該当項目だけを削除します。

```sh
codex mcp remove context7
claude mcp remove --scope user context7
bash agents/mcp/apm.sh install --global --only mcp </dev/null
```

ローカルで設定していた`CONTEXT7_API_KEY`も不要なら削除し、`unset CONTEXT7_API_KEY`を実行します。

### その他の接続

Cloudflareは登録後に`codex mcp login cloudflare`、Claude Code内の`/mcp`からそれぞれ認証します。
認証状態は各クライアントのローカル管理です。

Dockerは現在選択中の`docker context`の接続先を使います。`DOCKER_HOST`を指定すればそちらを優先します。
TLS接続では`DOCKER_TLS_VERIFY`や`DOCKER_CERT_PATH`もローカル設定で指定します。
WSL2ではDocker DesktopのUbuntu連携を有効にします。

Chromeは既定で独立した一時プロファイルを使います。
MacやLinuxでChromeの場所を指定する場合は`CHROME_MCP_EXECUTABLE`、
WSLから起動済みのWindows Chromeへ接続する場合は`CHROME_MCP_BROWSER_URL`を設定します。
Windows Chromeは専用プロファイルとremote debuggingを有効にして別途起動し、
WSLから到達できるURLを指定してください。接続用ポートは外部公開しません。
具体的な起動・接続方法は[Chrome公式の接続手順](https://github.com/ChromeDevTools/chrome-devtools-mcp/blob/main/docs/advanced-usage.md#connecting-to-a-running-chrome-instance)を参照してください。

初回のstdio起動ではuvx/npxが依存をダウンロードします。ネットワーク接続が必要です。
初回にタイムアウトする場合は、使うサーバーを`bash agents/mcp/run.sh docker`などで一度起動して依存を取得し、終了後にクライアントから再接続します。
接続確認は`codex mcp list`、`claude mcp list`、各クライアント内の`/mcp`で行います。

クライアント側の設定仕様は[Codex公式](https://developers.openai.com/codex/mcp)と
[Claude Code公式](https://code.claude.com/docs/en/mcp)に従います。

## 検証

`python3 -m unittest discover -s tests -v`で配置・起動テストを実行します。
APM本体を使った登録・再実行・競合・認証参照のテストは次で実行します。
実ホームへは書き込まず、一時ホームと模擬コマンドを使います。

```sh
APM_TEST_EXECUTABLE="$(command -v apm)" python3 -m unittest discover -s tests -p test_mcp.py -v
```

`APM_TEST_EXECUTABLE`未指定時はAPM統合テストだけをスキップします。

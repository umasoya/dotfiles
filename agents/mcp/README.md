# 共通MCP

`servers.json`を共通定義として、CodexとClaude Codeのユーザー設定に登録します。
`setup.py`は公式CLIでMCP項目だけを追加します。認証・モデル・権限設定のファイル全体はリンクしません。
`init.sh`と`deploy.sh`では自動登録しません。

| 名前 | 実装・用途 | ローカルで用意するもの |
| --- | --- | --- |
| serena | [Serena](https://github.com/oraios/serena)、起動ディレクトリをプロジェクトとして検出 | 対象言語の開発環境 |
| github | [GitHub公式](https://github.com/github/github-mcp-server/blob/main/docs/installation-guides/install-codex.md)、HTTP | `GITHUB_MCP_TOKEN` |
| docker | [mcp-server-docker](https://github.com/ckreiling/mcp-server-docker)、コンテナ・イメージ・Compose操作 | 起動済みDockerデーモン |
| cloudflare | [Cloudflare公式](https://developers.cloudflare.com/agents/model-context-protocol/cloudflare/servers-for-cloudflare/)、アカウント操作 | 各クライアントでOAuth認証 |
| chrome-devtools | [Chrome DevTools公式](https://github.com/ChromeDevTools/chrome-devtools-mcp)、ブラウザー操作 | Chrome、必要に応じて接続先・実行ファイル |
| context7 | [Context7公式](https://context7.com/docs/resources/all-clients)、ライブラリドキュメント参照 | `CONTEXT7_API_KEY` |

Dockerはコミュニティ実装です。Docker MCP Gatewayとは別のサーバーを使います。
SerenaはGitコミット、Python/npmのMCPはバージョンを`run.sh`で固定しています。
HTTPサーバーの実装バージョンはサービス側で管理されます。

Postgres MCPは[CVE-2026-85620](https://github.com/advisories/GHSA-cm87-gp55-7cgj)の
`restricted`モード回避と[依存解決の不具合](https://github.com/crystaldba/postgres-mcp/issues/237)のため、
共通登録から除外し、`run.sh postgres`も依存取得・DB接続前に停止します。
検証済みの修正版を採用するまで再開しません。
既に登録済みの場合は、`codex mcp remove postgres`および`claude mcp remove --scope user postgres`で削除してください。
`setup.py`は既存のローカル定義を自動削除しません。

## 登録

共通Nixプロファイルを更新して、Python 3.13・Node.js 22・uvを導入し、新しいシェルを開きます。
これらはMCPの起動用です。プロジェクトのランタイムは各開発環境で管理します。

```sh
python3 "$HOME/dotfiles/agents/mcp/setup.py" --dry-run
python3 "$HOME/dotfiles/agents/mcp/setup.py"
```

片方だけ使う場合は`--client codex`または`--client claude`を追加します。
clone先が異なる場合は、上記パスをそのcheckoutに合わせてください。
登録時にcheckoutのパスを解決するので、移動後は再登録が必要です。

同じ定義は再登録せず、追加のローカル設定（無効化・タイムアウト・ツール制限など）も残します。
同名サーバーの定義が異なる場合は、両クライアントを確認した時点で変更前に停止します。
差分を確認し、必要なら既存定義を手動で退避・削除してから再実行してください。
CLIの途中失敗ではそれまでの追加が残りますが、再実行で不足分を追加できます。

Codexの配置先は`${CODEX_HOME:-$HOME/.codex}/config.toml`、Claude Codeはユーザースコープです。
`CLAUDE_CONFIG_DIR`の指定も尊重します。プロジェクト固有の設定が同名サーバーを上書きする場合は、各プロジェクトでも確認してください。

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

GitHubとContext7はHTTP接続なので、エージェント本体のプロセスにトークンをexportする必要があります。
シークレット管理ツールから渡すか、上記ファイルに`export`付きで保存し、
`~/.zshrc.local`または`~/.bashrc.local`に次を追加して新しいシェルで起動します。

```sh
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/mcp.env" ]; then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles/mcp.env"
fi
```

共有定義には環境変数名だけを登録します。トークン値をCLIの引数に渡しません。
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

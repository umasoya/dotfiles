# エージェントとローカル設定

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
[登録・認証・旧設定からの移行手順](../agents/mcp/README.md)を確認し、次を実行します。

```sh
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
apm install --global --only mcp --dry-run </dev/null
apm install --global --only mcp </dev/null
```

GitHubトークンは1Passwordに保管し、`op run`でエージェント起動時だけ渡します（[設定手順](../agents/mcp/README.md#githubと1password)）。
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

[READMEへ戻る](../README.md)

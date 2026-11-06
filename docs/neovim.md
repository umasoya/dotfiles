# NeovimとVim

普段の編集は`nvim`を使います。Bash・ZshではNeovimが利用可能な場合に`vi`を`nvim`のエイリアスにし、共通環境設定で`EDITOR=nvim`を設定します。
Neovimが未導入ならエイリアスは追加せず、既存の`EDITOR`を維持します。最小限の編集用には`vim`を直接使えます。
Vimの設定ファイルは管理・配置せず、各環境の標準状態で使います。
Neovimは[`config/nvim/init.lua`](../config/nvim/init.lua)だけで管理し、プラグインの取得や管理ツールは不要です。
行番号・大文字小文字を考慮した検索・検索結果の強調表示を設定しています。強調解除は`:noh`です。
配色・インデント・キー操作はNeovimの標準を使い、保存時の自動整形は行いません。

## 導入・移行

以下のコマンドはリポジトリのルートで実行します。
共通Nixプロファイルの導入・更新後、`bash deploy.sh --dry-run`で確認し、`bash deploy.sh`で配置します。
更新手順は[共通CLI](../README.md#共通cli)を参照してください。固定済みNixパッケージのNeovimを使います。
LSP設定にはNeovim 0.11以上が必要です。古いNeovimでは表示・検索の設定だけを読み込みます。
`nvim --version`と`command -v nvim`で、古い手動導入版よりNix版が優先されていることを確認してください。

既存の`$XDG_CONFIG_HOME/nvim`がある場合は配置前に競合として停止します。
内容を確認し、必要な設定をバックアップ先へ移動してから再実行してください。
`~/.vimrc`・`~/.vim`は配置対象外です。既存の設定・旧リンクやdein本体、`~/.cache/dein`は自動削除しません。
不要な旧リンクは参照先を確認して手動で削除してください。過去の設定はGit履歴から参照できます。

## 言語別の支援

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

## 基本操作

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

## 検証

Neovimのテストは一時ホームを使います。Neovim 0.11以上がPATH上にない場合はスキップします。
実サーバーへの接続を確認する場合は次を実行します（Rubyはプロジェクト環境で別途確認）。

```sh
NVIM_TEST_EXECUTABLE="$(command -v nvim)" NVIM_TEST_SERVER_PATH="$PATH" \
  python3 -m unittest discover -s tests -p test_nvim.py -v
```

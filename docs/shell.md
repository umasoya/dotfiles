# シェルプラグイン

enhancd・fast-syntax-highlighting・PureはNixで管理し、`.zshrc`から専用プロファイル内のファイルを読み込みます。
Pureの自動fetchは、SSH認証で1Passwordの解除を求められないよう、Bash・Zsh共通の`sh/env`で`PURE_GIT_PULL=0`に設定しています。
ブランチ名・ローカル変更の表示は維持し、リモートの更新は手動の`git fetch`で取得します。
enhancdのソースは`nix/packages.nix`でコミットとハッシュを固定し、残り2つは固定済みnixpkgsのパッケージを使います。
プラグインが未導入なら読み込みをスキップします。既存プロファイルへの反映には、[共通CLIの更新手順](tools.md#共通cliの更新)の`nix profile upgrade`を実行してください。
afxと未使用のgh-markdown-previewの定義は削除しました。
既存環境のafx本体・`~/.afx`・`$XDG_CONFIG_HOME/afx`、インストール済みのgh拡張は自動削除しません。
動作を確認した後、不要なものを手動で整理してください。

[READMEへ戻る](../README.md)

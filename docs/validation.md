# 検証とGit hook

以下のコマンドはリポジトリのルートで実行します。

`deploy.sh`は`core.hooksPath=.githooks`を設定します。
pre-commitは変更対象のシェルファイルを1つずつ構文検査し、BashにはShellCheckとshfmtも実行します。
検査ツールは共通Nixプロファイルに含めています。

```sh
python3 -m unittest discover -s tests -v
APM_TEST_EXECUTABLE="$(command -v apm)" python3 -m unittest discover -s tests -p test_mcp.py -v
nix flake check --no-build --all-systems
```

配置テストは一時ホームと模擬コマンドを使い、実際のホーム設定を変更しません。

[READMEへ戻る](../README.md)

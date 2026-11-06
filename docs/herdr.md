# HerdrとGit worktree

`herdr`で起動します。旧tmuxから`Ctrl+t`のprefixと`h/j/k/l`のペイン移動を引き継いだ初期設定です。
既存環境のtokyo-nightテーマ・システム通知・初回案内済みの設定も共有しています。
分割などの操作は`Ctrl+t`の後に`?`で確認できます。
[設定仕様](https://herdr.dev/docs/configuration/)に従い、変更後は`herdr server reload-config`で再読み込みします。

tmuxの旧設定はHerdrへの移行に伴い削除しました。
既存環境のtmux本体やホーム内の旧リンクは自動削除しません。

## Git worktreeを作る

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

[READMEへ戻る](../README.md)

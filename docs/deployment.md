# 設定の配置

| 元ファイル | 配置先 | 対象 |
| --- | --- | --- |
| `.bash_profile` / `.bashrc` / `.zprofile` / `.zshenv` / `.zshrc` | `~/`の同名ファイル | 共通 |
| `git/.gitconfig` / `git/.gitignore` | `~/.gitconfig` / `~/.gitignore` | 共通 |
| `git/.gitconfig.local`（存在する場合のみ） | `~/.gitconfig.local` | 共通 |
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

[READMEへ戻る](../README.md)

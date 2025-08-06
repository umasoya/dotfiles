export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
if command -v rbenv > /dev/null 2>&1; then
    eval "$(rbenv init -)"
fi

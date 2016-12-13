# 重複したパスを登録しない
typeset -U path

# Set GOPATH
export GOPATH="$HOME/Golang"

 #(N-/): 存在しないパスを登録しない
path=(
	/usr/local/bin(N-/)
	/usr/bin(N-/)
	/usr/local/sbin(N-/)
	$HOME/local/bin(N-/)
	$HOME/scripts(N-/)
	$HOME/.rbenv(N-/)
	$GOPATH(N-/)
	$GOPATH/bin(N-/)
	$HOME/.nodebrew/current/bin(N-/)
	#node_modules
	$HOME/.nodebrew/node/v6.2.1/lib/node_modules
	$path
)

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

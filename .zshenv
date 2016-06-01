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
	$path
)


# 重複したパスを登録しない
typeset -U path

# (N-/): 存在しないパスを登録しない
path=(
	/usr/local/bin(N-/)
	/usr/bin(N-/)
	$HOME/local/bin(N-/)
	$HOME/script(N-/)
)

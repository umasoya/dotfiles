# vim: noexpandtab ft=make

.PHONY: all

all: bash docker go yaml ;
	@echo 'hoge'

bash:
	@npm i -g bash-language-server

docker:
	@npm i -g dockerfile-language-server-nodejs

go:
	@go get -u github.com/sourcegraph/go-langserver

yaml:
	@npm i -g yaml-language-server

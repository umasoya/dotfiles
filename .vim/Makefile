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

php:
	@composer global require jetbrains/phpstorm-stubs:dev-master
	@composer global require felixfbecker/language-server
	@composer run-script --working-dir=${HOME}/.config/composer/vendor/felixfbecker/language-server parse-stubs

yaml:
	@npm i -g yaml-language-server

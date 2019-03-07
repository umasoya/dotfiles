# vim: noexpandtab ft=make
COMPOSER_PATH := $(realpath $(HOME)/.config/composer/vendor)

.PHONY: all

all: bash docker go php yaml ;

bash:
	@npm i -g bash-language-server

docker:
	@npm i -g dockerfile-language-server-nodejs

go:
	@go get -u github.com/sourcegraph/go-langserver

javascript:
	@npm i -g typescript typescript-language-server

php:
	@composer global require jetbrains/phpstorm-stubs:dev-master
	@composer global require felixfbecker/language-server
	@composer run-script --working-dir=$(COMPOSER_PATH)/felixfbecker/language-server parse-stubs
	@mv $(COMPOSER_PATH)/bin/php-language-server.php $(COMPOSER_PATH)/bin/php-language-server
	@npm i -g intelephense

yaml:
	@npm i -g yaml-language-server

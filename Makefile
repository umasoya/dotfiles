# vim: noexpandtab ft=make

.DEFAULT_GOAL := help
.PHONY: all

install: ## Create Symlink to home directory
	@./etc/setup/install

clean: ## Unlink dotfiles
	@./etc/setup/clean

test: ## test
	@./etc/setup/e_test

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

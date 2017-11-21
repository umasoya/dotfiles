DOTPATH    := $(realpath $(HOME)/dotfiles)
CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitconfig
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help

list: ## Show dotfiles in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy: ## Create Symlink to home directory
	@echo 'Create symlinks in your home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

install: update deploy ## Run make update, deploy
	@exec $$SHELL

update: ## Fetch changes for this repo
	git fetch
	git submodule init
	git submodule update
	git submodule foreach git pull origin master
	git rebase origin master

clean: ## Unlink dotfiles and remove this repo
	@echo 'Remove dotfiles in your home directory...'
	@-$(foreach val, $(DOTFILES), unlink $(HOME)/$(val);)
	-rm -rf $(DOTPATH)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

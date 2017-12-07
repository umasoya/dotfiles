DOTPATH     := $(realpath $(HOME)/dotfiles)
CANDIDATES  := $(wildcard .??*)
EXCLUSIONS  := .DS_Store .git .gitconfig
ADDITIONALS := etc/.gitconfig
DOTFILES    := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

.DEFAULT_GOAL := help
.PHONY: all

list: ## Show dotfiles in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy: ## Create Symlink to home directory
	@echo 'Create symlinks in your home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@$(foreach val, $(ADDITIONALS), ln -sfnv $(abspath $(val)) $(HOME)/$(notdir $(val));)
	@if [[ -d ${HOME}/.ssh ]]; then \
		ln -sfnv $(abspath $(DOTPATH)/.local/.ssh/bitbucket) $(HOME)/.ssh/bitbucket; \
		ln -sfnv $(abspath $(DOTPATH)/.local/.ssh/github) $(HOME)/.ssh/github; \
		ln -sfnv $(abspath $(DOTPATH)/.local/.ssh/config) $(HOME)/.ssh/config; \
		fi
	@echo 'Make directory for Golang.'
	@mkdir -p $(HOME)/Golang/{src,bin}
	@mkdir -p ${HOME}/Golang/src/github.com/yasuto777

install: update deploy ## Run make update, deploy
	@exec $$SHELL

init: ## Enable autostash
	@git config rebase.autostash true

update: ## Fetch changes for this repo
	@git fetch
	@git submodule init
	@git submodule update
	@git submodule foreach git pull origin master
	@# Enable autostash option is git version 1.8.4 or later
	@git rebase --autostash origin master

clean: ## Unlink dotfiles and remove this repo
	@echo 'Remove dotfiles in your home directory...'
	@-$(foreach val, $(DOTFILES), unlink $(HOME)/$(val);)
	-rm -rf $(DOTPATH)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

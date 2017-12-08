# vim: noexpandtab ft=make
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
	@echo -e "\e[30;42mCreate symlinks in your home directory.\e[m"
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@$(foreach val, $(ADDITIONALS), ln -sfnv $(abspath $(val)) $(HOME)/$(notdir $(val));)

	@# SSH config
	@if [[ ! -d ${HOME}/.ssh ]]; then mkdir $(HOME)/.ssh; fi
	@echo -e "\e[30;42mDeploy SSH config files\e[m"
	@ln -sfnv $(abspath $(DOTPATH)/.local/.ssh/bitbucket) $(HOME)/.ssh/bitbucket
	@ln -sfnv $(abspath $(DOTPATH)/.local/.ssh/github) $(HOME)/.ssh/github
	@ln -sfnv $(abspath $(DOTPATH)/.local/.ssh/config) $(HOME)/.ssh/config
	@echo -e "\e[40;35mSet valid permission for SSH config files"
	@chmod -c 600 $(DOTPATH)/.local/.ssh/{github,bitbucket}/id_rsa
	@# Golang
	@echo 'Make directory for Golang.'
	@mkdir -p $(HOME)/Golang/{src,bin}
	@mkdir -p ${HOME}/Golang/src/github.com/yasuto777

install: init deploy update ## Run make update, deploy
	@exec $$SHELL

init: ## Enable autostash
	@git config rebase.autostash true
	@sed -i -e 's/url.*/url = https:\/\/bitbucket\.org\/yasuto777\/dotfiles\.local\.git/g' $(DOTPATH)/.gitmodules
	@git submodule sync
	@git submodule init
	@git submodule update
	@sed -i -e 's/url.*/url = git@bitbucket\.org:yasuto777\/dotfiles\.local\.git/g' $(DOTPATH)/.gitmodules
	@git submodule sync

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

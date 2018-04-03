# vim: noexpandtab ft=make
DOTPATH     := $(realpath $(HOME)/dotfiles)
CANDIDATES  := $(wildcard .??*)
EXCLUSIONS  := .DS_Store .git .gitconfig
ADDITIONALS := etc/.gitconfig
DOTFILES    := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

# colors
BLACK       := \e[30m
RED         := \e[31m
GREEN       := \e[32m
YELLOW      := \e[33m
BLUE        := \e[34m
MAGENTA     := \e[35m
CYAN        := \e[36m
WHITE       := \e[37m
RESET_COLOR := \e[m

.DEFAULT_GOAL := help
.PHONY: all

list: ## Show dotfiles in this repo
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

deploy: ## Create Symlink to home directory
	@echo -e "$(GREEN)Create symlinks in your home directory.$(RESET_COLOR)"
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@$(foreach val, $(ADDITIONALS), ln -sfnv $(abspath $(val)) $(HOME)/$(notdir $(val));)

	@# Golang
	@echo 'Make directory for Golang.'
	@mkdir -p $(HOME)/go/{src,bin}
	@mkdir -p ${HOME}/go/src/github.com/yasuto777

install: init deploy update ## Run make update, deploy
	@exec $$SHELL

init: ## Enable autostash
	# autostash option is available Git 1.8.4 or later
	@git config rebase.autostash true

update: ## Fetch changes for this repo
	@git fetch
	@git rebase --autostash origin master

clean: ## Unlink dotfiles
	@echo "$(RED)Clean home directory...$(RESET_COLOR)"
	@-$(foreach val, $(DOTFILES), unlink $(HOME)/$(val);)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

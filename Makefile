# vim: noexpandtab ft=make
DOTPATH     := $(realpath $(HOME)/dotfiles)
CANDIDATES  := $(wildcard .??*)
EXCLUSIONS  := .DS_Store .git .gitconfig .gitignore .gitmodules
ADDITIONALS := etc/.gitconfig etc/.gitignore
DOTFILES    := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
DIRCOLORS   = .dircolors

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

	# autostash option is available Git 1.8.4 or later
	@git config rebase.autostash true

	@# Golang
	@echo 'Make directory for Golang.'
	@mkdir -p $(HOME)/go/{src,bin}
	@mkdir -p ${HOME}/go/src/github.com/umasoya

install: deploy ansible ## Run make update, deploy
	@exec $$SHELL

ansible: ## Run ansible-playbook
	ansible-playbook -i $(DOTPATH)/ansible/hosts.yml $(DOTPATH)/ansible/main.yml

clean: ## Unlink dotfiles
	@echo "$(RED)Clean home directory...$(RESET_COLOR)"
	@-$(foreach val, $(DOTFILES), unlink $(HOME)/$(val);)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

dircolor:
	@if [ $(IS_LINUX) && "$(DIST)"=="Ubuntu" ]; then\
		echo "Linux && Ubuntu";\
	else\
		echo "Not Linux Or Not Ubuntu";\
	fi

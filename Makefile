# vim: noexpandtab ft=make
DOTPATH     := $(realpath $(HOME)/dotfiles)
CANDIDATES  := $(wildcard .??*)
EXCLUSIONS  := .DS_Store .git .gitconfig .gitignore .gitmodules .config
ADDITIONALS := etc/.gitconfig etc/.gitignore
CONFIGS		:= .config/sh .config/nvim
DOTFILES    := $(filter-out $(EXCLUSIONS), $(CANDIDATES))
DIRCOLORS   := .dircolors

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

	@if [ ! -d $(HOME)/.config ]; then\
		@echo "$(YELLOW)Create .config directory in your home directory.$(RESET_COLOR)" \
		@mkdir $(HOME)/.config; \
	fi

	@$(foreach val, $(ADDITIONALS), ln -sfnv $(abspath $(val)) $(HOME)/$(notdir $(val));)
	@$(foreach val, $(CONFIGS), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

	# call dircolors
	@make dircolors

dircolors: ## Create symlink .dircolors
	@if [ $(IS_LINUX) ] && [ "$(DIST)"=="Ubuntu" ]; then\
		ln -sfnv $(abspath $(addsuffix _wsl, $(DIRCOLORS))) $(HOME)/$(DIRCOLORS);\
	else\
		ln -sfnv $(abspath $(DIRCOLORS)) $(HOME)/$(DIRCOLORS);\
	fi

install: deploy ## Run make update, deploy
	@exec $$SHELL

clean: ## Unlink dotfiles
	@echo "$(RED)Clean home directory...$(RESET_COLOR)"
	@-$(foreach val, $(DOTFILES), unlink $(HOME)/$(val);)
	@-$(foreach val, $(ADDITIONALS), unlink $(HOME)/$(val);)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

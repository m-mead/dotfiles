.PHONY: neovim zsh tmux git

all: neovim zsh tmux git
	@echo "Done"

neovim:
	if [ $(shell uname) = "Darwin" ]; then brew install neovim; fi
	if [ ! -d $(HOME)/.config/nvim ]; then ln -s $(PWD)/nvim $(HOME)/.config/nvim; fi

zsh:
	if [ ! -d $(HOME)/.config/zsh ]; then ln -s $(PWD)/zsh $(HOME)/.config/zsh; fi
	if [ ! -f $(HOME)/.zshenv ]; then echo "#!/bin/env zsh" >> $(HOME)/.zshenv; echo "export ZDOTDIR=$(HOME)/.config/zsh" >> $(HOME)/.zshenv; fi

tmux:
	if [ $(shell uname) = "Darwin" ]; then brew install tmux; fi
	if [ ! -f $(HOME)/.tmux.conf ]; then ln -s $(PWD)/tmux/.tmux.conf $(HOME)/.tmux.conf; fi

git:
	if [ $(shell uname) = "Darwin" ]; then brew install git-lfs; git-lfs install; fi
	if [ ! -f $(HOME)/.gitconfig ]; then ln -s $(PWD)/git/.gitconfig $(HOME)/.gitconfig; fi

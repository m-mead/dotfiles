.PHONY: iterm2 neovim zsh tmux git helix

all: iterm2 neovim zsh tmux git
	@echo "Done"

iterm2:
	if [ $(shell uname) = "Darwin" ]; then \
		brew install iterm2; \
		brew tap homebrew/cask-fonts; \
		brew install font-fira-mono-nerd-font; \
	fi

neovim:
	if [ $(shell uname) = "Darwin" ]; then \
		brew install neovim; \
	fi
	if [ ! -d $(HOME)/.config/nvim ]; then \
		ln -s $(PWD)/nvim $(HOME)/.config/nvim; \
	fi

zsh:
	if [ $(shell uname) = "Darwin" ]; then \
		brew install neofetch; \
	fi
	if [ ! -d $(HOME)/.config/zsh ]; then \
		ln -s $(PWD)/zsh $(HOME)/.config/zsh; \
		echo "#!/bin/env zsh" >> $(HOME)/.zshenv; \
		echo "export ZDOTDIR=$(HOME)/.config/zsh" >> $(HOME)/.zshenv; \
	fi

tmux:
	if [ $(shell uname) = "Darwin" ]; then \
		brew install tmux; \
	fi
	if [ ! -f $(HOME)/.tmux.conf ]; then \
		ln -s $(PWD)/tmux/.tmux.conf $(HOME)/.tmux.conf; \
	fi

git:
	if [ $(shell uname) = "Darwin" ]; then \
		brew install git-lfs; \
		git-lfs install; \
	fi
	if [ ! -f $(HOME)/.gitconfig ]; then \
		ln -s $(PWD)/git/.gitconfig $(HOME)/.gitconfig; \
	fi

helix:
	if [ $(shell uname) = "Darwin" ]; then \
		brew install helix;
	fi
	if [ ! -d $(HOME)/.config/helix ]; then \
		ln -s $(PWD)/helix $(HOME)/.config/helix; \
	fi

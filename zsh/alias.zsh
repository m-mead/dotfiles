#!/bin/env zsh
# ----------------------------------------------------------------------------------------------------------------------
# zshell aliases
# ----------------------------------------------------------------------------------------------------------------------

# Grep
alias grep="grep --color=auto"

# Listing
alias l="ls --color=auto -A"
alias ls="ls --color=auto"
alias ll="ls --color=auto -lAh"

# Homebrew
if command -v brew &> /dev/null; then
    alias brew-install-head="brew install --head $2"
    alias brew-upgrade-head="brew upgrade $2 --fetch-HEAD"
fi

# Lazygit
if command -v lazygit &> /dev/null; then
    alias lg="lazygit"
fi

# Git
alias gs="git status"
alias gd="git diff"

# Python
alias actv=". venv/bin/activate"
alias actvn="python3 -m venv venv && . venv/bin/activate && pip install -U pip"

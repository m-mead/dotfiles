#!/bin/env zsh
# ----------------------------------------------------------------------------------------------------------------------
# zshell aliases
# ----------------------------------------------------------------------------------------------------------------------

# Ref: https://github.com/Mach-OS/Machfiles/blob/6373a1fd1e42ca2fd8babd95ef4acce9164c86c3/zsh/.config/zsh/zsh-aliases
alias zsh-update-plugins="find "$ZSH_PLUGIN_DIR" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"

alias grep="grep --color=auto"

alias l="ls --color=auto -A"
alias ls="ls --color=auto"
alias ll="ls --color=auto -lAh"

if command -v brew &> /dev/null; then
    alias brew-install-head="brew install --head $2"
    alias brew-upgrade-head="brew upgrade $2 --fetch-HEAD"
fi

if command -v lazygit &> /dev/null; then
    alias lg="lazygit"
fi

alias actv=". venv/bin/activate"
alias actvn="python3 -m venv venv && . venv/bin/activate && pip install -U pip"

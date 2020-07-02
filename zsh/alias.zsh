#!/bin/env zsh
# ----------------------------------------------------------------------------------------------------------------------
# zshell aliases
# ----------------------------------------------------------------------------------------------------------------------

# Ref: https://github.com/Mach-OS/Machfiles/blob/6373a1fd1e42ca2fd8babd95ef4acce9164c86c3/zsh/.config/zsh/zsh-aliases
alias zsh-update-plugins="find "$ZSH_PLUGIN_DIR" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"

alias grep="grep --color=auto"

alias ls="ls --color=auto -A"
alias ll="ls --color=auto -lAh"

alias actv=". venv/bin/activate"
alias actvn="python3 -m venv venv && . venv/bin/activate && pip install -U pip && pip install pyright"
alias actvN="rm -rf venv && python3 -m venv venv && . venv/bin/activate && pip install -U pip && pip install pyright"

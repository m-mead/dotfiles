#!/bin/env zsh

setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
zle_highlight=('paste:none')

autoload -Uz compinit
zstyle ':completion:*' menu select

zmodload zsh/complist

_comp_options+=(globdots)

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

autoload -Uz colors && colors

source "$ZDOTDIR/func.zsh"

zsh_add_file "path.zsh"
zsh_add_file "export.zsh"
zsh_add_file "alias.zsh"
zsh_add_file "prompt.zsh"
zsh_add_file "keybindings.zsh"
zsh_add_file "fzf.zsh"
zsh_add_file "nvm.zsh"

compinit

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

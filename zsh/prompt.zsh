#!/bin/env zsh

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn

# Branch symbol: \UE0A0
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%{%F{green}%B%}●%{%b%f%}'
zstyle ':vcs_info:*' unstagedstr '%{%F{red}%B%}●%{%b%f%}'
zstyle ':vcs_info:git*' formats $' \UE0A0%u%c'

precmd() {
    vcs_info
}

setopt prompt_subst

PROMPT='[%F{blue}%n:%m] %1~%F{34}${vcs_info_msg_0_}%F{white} '%F{208}$'\U03BB %f%k'

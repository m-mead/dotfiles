#!/bin/env zsh

# Ref: https://github.com/Mach-OS/Machfiles/blob/6373a1fd1e42ca2fd8babd95ef4acce9164c86c3/zsh/.config/zsh/zsh-functions
function zsh_add_file() {
    [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

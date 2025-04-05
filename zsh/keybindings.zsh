# Ctrl+arrow
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Vim
bindkey -v

function zle-keymap-select {
  case $KEYMAP in
    vicmd)      echo -ne '\e[1 q' ;;
    viins|main) echo -ne '\e[5 q' ;;
  esac
}

function zle-line-init {
  zle-keymap-select
}

zle -N zle-keymap-select
zle -N zle-line-init


function zle-line-init {
  zle-keymap-select
}

zle -N zle-keymap-select
zle -N zle-line-init

# fzf
if [ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [ -x "$(command -v fzf)" ]; then
    source <(fzf --zsh)
else
    bindkey '^R' history-incremental-search-backward
fi

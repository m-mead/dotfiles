bindkey '^R' history-incremental-search-backward

# Vim keybindings
bindkey -v

# Block cursor on normal mode; line on insert
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

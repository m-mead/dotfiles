if [[ "$(uname)" == "Darwin" ]]; then
    if [ -x "$(command -v fzf)" ]; then
        if [ -x "$(command -v fd)" ]; then
            export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'
        fi

        source "/usr/local/opt/fzf/shell/completion.zsh"
        source "/usr/local/opt/fzf/shell/key-bindings.zsh"
    fi
fi
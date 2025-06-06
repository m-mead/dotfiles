# pipx
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# Go
if [ -d "$HOME/go/bin" ]; then
    export PATH="$PATH:$HOME/go/bin"
fi

if [ -d "/usr/local/go/bin" ]; then
    export PATH="$PATH:/usr/local/go/bin"
fi

# Ruby
if [ -d "$HOME/.rbenv" ]; then
    eval "$(rbenv init -)"
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

if [ -d "$HOME/src/dotfiles/bin" ]; then
    export PATH="$PATH:$HOME/src/dotfiles/bin"
fi

# fzf
if [[ "$(uname)" == darwin* ]]; then
    # fzf
    if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
        PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
    fi

    # Homebrew sbin
    if [[ ! "$PATH" == */usr/local/sbin* ]]; then
        export PATH="/usr/local/sbin:$PATH"
    fi
fi

# docker
if [ -d "/usr/local/lib/docker/cli-plugins/" ]; then
    export PATH=$PATH:/usr/local/lib/docker/cli-plugins
fi

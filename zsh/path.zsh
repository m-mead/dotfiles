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

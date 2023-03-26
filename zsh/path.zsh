# pipx
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# Go
if [ -f "$HOME/go/bin" ]; then
    export PATH="$PATH:$HOME/go/bin"
fi

# Ruby
if [ -d "$HOME/.rbenv" ]; then
    eval "$(rbenv init -)"
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

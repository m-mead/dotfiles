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
    eval "$(rbenv init - zsh)"
fi

# Rust
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Dotfiles
if [ -d "$HOME/src/dotfiles/bin" ]; then
    export PATH="$PATH:$HOME/src/dotfiles/bin"
fi

# Fzf
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
    PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Homebrew
if [[ -d "/opt/homebrew/bin" ]]; then
    export PATH="$PATH:/opt/homebrew/bin"
fi

# Docker
if [ -d "/usr/local/lib/docker/cli-plugins/" ]; then
    export PATH=$PATH:/usr/local/lib/docker/cli-plugins
fi

# Pyenv
if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

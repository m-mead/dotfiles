#!/usr/bin/env bash

function symlink_dir_if_not_present() {
    if [[ ! -L "${2}" && ! -d "${2}" ]]; then
        echo "symlinking ${1} -> ${2}"
        ln -s ${1} ${2}
    fi
}

function symlink_file_if_not_present() {
    if [[ ! -L "${2}" && ! -f "${2}" ]]; then
        echo "symlinking ${1} -> ${2}"
        ln -s ${1} ${2}
    fi
}

function install_macos() {
    if [ -x "$(command -v brew)" ]; then
        echo -e "homebrew not found, cannot continue with installation"
        exit 1
    fi

    brew install lazygit
    brew install tmux
    brew install bat
    brew install fd
    brew install fzf
    brew install git-lfs
    brew install go
    brew install nvm
    brew install pipx

    brew install --cask wezterm
    brew install --head neovim

    brew tap homebrew/cask-fonts
    brew install font-fira-code-nerd-font
    brew install font-jetbrains-mono-nerd-font

    install_rust

    install_dotfiles
}

function install_linux() {
    install_rust

    install_dotfiles
}

function install_rust() {
    if [ ! -x "$(command -v cargo)" ]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
}

function install_dotfiles() {
    symlink_dir_if_not_present ${PWD}/emacs ${HOME}/.config/emacs
    symlink_dir_if_not_present ${PWD}/nvim ${HOME}/.config/nvim
    symlink_dir_if_not_present ${PWD}/wezterm ${HOME}/.config/wezterm

    symlink_dir_if_not_present ${PWD}/zsh ${HOME}/.config/zsh

    if [[ ! -z "${ZDOTDIR}" ]]; then
        echo "export ZDOTDIR=${HOME}/.config/zsh" >> ${HOME}/.zshenv
    fi

    symlink_file_if_not_present ${PWD}/git/.gitconfig ${HOME}/.gitconfig
    symlink_file_if_not_present ${PWD}/tmux/.tmux.conf ${HOME}/.tmux.conf
}

function usage() {
    echo "Usage:"
    echo "  setup_dev_env [--macos] [--linux]"
    echo "Options:"
    echo "  --macos     Install macos packages"
    echo "  --linux     Install linux packages"
    echo "  --rust      Install rust"
    echo "  --dotfiles  Install dotfiles"
}

if [[ -z "$1" ]]; then
    usage
    exit 1
fi

for arg in "$@"; do
    case $arg in
        --macos)
            install_macos
            shift
            ;;
        --linux)
            install_linux
            shift
            ;;
        --rust)
            install_rust
            shift
            ;;
        --dotfiles)
            install_dotfiles
            shift
            ;;
        --help)
            usage
            exit 0
            shift
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

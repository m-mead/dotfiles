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
    if [ ! -x "$(command -v brew)" ]; then
        echo -e "homebrew not found, cannot continue with installation"
        exit 1
    fi

    brew install coreutils
    brew install git-lfs
    brew install go
    brew install pipx
    brew install tmux

    brew install --cask wezterm
    brew install --head neovim

    brew tap homebrew/cask-fonts
    brew install font-fira-code-nerd-font
    brew install font-jetbrains-mono-nerd-font

    install_rust

    install_go

    install_dotfiles
}

function install_linux() {
    install_rust

    install_go

    install_dotfiles
}

function install_rust() {
    if [ ! -x "$(command -v rustup)" ]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
    fi

    rustup update

    source ${HOME}/.cargo/env
    cargo install fd-find
    cargo install bat
    cargo install ripgrep
}

function install_go() {
    if [ ! -x "$(command -v go)" ]; then
        wget https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
        rm -rf /usr/local/go
        tar -C /usr/local -xzf go1.22.2.linux-amd64.tar.gz
        rm go1.22.2.linux-amd64.tar.gz
    fi

    PATH=${PATH}:/usr/local/go/bin
    go install github.com/junegunn/fzf@latest
    go install github.com/jesseduffield/lazygit@latest
}

function install_neovim() {
    if [ ! -x "$(command -v nvim)" ]; then
        mkdir -p deps
        pushd deps

        git clone https://github.com/neovim/neovim.git
        cd neovim
        make CMAKE_BUILD_TYPE=RelWithDebInfo
        sudo make install

        popd
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
    echo "  setup_dev_env [--macos] [--linux] [--dotfiles]"
    echo "Options:"
    echo "  --macos     Install macos packages"
    echo "  --linux     Install linux packages"
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

export NVM_DIR="$HOME/.nvm"

if [ -f "${NVM_DIR}/nvm.sh" ]; then
    . ${NVM_DIR}/nvm.sh
fi

if [ -f "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    . "/opt/homebrew/opt/nvm/nvm.sh"
fi

if [[ $(uname) == "Darwin" ]]; then
    source /Users/jackhamilton/.config/broot/launcher/bash/br
elif command -v pacman > /dev/null; then
    export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
fi
export PATH="$PATH:/home/jack/.local/bin"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/opt/homebrew/bin:$PATH"

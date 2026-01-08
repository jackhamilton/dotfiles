if [[ $(uname) == "Darwin" ]]; then
    source /Users/jackhamilton/.config/broot/launcher/bash/br
elif command -v pacman > /dev/null; then
    export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
fi
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
export PATH="$PATH:/home/jack/.local/bin"
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

source /home/jack/Documents/GitHub/godot/emsdk/emsdk_env.sh &> /dev/null

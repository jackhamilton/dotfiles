if [[ $OSTYPE == darwin* ]]; then
    export PATH="$PATH:/Users/jackhamilton/.cargo/bin"
elif [[ -x /usr/bin/pacman ]]; then
    export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
fi

export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
export PATH="$PATH:/home/jack/.local/bin"
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

if [[ $OSTYPE != darwin* && -r /home/jack/Documents/GitHub/godot/emsdk/emsdk_env.sh ]]; then
    source /home/jack/Documents/GitHub/godot/emsdk/emsdk_env.sh &>/dev/null
fi

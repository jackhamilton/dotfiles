if (( $+commands[bw] )); then
    credfile="$HOME/bitwarden.cred"
    while IFS=: read -r line
    do
        if [[ $line != "" ]]; then
            if [[ $line == *"user"* ]]; then
                export BW_CLIENTID=$line
            elif [[ $line == *"wegs"* ]]; then
                export BW_CLIENTSECRET=$line
            else
                BW_PASS=$line
            fi
        fi
        if [[ $line != "" ]]; then
        fi
    done <"$credfile"
    export BW_SESSION=$(bw unlock $BW_PASS --raw);
fi

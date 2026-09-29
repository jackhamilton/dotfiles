# Rustup / Cargo
zinit ice id-as"rustup-completion" has"rustup" \
    atclone'rustup completions zsh cargo > _cargo' atpull'%atclone' \
    atload'fpath+=( $PWD )' \
    as"completion" nocompile'!'
zinit light zdharma-continuum/null

# Git's zsh completion delegates the detailed candidate generation to Git's
# Bash completion script, so keep both files together as one cached completion.
zinit ice id-as"git-completion" \
    atclone'curl -fsSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh > _git && curl -fsSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > git-completion.bash' \
    atpull'%atclone' \
    atload'fpath+=( $PWD ); zstyle ":completion:*:*:git:*" script "$PWD/git-completion.bash"' \
    nocompile'!'
zinit light zdharma-continuum/null

# Sass
zinit ice id-as"sass-completion" has"sass" \
    atclone'sass --completions > _sass' atpull'%atclone' \
    atload'fpath+=( $PWD )' \
    as"completion" nocompile'!'
zinit light zdharma-continuum/null

# Jujutsu (jj)
zinit ice id-as"jj-completion" has"jj" \
    atclone'jj util completion zsh > _jj' atpull'%atclone' \
    atload'fpath+=( $PWD )' \
    as"completion" nocompile'!'
zinit light zdharma-continuum/null

# Skim (sk)
zinit ice wait"0b" lucid id-as"sk-completion" has"sk" nocompile'!' \
    atload'eval "$(sk --shell zsh)"'
zinit light zdharma-continuum/null

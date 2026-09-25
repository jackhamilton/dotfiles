# Load the interactive plugins first. Completion definitions are registered
# before the completion plugin is loaded, so zsh-completions is initialized
# separately after those definitions are available.
zinit wait lucid for \
        zdharma-continuum/fast-syntax-highlighting \
        OMZP::alias-finder \
        zpm-zsh/undollar \
        chisui/zsh-nix-shell \
        jeffreytse/zsh-vi-mode \

zinit ice wait"0b" lucid blockf atload'zicompinit; zicdreplay'
zinit light zsh-users/zsh-completions

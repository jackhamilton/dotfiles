ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

source ~/.config/zsh/env.zsh

# Shell behavior
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt interactivecomments

export EDITOR='nvim'
export VISUAL='nvim'

# Shell configuration
source ~/.config/zsh/completion.zsh

source ~/.config/zsh/plugins.zsh
source ~/.config/zsh/alias.zsh

[[ -r ~/.config/themester/.themecache ]] && source ~/.config/themester/.themecache

if [[ $OSTYPE != darwin* && -f /home/jack/.ghcup/env ]]; then
    source /home/jack/.ghcup/env
fi

source ~/.config/zsh/direnv-instant.zsh

# Generated shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"


znap source marlonrichert/zsh-autocomplete

#ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
ZSH_AUTOSUGGEST_STRATEGY=(history)
znap source zsh-users/zsh-autosuggestions

znap source zsh-users/zsh-syntax-highlighting

znap source akash329d/zsh-alias-finder
lsdloc=$(which lsd)
AUTO_LS_COMMANDS=(git-status $lsdloc)
znap source desyncr/auto-ls
znap source zpm-zsh/undollar
znap source jeffreytse/zsh-vi-mode
#znap source Junker/zsh-archlinux@main
themer

znap install zsh-users/zsh-completions

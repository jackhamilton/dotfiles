zstyle ':znap:*' repos-dir ~/.znap/Repos/

lsdloc=$(which lsd)
AUTO_LS_COMMANDS=(git-status $lsdloc)
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)

znap source zsh-users/zsh-syntax-highlighting
znap source akash329d/zsh-alias-finder
#znap source Junker/zsh-archlinux@main
znap source desyncr/auto-ls
znap source zpm-zsh/undollar
znap source jeffreytse/zsh-vi-mode
znap source zsh-users/zsh-autosuggestions
znap source marlonrichert/zsh-autocomplete

znap install aureliojargas/clitest zsh-users/zsh-completions

source ~/.znap/Repos/marlonrichert/zsh-autocomplete/zsh-autocomplete.plugin.zsh

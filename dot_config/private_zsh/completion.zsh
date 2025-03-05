if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

if command -v rustup > /dev/null; then
    znap fpath _cargo 'rustup completions zsh cargo'
fi


FPATH="${HOME}/.config/zsh/completions:${FPATH}"

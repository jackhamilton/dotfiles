# if type brew &>/dev/null
# then
#   FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
# fi

if command -v rustup > /dev/null; then
    znap fpath _cargo 'rustup completions zsh cargo'
fi

if command -v sass > /dev/null; then
    znap fpath _sass 'sass --completions'
fi

if command -v sk > /dev/null; then
    znap fpath _skim 'sk --shell zsh'
fi

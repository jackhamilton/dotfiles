# Register cached completion generators without scanning PATH at startup.
[[ -x ~/.cargo/bin/rustup ]] && znap fpath _cargo 'rustup completions zsh cargo'
znap fpath _sass 'sass --completions'
znap fpath _skim 'sk --shell zsh'
znap fpath _jj 'jj util completion zsh'

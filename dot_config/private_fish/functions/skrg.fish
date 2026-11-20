function skrg --description 'Search repository lines interactively with skim'
    command sk --ansi -i -c 'rg --color=always --line-number {}' $argv
end

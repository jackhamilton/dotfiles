function gitup --description 'Add, commit, and push the current repository'
    command git add .
    or return $status
    command git commit -m "$argv[1]"
    or return $status
    command git push
end

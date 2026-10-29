function jjbranch --description 'Create and track a Jujutsu bookmark'
    command jj bookmark create "$argv[1]"
    and command jj bookmark track "$argv[1]"
end

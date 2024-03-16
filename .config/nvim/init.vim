set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

lua require("lazy-config")
lua require("lazy").setup('user.plugins')
lua require('user/init')
lua require ('user/lsp')

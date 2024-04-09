set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" THEMES
if (has("termguicolors"))
    set termguicolors
endif

lua require("lazy-config")
lua require("lazy").setup('user.plugins')
lua require('user')
lua require ('user/lsp')

let g:nvcode_termcolors = 256
let g:sonokai_style = 'default'
syntax on
colorscheme sonokai
" colorscheme nordfox

lua require('user/ui')

set autoindent
set smartindent
set ignorecase
set autowrite
"set expandtab

set number
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-n> :Neotree<Enter>

"autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })

TSContextEnable

filetype plugin indent on

" THEMES
if (has("termguicolors"))
    set termguicolors
endif

colorscheme sonokai
let g:nvcode_termcolors = 256
let g:sonokai_style = 'default'
"syntax on

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

filetype plugin indent on
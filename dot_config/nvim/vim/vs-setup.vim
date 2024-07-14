" THEMES
let g:nvcode_termcolors = 256
let g:sonokai_style = 'default'
"syntax on

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

filetype plugin on

runtime vim/platform.vim

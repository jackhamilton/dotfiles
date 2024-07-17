" THEMES
let g:nvcode_termcolors = 256
let g:sonokai_style = 'default'
"syntax on
"

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

filetype plugin on

runtime vim/platform.vim

nnoremap m h
nnoremap h m
nnoremap j n
nnoremap n j
nnoremap e k
nnoremap k e
nnoremap i l
nnoremap l i
vnoremap m h
vnoremap h m
vnoremap j n
vnoremap n j
vnoremap e k
vnoremap k e
vnoremap i l
vnoremap l i
nnoremap M H
nnoremap H M
nnoremap J N
nnoremap N J
nnoremap E K
nnoremap K E
nnoremap I L
nnoremap L I
vnoremap M H
vnoremap H M
vnoremap J N
vnoremap N J
vnoremap E K
vnoremap K E
vnoremap I L
vnoremap L I

" Platform identification {
    silent function! OSX()
        return has('macunix')
    endfunction
    silent function! LINUX()
        return has('unix') && !has('macunix') && !has('win32unix')
    endfunction
    silent function! WINDOWS()
        return  (has('win16') || has('win32') || has('win64'))
    endfunction
    silent function! UNIXLIKE()
        return !WINDOWS()
    endfunction
    silent function! FREEBSD()
      let s:uname = system("uname -s")
      return (match(s:uname, 'FreeBSD') >= 0)
    endfunction
" }

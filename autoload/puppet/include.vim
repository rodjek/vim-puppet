function! puppet#include#IncludeExpr(fname) abort
    " Remove puppet 3.x style leading :: since they mean nothing for the path
    let l:fname = substitute(a:fname, '^::', '', '')

    " If we can't find a second element, then we're referring to the init.pp
    " file
    if match(l:fname, '::') < 0
        return 'init'
    endif

    " Remove first element. It'll make finding files easier since the module
    " name might not be in the find path.
    let l:fname = substitute(l:fname,'^[^:]\+::','','')

    " Replace all subsequent :: in order to get a real file path
    let l:fname = substitute(l:fname,'::','/','g')

    return l:fname
endfunction

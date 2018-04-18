if !exists('g:gutentags_enabled' && g:gutentags_dont_load != 0 )
    finish
endif

call add(g:gutentags_project_info, {'type': 'puppet', 'file': 'Puppetfile'})

let s:ctags_options = puppet#ctags#OptionFile()
call add(g:gutentags_ctags_extra_args, '--options=' . s:ctags_options)
unlet s:ctags_options


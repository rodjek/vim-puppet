if (!exists('g:gutentags_enabled') && (!exists('g:gutentags_dont_load') || g:gutentags_dont_load != 0 ))
    finish
endif

call add(g:gutentags_project_info, {'type': 'puppet', 'file': 'Puppetfile'})

let s:ctags_options = puppet#ctags#OptionFile()
if exists('g:gutentags_ctags_extra_args')
    call add(g:gutentags_ctags_extra_args, '--options=' . s:ctags_options)
else
    let g:gutentags_ctags_extra_args = ['--options=' . s:ctags_options]
endif
unlet s:ctags_options


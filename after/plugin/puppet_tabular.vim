if !exists('g:puppet_align_classes')
    let g:puppet_align_classes = 1
endif

if exists(':AddTabularPipeline') && g:puppet_align_classes
    " The function is filtering definition by '$' symbol, then applies tabular to
    " payload and join again. Source for this taken from
    " https://unix.stackexchange.com/questions/35787/indent-the-middle-of-multiple-lines
    function! AlignPuppetClass(lines)
        " List of payload, should contain '$' AND not contain '=>'
        let attributes = map(copy(a:lines), '(v:val =~ "[$]" && v:val !~ "=>") ? v:val : ""')
        " List of noise, may be without '$' or with '=>'
        let noise = map(copy(a:lines), '(v:val !~ "[$]" || v:val =~ "=>") ? v:val : ""')
        " Splitting only by first '$attribute' and '='
        call tabular#TabularizeStrings(attributes, '^[^$]*\zs\s\+\$\w\+\>\|=', 'l0l1')
        call map(a:lines, 'remove(attributes, 0) . remove(noise, 0)')
    endfunction

    " The class definition could be interrupted with enum's multiline, selectors
    " or whatever else, so tabular will search for any of `${['",#` symbols and
    " pass them into AlignPuppetClass function
    au FileType puppet AddTabularPipeline! puppet_class /[${['",#]/ AlignPuppetClass(a:lines)
    au FileType puppet inoremap <buffer> <silent> ,<CR> ,<Esc>:Tabularize puppet_class<CR>o
    " A comma should be at the last position in the line that's why 'norm A'
    " is enough in this case
    au FileType puppet inoremap <buffer> <silent> ,, ,<Esc>:Tabularize puppet_class<CR>A
endif

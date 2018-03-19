if !exists('g:puppet_align_classes')
    let g:puppet_align_classes = 1
endif
if !exists('g:puppet_align_hashes')
    let g:puppet_align_hashes = 1
endif

if exists(':AddTabularPipeline')
    " The function for an aligning each block of selectors separately
    function! AlignSelectorsByBlock(lines)
        let i = 0
        let blStart = 0
        let blocks = {}
        " Write each block of selectors to dict {'idx_of_block_start':
        " ['selector', 'strings']}
        while i < len(a:lines)
            if a:lines[i] == ''
                let i += 1
                continue
            endif
            if i == 0 || a:lines[i-1] == ''
                " Start new block
                let blStart = i
                let blocks[blStart] = [a:lines[i]]
                let i += 1
                continue
            else
                " Or append to existing
                let blocks[blStart] += [a:lines[i]]
                let i += 1
                continue
            endif
        endwhile
        " Align each block separately and write back to selectors list
        for k in keys(blocks)
            call tabular#TabularizeStrings(blocks[k], '=>')
            for str in blocks[k]
                let a:lines[k] = str
                let k += 1
            endfor
        endfor
    endfunction


    " The function is filtering definition by '$' or '=>', then applies tabular to
    " payload and join again. Source for this taken from
    " https://unix.stackexchange.com/questions/35787/indent-the-middle-of-multiple-lines
    function! AlignPuppetClass(lines)
        " List of payload, must contain '$' AND not contain '=>', ignore
        " comments lines
        let attributes = map(copy(a:lines), '(v:val =~ "[$]" && v:val !~ "=>" && v:val !~ "^\s*#") ? v:val : ""')
        " List of selectors, each block will be aligned separately, ignore
        " comments lines
        let selectors = map(copy(a:lines), '(v:val =~ "=>" && v:val !~ "^\s*#")? v:val : ""')
        " List of noise, haven't '$' or '=>'. Also comments
        let noise = map(copy(a:lines), '(v:val !~ "[$]" && v:val !~ "=>" || v:val =~ "^\s*#") ? v:val : ""')
        if g:puppet_align_hashes
            call AlignSelectorsByBlock(selectors)
        endif
        " Splitting by first '$attribute' and '='
        if g:puppet_align_classes
            call tabular#TabularizeStrings(attributes, '\v^[^$]*\zs\s*\$\w+(>|,?)|\=', 'l1l0r1')
        endif
        call map(a:lines, 'remove(attributes, 0) . remove(noise, 0) . remove(selectors, 0)')
    endfunction

    " The class definition could be interrupted with enum's multiline, selectors
    " or whatever else, so tabular will search for any of `${['",#` symbols and
    " pass them into AlignPuppetClass function
    au FileType puppet AddTabularPipeline! puppet_class /[$}['",#]/ AlignPuppetClass(a:lines)
    au FileType puppet inoremap <buffer> <silent> <CR> <Esc>:Tabularize puppet_class<CR>o
endif

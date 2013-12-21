inoremap <buffer> <silent> > ><Esc>:call <SID>puppetalign()<CR>A
function! s:puppetalign()
    let p = '^\s*\w+\s*[=+]>.*$'
    let lineContainsHashrocket = getline('.') =~# '^\s*\w+\s*[=+]>'
    let hashrocketOnPrevLine = getline(line('.') - 1) =~# p
    let hashrocketOnNextLine = getline(line('.') + 1) =~# p
    if exists(':Tabularize') " && lineContainsHashrocket && (hashrocketOnPrevLine || hashrocketOnNextLine)
        Tabularize /=>/l1
        normal! 0
    endif
endfunction

function! s:puppet_gf()
  let puppet_root = ""
  let word = matchstr(getline('.'), "'".'puppet:///\zsmodules.*\ze'."'")
  let fn = fnamemodify(expand('%'), ":p")
  let old_fn = ""

  " Find the puppet root, if any
  while fn != old_fn
    let old_fn = fn
    let fn = fnamemodify(fn, ":h")

    " If there is a hiera-data directory, we can assume that this is the root.
    " TODO: Maybe optionally use a global variable for where the root is?
    if isdirectory(fn . '/hiera-data')
      let puppet_root = fn
      break
    endif
  endwhile

  if puppet_root != "" && word != ""
    " Insert the puppet root and the 'files' directory
    let spl = split(word, '/')
    let spl = insert(spl, puppet_root)
    let spl = insert(spl, 'files', 3)

    " Join it back and return it
    return join(spl, '/')
  endif

  " The normal return value of gf. Return it in case something goes wrong.
  " This is not perfect, but something.
  return expand('<cWORD>')
endfunction

nmap <buffer> <silent> gf :edit `=<SID>puppet_gf()`<cr>
nmap <buffer> <silent> <c-w>f :split `=<SID>puppet_gf()`<cr>

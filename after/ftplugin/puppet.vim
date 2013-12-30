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
  let ret = []
  let line = getline('.')
  let puppet_root = ""
  let url = matchstr(line, "'puppet:///\\zsmodules.*\\ze'")
  let template = matchstr(line, "template('\\zs.*\\ze')")

  let fn = fnamemodify(expand('%'), ":p")
  let old_fn = ""

  " Scan upwards to find the puppet root
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

  " The normal return value of gf. Return it in case no puppet root was found.
  " This is not perfect, but something.
  if puppet_root == ''
    return expand('<cWORD>')
  endif

  " Insert the puppet root and the path to the selected module's
  " files/ or templates/
  if url != ""
    let spl = split(url, '/')
    let ret = [puppet_root] + spl[:1] + ['files'] + spl[2:]
  elseif template != ""
    let spl = split(template, '/')
    let ret = [puppet_root, 'modules', spl[0], 'templates'] + spl[1:]
  endif

  return join(ret, '/')
endfunction

nmap <buffer> <silent> gf :edit `=<SID>puppet_gf()`<cr>
nmap <buffer> <silent> <c-w>f :split `=<SID>puppet_gf()`<cr>

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

function! s:puppet_gf(cmd)
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

  " Insert the puppet root and the path to the selected module's
  " files/ or templates/
  if puppet_root != ''
    if url != ""
      let spl = split(url, '/')
      let ret = [puppet_root] + spl[:1] + ['files'] + spl[2:]
    elseif template != ""
      let spl = split(template, '/')
      let ret = [puppet_root, 'modules', spl[0], 'templates'] + spl[1:]
    endif
  endif

  " No puppet root or match. Fallback to default behaviour!
  if puppet_root == '' || empty(ret)
    normal! gf
    return
  endif

  exe a:cmd join(ret, "/")
endfunction

nmap <buffer> <silent> gf :call <SID>puppet_gf('edit')<cr>
nmap <buffer> <silent> <c-w>f :call <SID>puppet_gf('split')<cr>

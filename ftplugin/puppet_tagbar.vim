" Puppet set up for Tagbar plugin
" (https://github.com/majutsushi/tagbar).

if !exists(':Tagbar')
    finish
endif

let s:ctags_version = system('ctags --version')
let g:tagbar_type_puppet = {
  \ 'ctagstype': 'puppet',
  \ 'kinds': [
    \ 'c:Classes',
    \ 's:Sites',
    \ 'n:Nodes',
    \ 'v:Variables',
    \ 'i:Includes',
    \ 'd:Definitions',
    \ 'r:Resources',
    \ 'f:Defaults',
    \ 't:Types',
    \ 'u:Functions',
  \],
\}

if s:ctags_version =~ 'Universal Ctags'
    " There no sense to split objects by colon
    let g:tagbar_type_puppet.sro = '__'
    let g:tagbar_type_puppet.kind2scope = {
      \ 'd': 'definition',
      \ 'c': 'class',
      \ 'r': 'resource',
      \ 'i': 'include',
      \ 'v': 'variable',
    \}
    let g:tagbar_type_puppet.scope2kind = {
      \ 'definition' : 'd',
      \ 'class'      : 'c',
      \ 'resource'   : 'r',
      \ 'include'    : 'i',
      \ 'variable'   : 'v',
    \}
    let g:tagbar_type_puppet.deffile = expand('<sfile>:p:h:h') . '/ctags/puppet_u.ctags'
elseif s:ctags_version =~ 'Exuberant Ctags'
    let g:tagbar_type_puppet.deffile = expand('<sfile>:p:h:h') . '/ctags/puppet.ctags'
endif

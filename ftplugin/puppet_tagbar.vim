" Puppet set up for Tagbar plugin
" (https://github.com/majutsushi/tagbar).

if !exists(':Tagbar')
    finish
endif

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
    \ 'f:Defaults'
  \],
    \ 'deffile'   : expand('<sfile>:p:h:h') . '/ctags/puppet.ctags',
\}

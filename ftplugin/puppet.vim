" Vim filetype plugin
" Language:             Puppet
" Maintainer:           Tim Sharpe <tim@sharpe.id.au>
" URL:                  https://github.com/rodjek/vim-puppet
" Last Change:          2019-08-31

if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab
setlocal keywordprg=puppet\ describe\ --providers
setlocal iskeyword=:,@,48-57,_,192-255
setlocal comments=sr:/*,mb:*,ex:*/,b:#
setlocal commentstring=#\ %s

setlocal formatoptions-=t formatoptions+=croql
setlocal formatexpr=puppet#format#Format()

setlocal suffixesadd=.pp
setlocal include=\\v^\\s*(include\|contain\|class\\s+\\\{\|Class\\s+\\\[)\\s+[\"\']?\\zs(\\f\|::)+
setlocal includeexpr=puppet#include#IncludeExpr(v:fname)

let b:undo_ftplugin = "
    \ setlocal tabstop< tabstop< softtabstop< shiftwidth< expandtab<
    \| setlocal keywordprg< iskeyword< comments< commentstring<
    \| setlocal formatoptions< formatexpr<
    \| setlocal suffixesadd< include< includeexpr<
    \"

" Vim filetype plugin
" Language:             Puppet
" Maintainer:           Tim Sharpe <tim@sharpe.id.au>
" URL:                  https://github.com/rodjek/vim-puppet
" Last Change:          2019-08-31

if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

setl ts=2
setl sts=2
setl sw=2
setl et
setl keywordprg=puppet\ describe\ --providers
setl iskeyword=-,:,@,48-57,_,192-255
setl cms=#\ %s

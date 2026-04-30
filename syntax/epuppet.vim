" Vim syntax plugin
" Language:             embedded puppet
" Maintainer:           Gabriel Filion <gabster@lelutin.ca>
" URL:                  https://github.com/rodjek/vim-puppet
" Last Change:          2019-09-01

" since this filetype can be loaded along a subtype, don't test with b:current_syntax
if (exists('b:current_syntax') && b:current_syntax ==# 'epuppet')
  finish
endif

unlet! b:current_syntax
syn include @puppetTop syntax/puppet.vim

syn cluster ePuppetRegions contains=ePuppetBlock,ePuppetExpression,ePuppetComment

syn region  ePuppetBlock      matchgroup=ePuppetDelimiter start="<%%\@!-\=" end="[=-]\=%\@<!%>" contains=@puppetTop  containedin=ALLBUT,@ePuppetRegions keepend
syn region  ePuppetExpression matchgroup=ePuppetDelimiter start="<%=\{1,4}" end="[=-]\=%\@<!%>" contains=@puppetTop  containedin=ALLBUT,@ePuppetRegions keepend
syn region  ePuppetComment    matchgroup=ePuppetDelimiter start="<%-\=#"    end="[=-]\=%\@<!%>" contains=puppetTodo,@Spell containedin=ALLBUT,@ePuppetRegions keepend

" Define the default highlighting.

hi def link ePuppetDelimiter              PreProc
hi def link ePuppetComment                Comment

let b:current_syntax = 'epuppet'

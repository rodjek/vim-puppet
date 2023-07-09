" Vim syntax plugin
" Language:             embedded puppet
" Maintainer:           Gabriel Filion <gabster@lelutin.ca>
" URL:                  https://github.com/rodjek/vim-puppet
" Last Change:          2019-09-01

" quit when a syntax file was already loaded {{{1
if exists('b:current_syntax')
  finish
endif

if exists('b:original_filetype')
    runtime! syntax/'.b:original_filetype .'.vim'
    " allow original filetype detection by other plugins like ale or coc.nvim
    let &filetype=b:original_filetype .'.epuppet'
else
    runtime! syntax/sh.vim
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

if exists('b:original_filetype')
    let b:current_syntax = b:original_filetype . '.epuppet'
else
    let b:current_syntax = 'epuppet'
endif


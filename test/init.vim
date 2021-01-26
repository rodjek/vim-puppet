" minimum vim configuration for test runner
set nocompatible
filetype off
set rtp+=vader.vim
set rtp+=.
set rtp+=after
filetype plugin indent on
syntax enable
" Avoid closing up any fold since it results in some tests skipping lines and
" their output ends up diverging from what we expect them to be.
set foldlevel=99

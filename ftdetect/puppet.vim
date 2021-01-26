" vint: -ProhibitAutocmdWithNoGroup
" Vim's own filetypes.vim runs before all ftdetect scripts (why?) and matches
" detects the .pp extension as being a 'pascal' file. Since the script uses
" `setf`, we can nullify the filetype detection by removing all commands bound
" to BufRead and BufNewFile for .pp files with `au!`. Hopefully, if there were
" any other commands set they were associated with the pascal type and we want
" to get rid of them.
" However, this has the effect of completely nullifying pascal type detection
" for .pp files.
au! BufRead,BufNewFile *.pp setfiletype puppet
" Some epp files may get marked as "mason" type before this script is reached.
" Vim's own scripts.vim forces the type if it detects a `<%` at the start of
" the file. All files ending in .epp should be epuppet
au BufRead,BufNewFile *.epp setl ft=epuppet
au BufRead,BufNewFile Puppetfile setfiletype ruby

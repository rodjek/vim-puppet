" vint: -ProhibitAutocmdWithNoGroup
" Vim has fixed puppet vs pascal detection in patch 8.2.2334 so we can rely on
" their type detection from that point on.
if !has('patch-8.2.2334') && !has('nvim-0.5.0')
  " Vim's own filetypes.vim runs before all ftdetect scripts (why?) and matches
  " detects the .pp extension as being a 'pascal' file. Since the script uses
  " `setf`, we can nullify the filetype detection by removing all commands bound
  " to BufRead and BufNewFile for .pp files with `au!`. Hopefully, if there were
  " any other commands set they were associated with the pascal type and we want
  " to get rid of them.
  " However, this has the effect of completely nullifying pascal type detection
  " for .pp files.
  au! BufRead,BufNewFile *.pp setfiletype puppet
endif
au BufRead,BufNewFile Puppetfile setfiletype ruby

" au! is needed because epuppet already declared in filetype.vim
au! BufNewFile,BufRead *.epp call DetectSubepuppetNativeType()
function! DetectSubepuppetNativeType()
  if !exists('g:epuppet_default_subtype')
    let g:epuppet_default_subtype = 'sh'
  endif
  if exists('*fnameescape')
    execute 'doautocmd filetypedetect BufRead ' .fnameescape(expand('<afile>:r'))
    " don't loop
    if &filetype =~# 'epuppet'
      return
    endif
    " Some epp files may get marked as "mason" type before this script is reached.
    " Vim's own script.vim forces the type if it detects a `<%` at the start of
    " the file. All files ending in .epp should be epuppet
    if &filetype !=# '' && !( &filetype ==# 'mason' && expand('<afile>') !~# 'mason')
      let b:epuppet_subtype = &filetype
      let &filetype = b:epuppet_subtype . '.epuppet'
    else
      if exists('g:epuppet_default_subtype') && g:epuppet_default_subtype !=# ''
        let &filetype = g:epuppet_default_subtype . '.epuppet'
      else
        let &filetype = 'epuppet'
      endif
    endif
  elseif &verbose > 0
    echomsg 'Warning: epuppet subtype will not be recognized because this version of Vim does not have fnameescape()'
    setf epuppet
  endif
endfunction

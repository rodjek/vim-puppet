vim-puppet
==========

Make vim more Puppet friendly!

Provides
--------

  * Formatting based on the latest Puppetlabs Style Guide
  * Syntax highlighting
  * Automatic => alignment (when the
    [tabular](https://github.com/godlygeek/tabular) plugin is also installed)
  * Snippets for builtin types and functions (when the
    [snipmate](https://github.com/msanders/snipmate.vim) plugin is also
    installed)
  * Doesn't require a bloated JRE
  * Doesn't take minutes to open

For bonus points, install the
[syntastic](https://github.com/scrooloose/syntastic) plugin for automatic
syntax checking while in vim.

Installation
------------

If you're using pathogen to manage your vim modules (and if you're not, why 
aren't you), you can simply add this as a submodule in your `~/.vim/bundle/` 
directory.

My entire home directory is a git repository, so for me it's simply a case of

    $ git submodule add -f git://github.com/rodjek/vim-puppet.git .vim/bundle/puppet

If you're not using pathogen, you can just manually place the files in the
appropriate places under `~/.vim/`

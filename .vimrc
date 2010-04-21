set shell=/bin/bash        " use bash for external commands
syntax on                  " syntax highlighting
set background=dark        " dark background
filetype plugin indent on  " filetype detection on

set incsearch    " incremental search
"set hlsearch     " (don't) highlight search results
set ignorecase   " ignore case when searching..
set smartcase    " ..but only if search is all lc
set textwidth=0  " don't linewrap unless i want to.

set expandtab     " spaces as tabs
set shiftwidth=2  " no of indentationspaces used (for <<, >>, cindent ++)
set softtabstop=2 " no of indentationspaces used by <TAB> and <BS>
set smarttab      " smart tab insertion
"set cindent       " use complex c-indentation (but don't combine with ftindent)

set showcmd      " show (partial) command in status line
set showmatch    " show matching brackets
set autowrite    " automatically save before commands like :next and :make
set hidden       " hide buffers when they are abandoned
"set mouse=a     " (don't) enable mouse usage

" some java abbreviations
:abbr psvm public static void main(String[] args) {
:abbr sout System.out.println("


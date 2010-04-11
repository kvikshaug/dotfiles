" set a comfortable window size
set lines=30 columns=100

" use bash for external commands
set shell=/bin/bash

" syntax highlighting, dark background, filetype detection on
syntax on
set background=dark
filetype plugin indent on

" incremental, highlighted search and ignorce case if all lowercase
set incsearch
set hlsearch
set ignorecase
set smartcase

" spaces for <tab> and clever indentation
set expandtab
set tabstop=4
set cindent
set shiftwidth=4

set showcmd        " show (partial) command in status line
set showmatch      " show matching brackets
set autowrite      " automatically save before commands like :next and :make
set hidden         " hide buffers when they are abandoned
set mouse=a        " enable mouse usage

" ignore arrow keys (until i shake off the habit of using them)
" note - needed for command-line mode
nmap  <Up> <Nop>
imap  <Up> <Nop>
omap  <Up> <Nop>
nmap  <Down> <Nop>
imap  <Down> <Nop>
omap  <Down> <Nop>
nmap  <Left> <Nop>
imap  <Left> <Nop>
omap  <Left> <Nop>
nmap  <Right> <Nop>
imap  <Right> <Nop>
omap  <Right> <Nop>

" some java abbreviations
:abbr psvm public static void main(String[] args) {
:abbr sout System.out.println("

" sparkup html zen-code style shortcuts
so ~/.vim/ftplugin/html/sparkup.vim


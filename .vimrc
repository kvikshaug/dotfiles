set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

" Vundle: See :h vundle
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/nerdtree'
call vundle#end()

filetype plugin indent on
syntax on
set number
set incsearch
set tabstop=4
set listchars=tab:▸\ " note the trailing space
set list
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2

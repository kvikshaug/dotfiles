set shell=/bin/bash        " use bash for external commands
set background=dark        " dark background

syntax on                  " syntax highlighting
filetype plugin indent on  " filetype detection on
set list listchars=tab:»·,trail:· " highlight trailing spaces and tab chars
set formatoptions+=ro      " indent block comments

set nobackup     " don't keep backup file
set writebackup  " but keep it temporary while writing to disk

set noruler      " show cursor pos.
set ls=2         " always show statusline
set stl=%f%(\ %n%)%(\ %M%)%(\ %R%)%(\ %W%)%(\ %y%)%{WarnNotUnix()}%=%l,%v\ %P

set incsearch    " incremental search
set ignorecase   " ignore case when searching..
set smartcase    " ..but only if search is all lc
"set hlsearch    " highlight search results

set textwidth=0   " don't linewrap unless i want to.
set expandtab     " spaces as tabs
set smarttab      " smart tab insertion
set backspace=indent,start,eol " backspace removes newlines, indent, start insertion point in insert mode

" Indentation lengths. Varies with filetype.
" TODO make a function which changes these easily
set shiftwidth=2  " no of indentationspaces used (for <<, >>, cindent ++)
set softtabstop=2 " no of indentationspaces used by <TAB> and <BS>

set history=50   " lines in cli history
set showcmd      " show (partial) command in status line
set showmatch    " show matching brackets
set autowrite    " automatically save before commands like :next and :make
set hidden       " hide buffers when they are abandoned
"set mouse=a     " enable mouse usage

" show diff between current buffer and the file it was loaded from
command BufferDiff vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" cd to current buffer directory
autocmd BufEnter * lcd %:p:h

" prints file format when it isn't unix, used in stl
function WarnNotUnix()
  if &ff=='unix'
    return ""
  else
    return " {".&ff."!}"
  endif
endfunction

" MiniBufExplorer options
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

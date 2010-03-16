" set a comfortable window size
set lines=30 columns=100

" show results while searching and highlight results
set incsearch
set hlsearch

" autoindent
set autoindent

" ignore case if search is all lowercase
set ignorecase
set smartcase

" ignore arrow keys (until i shake off the habit of using them)
" note - needed for command-line mode
map  <Up> <Nop>
imap <Up> <Nop>
map  <Down> <Nop>
imap <Down> <Nop>
map  <Left> <Nop>
imap <Left> <Nop>
map  <Right> <Nop>
imap <Right> <Nop>

" abbreviations
:abbr psvm public static void main(String[] args) {
:abbr sout System.out.println(<Nop>);

" sparkup html zen-code style shortcuts
so ~/.vim/ftplugin/html/sparkup.vim
set shiftwidth=2


" markdown filetypes - based on extension
" Disregards previously set filetypes
" (use 'setfiletype mkd' and not 'set filetype=mkd' to not overwrite)

au! BufRead,BufNewFile *.md       set filetype=mkd
au! BufRead,BufNewFile *.mkd      set filetype=mkd
au! BufRead,BufNewFile *.markdown set filetype=mkd

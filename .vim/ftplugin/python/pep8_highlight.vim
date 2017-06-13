" line length highlighting for lines longer than 80 chars

highlight OverLength ctermfg=white ctermbg=darkred guibg=#592929
match OverLength /\%80v.\+/

highlight TrailingWhitespace ctermfg=white ctermbg=darkred guibg=#382424
match TrailingWhitespace /\s\+$/

highlight BadTab ctermbg=yellow ctermfg=white guibg=#592929
match BadTab /^	\+/

set colorcolumn=80

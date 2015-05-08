" line length highlighting for lines longer than 80 chars
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%80v.\+/

highlight TrailingWhitespace ctermfg=white ctermbg=darkred guibg=#382424
2match TrailingWhitespace /\s\+$/


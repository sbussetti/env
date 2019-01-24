set expandtab
setlocal shiftwidth=2
setlocal tabstop=2
let g:syntastic_yaml_checkers = ['yamllint']
let g:syntastic_yaml_yamllint_args = '-c ' . shellescape($HOME . '/.yamllint')
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%>100v.\+/
autocmd BufWritePre * %s/\s\+$//e

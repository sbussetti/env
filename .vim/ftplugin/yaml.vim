set expandtab
setlocal shiftwidth=2
setlocal tabstop=2
let g:syntastic_yaml_checkers = ['yamllint']
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%>100v.\+/

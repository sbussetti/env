set expandtab
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent
set fileformat=unix
set foldlevelstart=10

let g:python_highlight_all = 1

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%>80v.\+/

" highlight BadTab ctermbg=yellow ctermfg=white guibg=#DECB00
" match BadTab /^ \+/

" autoformat

set foldmethod=syntax
set foldnestmax=99

" setlocal completeopt-=preview

setlocal formatprg=autopep8\ -
let g:pep8_map=''

setlocal complete+=t
setlocal formatoptions-=t
setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

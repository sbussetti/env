execute pathogen#infect()

set expandtab
set tabstop=4
set shiftwidth=4
set hlsearch
set showmatch
set history=1000
set undolevels=1000

set viminfo='100,<500,s10,h


let perl_fold=1

filetype off
syntax on
filetype plugin on
filetype indent off
"filetype plugin indent on

" just type faster, jesus
set nopaste
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

autocmd FileType python map <buffer> <F6> :call Flake8()<CR>
let g:flake8_indent_string="\t"
let g:flake8_max_line_length=80
"let g:flake8_ignore="E0611,E1002,E1101,E1102,E1103,E1120,W0102,W0105,W0142,W0201,W0212,W0221,W0232,W0401,W0511,W0611,W0612,W0613,W0621,W0622,W0702,W0703,W0704,W1001,W1201,E101,E128,W191,E126"
let g:flake8_ignore="E101,E128,W191,E126,E223,E251,E501"


au! BufRead,BufNewFile *.less     setfiletype less
au! BufRead,BufNewFile *.pp     setfiletype puppet

au BufNewFile,BufRead *.xml,*.htm,*.html so ~/.vim/XMLFolding.vim

"set ts=2 sw=2 et
let g:indent_guides_start_level=2

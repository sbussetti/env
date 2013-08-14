execute pathogen#infect()

" expects pathogen to be installed

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

" just type faster, jesus
set nopaste
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

autocmd FileType python map <buffer> <F6> :call Flake8()<CR>
let g:flake8_indent_string="\t"
let g:flake8_max_line_length=80
let g:flake8_ignore="E101,E128,W191,E126,E223,E251"


au! BufRead,BufNewFile *.less     setfiletype less
au! BufRead,BufNewFile *.pp     setfiletype puppet

au BufNewFile,BufRead *.xml,*.htm,*.html so ~/.vim/XMLFolding.vim



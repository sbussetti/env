filetype off

call pathogen#infect()
call pathogen#helptags()

set tabstop=4
set shiftwidth=4
set expandtab
set hlsearch
set showmatch
set history=1000
set undolevels=1000
set viminfo='100,<500,s10,h

syntax on
"filetype plugin on
"filetype indent off
filetype plugin indent on


let perl_fold=1
"set foldmethod=indent
let xml_use_xhtml = 1

" sorry i don't like line numbers
let g:pymode_options = 0
setlocal complete+=t
setlocal formatoptions-=t
"if v:version > 702 && !&relativenumber
"    setlocal number
"endif
"setlocal nowrap
setlocal textwidth=79
setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

"jshint
let jshint2_read = 1
let jshint2_save = 1
let jshint2_close = 1
nnoremap <silent><F6> :JSHint<CR>


" just type faster, jesus
set nopaste
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"let g:pymode_lint = 0
"let g:pymode_lint_on_fly = 0
"let g:pymode_lint_on_write = 0
"let g:pymode_lint_unmodified = 0
let g:pymode_lint = 1
let g:pymode_lint_on_fly = 1
let g:pymode_lint_on_write = 1
let g:pymode_lint_unmodified = 1
let g:pymode_lint_message = 1
let g:pymode_lint_checkers = ['pyflakes', 'pep8']
let g:pymode_lint_ignore = "E501,W0401,E128"
let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 1
let g:pymode_lint_todo_symbol = 'WW'
let g:pymode_lint_comment_symbol = 'CC'
let g:pymode_lint_visual_symbol = 'RR'
let g:pymode_lint_error_symbol = 'EE'
let g:pymode_lint_info_symbol = 'II'
let g:pymode_lint_pyflakes_symbol = 'FF'

let g:pymode_doc = 0
let g:pymode_false = 1

let g:pymode_rope_complete_on_dot = 0
let g:pymode_rope_completion_bind = '<C-Space>'
let g:pymode_rope_autoimport = 1
let g:pymode_rope_rename_bind = '<C-c>rr'
let g:pymode_rope_goto_definition_bind = '<C-c>g'
let g:pymode_rope_goto_definition_cmd = 'new'

au! BufRead,BufNewFile *.less     setfiletype less
au! BufRead,BufNewFile *.pp     setfiletype puppet
au BufNewFile,BufRead *.xml,*.htm,*.html so ~/.vim/XMLFolding.vim

"set ts=2 sw=2 et
"let g:indent_guides_start_level=2

"aliases
autocmd FileType python map <buffer> <F6> :PymodeLint<CR>
autocmd FileType python map <buffer> <F5> :PymodeLintAuto<CR>
map <C-p><C-p> :set paste<CR>
map <C-p><C-n> :set nopaste<CR>
map <C-i><C-w> :set diffopt+=iwhite<CR>

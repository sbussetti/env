set expandtab
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent
set fileformat=unix
set foldlevelstart=10
" setlocal nowrap
" setlocal textwidth=279
" set foldmethod=syntax
" set foldnestmax=99
" set foldlevel=99

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%>80v.\+/

"highlight BadTab ctermbg=yellow ctermfg=white guibg=#592929
"match BadTab /^ \+/

" autoformat
noremap <F3> :Autoformat<CR>:PymodeLint<CR>

set foldmethod=syntax
set foldnestmax=99

setlocal completeopt-=preview
" map <buffer> <F6> :PymodeLint<CR>
" map <buffer> <F8> :PymodeLintAuto<CR>

"-- Check code in current buffer
nnoremap <Leader>l :PymodeLint<CR> 
"-- Toggle code checking
nnoremap <Leader>lt :PymodeLintToggle<CR> 
" -- Fix PEP8 errors in current buffer automatically
nnoremap <Leader>la :PymodeLintAuto<CR> 

setlocal formatprg=autopep8\ -
let g:pep8_map=''

" disable syntastic 
let b:syntastic_skip_checks = 0 
let g:syntastic_check_on_open = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_python_checkers = []

" let g:pymode_debug=1
let g:pymode_options = 1
let g:pymode_trim_whitespaces = 1
setlocal complete+=t
setlocal formatoptions-=t
setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)
let g:pymode_indent = 1
let g:pymode_folding = 1
let g:pymode_virtualenv = 1
let g:pymode_lint = 1
let g:pymode_lint_signs = 1
let g:pymode_lint_on_fly = 1
let g:pymode_lint_on_write = 1
let g:pymode_lint_unmodified = 0
let g:pymode_lint_message = 1
" let g:pymode_lint_checkers = ['pep8',  'pyflakes', 'pylint', 'mccabe'] 
let g:pymode_lint_ignore = ["I0011","E501","E128","E266","E0712","E1002","E1103","C0111","C1001","C0330","C901","R0201","R0914","R0912","W0212","W0401","W0703","W503","W0511","W606","unexpected-keyword-arg","no-value-for-parameter"]
"let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 1
let g:pymode_lint_todo_symbol = 'WW'
let g:pymode_lint_comment_symbol = 'CC'
let g:pymode_lint_visual_symbol = 'RR'
let g:pymode_lint_error_symbol = 'EE'
let g:pymode_lint_info_symbol = 'II'
let g:pymode_lint_pyflakes_symbol = 'FF'
let g:pymode_options_max_line_length = 80

let g:pymode_doc = 0
let g:pymode_false = 1

let g:pymode_rope = 0
" let g:pymode_rope_lookup_project = 0
" let g:pymode_rope_complete_on_dot = 0
" let g:pymode_rope_completion_bind = '<C-Space>'
" let g:pymode_rope_autoimport = 1
" let g:pymode_rope_autoimport_modules = ['django.*', 'filmbot.*']
" let g:pymode_rope_rename_bind = '<C-c>rr'
" let g:pymode_rope_goto_definition_bind = '<Leader>d'
" let g:pymode_rope_goto_definition_cmd = 'new'
" let g:pymode_rope_regenerate_on_write = 1
" let g:pymode_rope_autoimport_import_after_complete = 1

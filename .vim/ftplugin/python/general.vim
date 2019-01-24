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

set foldmethod=syntax
set foldnestmax=99

setlocal completeopt-=preview

setlocal formatprg=autopep8\ -
let g:pep8_map=''

" disable syntastic 
" let b:syntastic_skip_checks = 0 
" let g:syntastic_check_on_open = 0
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_always_populate_loc_list = 0
" let g:syntastic_python_checkers = []

setlocal complete+=t
setlocal formatoptions-=t
setlocal commentstring=#%s
setlocal define=^\s*\\(def\\\\|class\\)

let pipenv_venv_path = system('pipenv --venv')
if shell_error == 0
  let venv_path = substitute(pipenv_venv_path, '\n', '', '')
  " let g:ycm_python_binary_path = venv_path . '/bin/python'
  let g:syntastic_python_pylint_exe = venv_path . '/bin/pylint' 
else
  " let g:ycm_python_binary_path = 'python'
  let g:syntastic_python_pylint_exe = 'pylint'
endif

let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_pylint_args = '--disable=too-many-lines,wrong-import-order,ungrouped-imports,invalid-name,missing-docstring,too-many-locals,too-many-statements,bad-continuation'

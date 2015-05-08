filetype off

call pathogen#infect()
call pathogen#helptags()

set clipboard=unnamed

set tabstop=4
set shiftwidth=4
set expandtab
set hlsearch
set showmatch
set history=1000
set undolevels=1000
set viminfo='100,<500,s10,h
set autoread 

filetype plugin indent on
syntax on
set foldmethod=syntax

noremap <Space> <Nop>
let mapleader = "\<Space>"

map <C-p><C-p> :set paste<CR>
map <C-p><C-n> :set nopaste<CR>
map <C-i><C-w> :set diffopt+=iwhite<CR>

nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
function VerticalSplitBuffer(buffer)
    execute "vert belowright sb" a:buffer 
endfunction
command -nargs=1 Vbuffer call VerticalSplitBuffer(<f-args>)

" if help or quickfix are the last open buffers, auto-quit those
" TODO: handle case where quickfix AND help are the last 2 remaining
au BufEnter * call MyLastWindow()
function! MyLastWindow()
  " if the window is quickfix go on
  if &buftype == "quickfix" || &buftype == 'help'
    " if this window is last on screen quit without warning
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

" just type faster, jesus
set nopaste
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" airline
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#quickfix#enabled = 1
let g:airline_powerline_fonts = 1

" git-gutter
let g:gitgutter_enabled = 0
let g:gitgutter_highlight_lines = 1
let g:gitgutter_signs = 1


" Perl
let perl_fold=1
let perl_extended_vars=1
let perl_fold_blocks=1
let perl_include_pod=1

"Puppet
au! BufRead,BufNewFile *.pp     setfiletype puppet

"JS/HTML/CSS
au! BufRead,BufNewFile *.less     setfiletype less
au BufNewFile,BufRead *.xml,*.htm,*.html so ~/.vim/XMLFolding.vim
"vim-javascript-syntax au FileType javascript call JavaScriptFold()
"strip trailing ws
autocmd BufWritePre *.js,*.htm,*html,*.css,*.less,*.scss :%s/\s\+$//e
let xml_use_xhtml = 1

"vim-javascript
let javaScript_fold = 1 
let b:javascript_fold = 1
let javascript_enable_domhtmlcss = 1
let g:javascript_conceal_function = "ƒ"
let g:javascript_conceal_null = "ø"
let g:javascript_conceal_this = "@"
let g:javascript_conceal_return = "⇚"
let g:javascript_conceal_undefined  = "¿"
let g:javascript_conceal_NaN = "ℕ"
let g:javascript_conceal_prototype  = "¶"

"jshint2
autocmd Filetype javascript nnoremap <silent><F6> :JSHint<CR>
let jshint2_read = 1
let jshint2_save = 1
let jshint2_close = 1
let jshint2_error = 1

"Python
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
"let g:pymode_lint = 0
"let g:pymode_lint_on_fly = 0
"let g:pymode_lint_on_write = 0
"let g:pymode_lint_unmodified = 0
let g:pymode_virtualenv = 1
let g:pymode_lint = 1
let g:pymode_lint_on_fly = 0
let g:pymode_lint_on_write = 1
let g:pymode_lint_unmodified = 1
let g:pymode_lint_message = 1
let g:pymode_lint_checkers = ['pep8', 'pylint', 'mccabe'] "'pyflakes', 
let g:pymode_lint_ignore = "I0011,E501,E128,E266,E0712,E1002,E1103,C0111,C1001,C0330,R0201,R0914,R0912,W0212,W0401,W0703,W0511,unexpected-keyword-arg,no-value-for-parameter"
"let g:pymode_lint_cwindow = 0
let g:pymode_lint_signs = 1
let g:pymode_lint_todo_symbol = 'WW'
let g:pymode_lint_comment_symbol = 'CC'
let g:pymode_lint_visual_symbol = 'RR'
let g:pymode_lint_error_symbol = 'EE'
let g:pymode_lint_info_symbol = 'II'
let g:pymode_lint_pyflakes_symbol = 'FF'
let g:pymode_options_max_line_length = 159

let g:pymode_doc = 0
let g:pymode_false = 1

let g:pymode_rope = 0
"let g:pymode_rope_complete_on_dot = 1
"let g:pymode_rope_completion_bind = '<C-Space>'
"let g:pymode_rope_autoimport = 1
"let g:pymode_rope_rename_bind = '<C-c>rr'
"let g:pymode_rope_goto_definition_bind = '<C-c>g'
"let g:pymode_rope_goto_definition_cmd = 'new'
"let g:pymode_rope_regenerate_on_write = 1

" jedi
let g:jedi#popup_on_dot = 0
autocmd FileType python setlocal completeopt-=preview

"set ts=2 sw=2 et
"let g:indent_guides_start_level=2

"python aliases
autocmd FileType python map <buffer> <F6> :PymodeLint<CR>
autocmd FileType python map <buffer> <F5> :PymodeLintAuto<CR>
let g:pep8_map=''

"git
noremap <Leader>gb :Gblame<CR>

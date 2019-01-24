filetype off

call pathogen#infect()
call pathogen#helptags()

set clipboard=unnamed

set noshowmode
set tabstop=2
set shiftwidth=2
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
set foldenable

noremap <Space> <Nop>
let mapleader = "\<Space>"

" reload current tab
map <C-e><C-e> :edit<CR>

map <C-p><C-p> :set paste<CR>
map <C-p><C-n> :set nopaste<CR>
map <C-i><C-w> :set diffopt+=iwhite<CR>
set diffopt+=vertical

" replacement
nnoremap <Leader>S :s/\<<C-r><C-w>\>/
nnoremap <Leader>SA :%s/\<<C-r><C-w>\>/
nnoremap <Leader>s :s/<C-r><C-w>/
nnoremap <Leader>sa :%s/<C-r><C-w>/

" what does this do again?
nnoremap <leader>z :w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee ~/.vim/output<CR>:split ~/.vim/output<CR>:redraw!<CR>

" spellcheck toggle
noremap <Leader>so :setlocal spell spelllang=en_us<CR>
noremap <Leader>sO :setlocal nospell<CR>

nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
function! VerticalSplitBuffer(buffer)
    execute "vert belowright sb" a:buffer 
endfunction
command! -nargs=1 Vbuffer call VerticalSplitBuffer(<f-args>)
noremap <Leader>e :Explore<CR>

" quickfix shortcuts
" noremap <Leader>] :lnext<CR>
" noremap <Leader>[ :lprevious<CR>

if !exists('g:grepper')
    let g:grepper = {}
endif
let g:grepper.tools =
  \ ['ag', 'ack', 'grep', 'findstr', 'rg', 'pt', 'sift', 'git']
let g:grepper.ack = { 'grepprg':    'ack --noheading --column --nocolor',
      \                    'grepformat': '%f:%l:%c:%m',
      \                    'escape':     '\^$.*+?()[]{}|' }
let g:grepper.ag = { 'grepprg': 'ag --vimgrep --' }
nnoremap <leader>g :Grepper<cr>
let g:grepper.next_tool = '<leader>g'
let g:grepper.highlight = 0
let g:grepper.simple_prompt = 0
let g:grepper.side = 0

nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)


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
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#quickfix#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
let g:airline_powerline_fonts = 1

" git-gutter
let g:gitgutter_enabled = 0
let g:gitgutter_highlight_lines = 1
let g:gitgutter_signs = 1


" Perl
let perl_fold=1
" let perl_fold_blocks=1
let perl_extended_vars=1
let perl_include_pod=1
let perl_sync_dist=250

"Puppet
au! BufRead,BufNewFile *.pp     setfiletype puppet

"JS/HTML/CSS
au! BufRead,BufNewFile *.less     setfiletype less

"Handlebars
" au  BufNewFile,BufRead *.php set filetype=html.handlebars syntax=mustache | runtime! bundle/vim-mustache-handlebars/ftplugin/mustache.vim bundle/vim-mustache-handlebars/ftplugin/mustache*.vim bundle/vim-mustache-handlebars/ftplugin/mustache/*.vim
au BufRead,BufNewFile *.region set filetype=html
"javascript
let b:javascript_fold = 1
" let g:javascript_conceal_function = "ƒ"
" let g:javascript_conceal_null = "ø"
" let g:javascript_conceal_this = "@"
" let g:javascript_conceal_return = "⇚"
" let g:javascript_conceal_undefined  = "¿"
" let g:javascript_conceal_NaN = "ℕ"
" let g:javascript_conceal_prototype  = "¶"
" autocmd BufRead,BufNewFile *.js,*.jsx setlocal foldmethod=indent
let g:formatters_javascript = ['eslint_javascript']
let g:formatdef_eslint_javascript = '"eslint-format"'
let g:formatters_javascript_jsx = ['eslint_javascript_jsx']
let g:formatdef_eslint_javascript_jsx = '"eslint-format"'
let g:jsx_ext_required = 0
if !exists('g:context#commentstring#table')
    let g:context#commentstring#table = {}
endif
" autocmd FileType javascript.jsx setlocal commentstring=
let g:context#commentstring#table['javascript.jsx'] = {
			\ 'jsxRegion'     : '{/* %s */}',
			\}
let g:context#commentstring#table.htmldjango = {
			\ 'javaScript'     : '// %s',
			\}
au FileType javascript map <Leader>i A // eslint-disable-line<ESC>


"ack.vim
"todo, figure out the 'project root' somehow and only search that?
noremap <Leader>a :LAck <cword><CR>

"Python: see ftplugin/python/general.vim

" jedi
let g:jedi#auto_initialization = 1
let g:jedi#popup_on_dot = 1
let g:jedi#auto_vim_configuration = 1
let g:jedi#use_tabs_not_buffers = 1
" let g:jedi#use_splits_not_buffers = 'right'
let g:jedi#show_call_signatures = 1
" disables docstring window during autocomplete
"set ts=2 sw=2 et
"let g:indent_guides_start_level=2

"git
noremap <Leader>gb :Gblame<CR>

"syntastic
set sessionoptions-=blank

set statusline+=%#warningmsg#
set statusline+=%{fugitive#statusline()}
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_ignore_files = ['\m.*/html/core/.*', '\m.*/html/content/vendor/.*']
let g:syntastic_mode_map = { 
            \ 'mode': 'passive',
            \ 'active_filetypes': [
            \   'apiblueprint', 'php', 'php.wordpress',
            \   'javascript', 'json', 'yaml', 'yaml.ansible',
            \   'ruby', 'python'
            \]}

let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_ruby_checkers = ['rubocop']

" let g:syntastic_error_symbol = '❌'
" let g:syntastic_style_error_symbol = '⁉️'
" let g:syntastic_warning_symbol = '⚠️'
" let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

noremap <Leader>st :SyntasticToggleMode<CR>
noremap <Leader>se :SyntasticCheck<CR> :Errors<CR>
" autocmd FileType php map <buffer> <F6> :Errors<CR>
au FileType php map <Leader>i A // @codingStandardsIgnoreLine<ESC>

" autocmd Filetype apiblueprint nnoremap <silent><F6> :SyntasticCheck drafter<CR>

" vim-session
let g:session_autosave_periodic = 1
let g:session_autosave = 1

" obsession 
" set statusline+=%{ObsessionStatus()}
" set tabline+=%{ObsessionStatus()}
" set titlestring+=%{ObsessionStatus()}

" logs
au BufRead	*.log   setf    httplog

" postgreSQL
au BufNewFile,BufRead *.sql  setf pgsql
au BufNewFile,BufRead *.sql  set syntax=pgsql

" csv
noremap <Leader>csv :%ArrangeColumn!<CR>
" let g:csv_col='[^,]*,'
" let g:csv_autocmd_arrange = 1
" let g:csv_autocmd_arrange_size = 1024*1024*64

" autoformat
let g:autoformat_verbosemode=0

noremap <Leader>f :Autoformat<CR>

" linediff
noremap <Leader>ld :Linediff<CR>
noremap <Leader>lr :LinediffReset<CR>

" scss
autocmd BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}

if !exists('g:vdebug_options')
    let g:vdebug_options = {}
endif
let g:vdebug_options['path_maps'] = {'/home/vagrant/src': '/Users/sbussetti/src'}
let g:vdebug_options['break_on_open'] = 0
let g:vdebug_options['continuous_mode'] = 1

" ansible
autocmd BufRead,BufNewFile */ansible/*.yml set syntax=yaml.ansible


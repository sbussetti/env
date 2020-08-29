set nocompatible              " be iMproved, required
filetype off                  " required

" logging
" set verbosefile=~/.vim/log/verbose.log
" set verbose=15

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" syntax
Plugin 'hashivim/vim-terraform'
Plugin 'martinda/Jenkinsfile-vim-syntax'
" Bundle 'lepture/vim-jinja'
Plugin 'saltstack/salt-vim'
Plugin 'GEverding/vim-hocon'
Plugin 'satabin/hocon-vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'pearofducks/ansible-vim'
Plugin 'stephpy/vim-yaml'
Plugin 'w0rp/ale'


Plugin 'plytophogy/vim-virtualenv'
Plugin 'PieterjanMontens/vim-pipenv'
Plugin 'lambdalisue/vim-pyenv'
Plugin 'suan/vim-instant-markdown', {'rtp': 'after'}

Plugin 'jamessan/vim-gnupg'
Plugin 'itchyny/lightline.vim'
Plugin 'bling/vim-bufferline'
" Plugin 'bash-support.vim'
Plugin 'editorconfig-vim'
" Plugin 'davidhalter/jedi-vim'
" Plugin 'syntastic'
" Plugin 'Chiel92/vim-autoformat'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-rhubarb'
Plugin 'tommcdo/vim-fubitive'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
" Plugin 'tpope/vim-markdown'
" Plugin 'xolox/vim-misc'
" Plugin 'xolox/vim-session'
Plugin 'tpope/vim-unimpaired'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


"""""""""""""""""""""""""""""""""""""""""

set clipboard=unnamed
set number
set cursorline
highlight LineNr ctermfg=244 ctermbg=233
highlight CursorLineNr ctermbg=100 ctermfg=233 cterm=bold
highlight CursorLine cterm=none ctermbg=none ctermfg=none
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
set autoindent
set smartindent

set foldenable
set foldmethod=marker
au FileType sh let g:sh_fold_enabled=5
au FileType sh let g:is_bash=1
au FileType sh set foldmethod=syntax

syntax enable

set laststatus=2

set completeopt-=preview
inoremap <expr> <Tab> pumvisible() ? '<C-n>' : '<Tab>'

if !has('gui_running')
  set t_Co=256
endif

let g:lightline = {
  \   'colorscheme': 'solarized',
  \   'active': {
  \     'left':[ [ 'mode', 'paste' ],
  \              [ 'gitbranch', 'readonly', 'filename', 'modified' ]
  \     ]
  \   },
	\   'component': {
	\     'lineinfo': ' %3l:%-2v',
	\   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \   }
  \ }
let g:lightline.separator = {
	\   'left': '', 'right': ''
  \}
let g:lightline.subseparator = {
	\   'left': '', 'right': ''
  \}

let g:lightline.tabline = {
  \   'left': [ ['tabs'] ],
  \   'right': [ [''] ]
  \ }
set showtabline=2  " Show tabline
set guioptions-=e  " Don't use GUI tabline

" always redraw on focus change, new buffer
:au FocusGained * :redraw!
:au BufEnter * :redraw!
:au FileWritePost * :redraw!
:au FileAppendPost * :redraw!
:au BufWritePost * :redraw!

noremap <Space> <Nop>
let mapleader = "\<Space>"

" reload current tab
map <C-e><C-e> :edit<CR>

" reload vimrc
map <C-e><C-r> :so $MYVIMRC<CR>

map <C-p><C-p> :set paste<CR>
map <C-p><C-n> :set nopaste<CR>
map <C-i><C-w> :set diffopt+=iwhite<CR>
set diffopt+=vertical

" replacement
nnoremap <Leader>S :s/\<<C-r><C-w>\>/
nnoremap <Leader>SA :%s/\<<C-r><C-w>\>/
nnoremap <Leader>s :s/<C-r><C-w>/
nnoremap <Leader>sa :%s/<C-r><C-w>/

" edit path under cursor in a new tab
noremap <Leader>a <C-w>gf<CR>

"

" what does this do again?
nnoremap <leader>z :w<CR>:silent !chmod +x %:p<CR>:silent !%:p 2>&1 \| tee ~/.vim/output<CR>:split ~/.vim/output<CR>:redraw!<CR>

" spellcheck toggle
noremap <Leader>sp :setlocal invspell spelllang=en_us<CR>

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


" if help or quickfix are the last open buffers, auto-quit those
" TODO: handle case where quickfix AND help are the last 2 remaining
" au BufEnter * call MyLastWindow()
" function! MyLastWindow()
"   " if the window is quickfix go on
"   if &buftype == "quickfix" || &buftype == 'help'
"     " if this window is last on screen quit without warning
"     if winbufnr(2) == -1
"       quit!
"     endif
"   endif
" endfunction



" just type faster, jesus
set nopaste
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" write current buffer to clipboard
noremap <Leader>cp :w !pbcopy <CR><CR>

" git-gutter
let g:gitgutter_enabled = 0
let g:gitgutter_highlight_lines = 1
let g:gitgutter_signs = 1

" fugitive (git)
" noremap <Leader>gb :Gblame<CR>
noremap <Leader>gb :Git blame<CR>
noremap <Leader>gv :Gbrowse<CR>

" rhubarb (fugititive extension for github)
let g:github_enterprise_urls = ['https://github.corp.dyndns.com']
" fubitive (same but for bitbucket)
let g:fugitive_bitbucket_domains = ['https://bitbucket.oci.oraclecorp.com']

"" Perl
"let perl_fold=1
"" let perl_fold_blocks=1
"let perl_extended_vars=1
"let perl_include_pod=1
"let perl_sync_dist=250

""Puppet
"au! BufRead,BufNewFile *.pp     setfiletype puppet

""JS/HTML/CSS
"au! BufRead,BufNewFile *.less     setfiletype less

""Handlebars
"" au  BufNewFile,BufRead *.php set filetype=html.handlebars syntax=mustache | runtime! bundle/vim-mustache-handlebars/ftplugin/mustache.vim bundle/vim-mustache-handlebars/ftplugin/mustache*.vim bundle/vim-mustache-handlebars/ftplugin/mustache/*.vim
"au BufRead,BufNewFile *.region set filetype=html
""javascript
"let b:javascript_fold = 1
"" let g:javascript_conceal_function = "ƒ"
"" let g:javascript_conceal_null = "ø"
"" let g:javascript_conceal_this = "@"
"" let g:javascript_conceal_return = "⇚"
"" let g:javascript_conceal_undefined  = "¿"
"" let g:javascript_conceal_NaN = "ℕ"
"" let g:javascript_conceal_prototype  = "¶"
"" autocmd BufRead,BufNewFile *.js,*.jsx setlocal foldmethod=indent
"let g:formatters_javascript = ['eslint_javascript']
"let g:formatdef_eslint_javascript = '"eslint-format"'
"let g:formatters_javascript_jsx = ['eslint_javascript_jsx']
"let g:formatdef_eslint_javascript_jsx = '"eslint-format"'
"let g:jsx_ext_required = 0
"if !exists('g:context#commentstring#table')
"    let g:context#commentstring#table = {}
"endif
"" autocmd FileType javascript.jsx setlocal commentstring=
"let g:context#commentstring#table['javascript.jsx'] = {
"			\ 'jsxRegion'     : '{/* %s */}',
"			\}
"let g:context#commentstring#table.htmldjango = {
"			\ 'javaScript'     : '// %s',
"			\}
"au FileType javascript map <Leader>i A // eslint-disable-line<ESC>


""ack.vim
""todo, figure out the 'project root' somehow and only search that?
"noremap <Leader>a :LAck <cword><CR>

""Python: see ftplugin/python/general.vim

"ale
let g:ale_completion_enabled = 1
let g:ale_linters = {
      \ 'python': ['flake8', 'mypy', 'pylint', 'pyls'],
      \}
let g:ale_python_pylint_options = "--disable=C0111 --disable=too-few-public-methods --disable=no-self-use --disable=unused-argument --disable=no-init --disable=superfluous-parens"
let g:ale_terraform_tflint_options = "--module"
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1
" go to definition
noremap <Leader>d :ALEGoToDefinitionInTab<CR>

""syntastic
"set sessionoptions-=blank

"set statusline+=%#warningmsg#
set statusline+=%{FugitiveStatusline()}
"set statusline+=%*

"" vim-session
"let g:session_autosave_periodic = 1
"let g:session_autosave = 1
"let g:session_autoload = 'no'

"" obsession
"" set statusline+=%{ObsessionStatus()}
"" set tabline+=%{ObsessionStatus()}
"" set titlestring+=%{ObsessionStatus()}

"" logs
"au BufRead	*.log   setf    httplog

"" postgreSQL
"au BufNewFile,BufRead *.sql  setf pgsql
"au BufNewFile,BufRead *.sql  set syntax=pgsql

"" csv
"noremap <Leader>csv :%ArrangeColumn!<CR>
"" let g:csv_col='[^,]*,'
"" let g:csv_autocmd_arrange = 1
"" let g:csv_autocmd_arrange_size = 1024*1024*64
autocmd BufRead,BufNewFile *.csv set syntax=text.plain filetype=text.plain

"" autoformat
"let g:autoformat_verbosemode=0

"noremap <Leader>f :Autoformat<CR>

"" linediff
"noremap <Leader>ld :Linediff<CR>
"noremap <Leader>lr :LinediffReset<CR>

"" scss
"autocmd BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}

"if !exists('g:vdebug_options')
"    let g:vdebug_options = {}
"endif
"let g:vdebug_options['path_maps'] = {'/home/vagrant/src': '/Users/sbussetti/src'}
"let g:vdebug_options['break_on_open'] = 0
"let g:vdebug_options['continuous_mode'] = 1

"" ansible / yaml

let s:comment = '\v^\s*#' " # comment
let s:array_entry = '\v^\s*-\s' " - foo
let s:named_module_entry = '\v^\s*-\s*(name|hosts|role):\s*\S' " - name: 'do stuff'
let s:dictionary_entry = '\v^\s*[^:-]+:\s*$' " with_items:
let s:key_value = '\v^\s*[^:-]+:\s*\S' " apt: name=package
let s:scalar_value = '\v:\s*[>|\|]\s*$' " shell: >
function! GetAnsibleIndent(lnum)
  if a:lnum == 2 || !prevnonblank(a:lnum-1)
    return 0
  endif
  if exists("g:ansible_unindent_after_newline")
    if (a:lnum -1) != prevnonblank(a:lnum - 1)
      return 0
    endif
  endif

  let prevlnum = prevnonblank(a:lnum - 1)
  let maintain = indent(prevlnum)
  let increase = maintain + &sw

  let line = getline(prevlnum)
  if line =~ s:array_entry
    if line =~ s:named_module_entry
      return increase
    else
      return maintain
    endif
  elseif line =~ s:dictionary_entry
    return increase
  elseif line =~ s:key_value
    if line =~ s:scalar_value
      return increase
    else
      return maintain
    endif
  else
    return maintain
  endif
  return maintain
endfunction

autocmd BufRead,BufNewFile */ansible/*.yml,*/roles/*.yml set syntax=yaml.ansible
autocmd FileType yaml.ansible setl indentexpr=GetAnsibleIndent(v:lnum) ts=2 sts=2 sw=2 expandtab

let g:ansible_unindent_after_newline = 1
let g:ansible_yamlKeyName = 'yamlKey'

autocmd BufNewFile,BufRead *.py.j2 set ft=python
"" borrow saltstack sls syntax which is just jinja+yaml
autocmd BufNewFile,BufRead *.yaml.j2,*.yml.j2 set ft=sls
let g:cur_filetype = &filetype
if g:cur_filetype == "yaml.j2" || g:cur_filetype == "yml.j2"
  set ft=sls
endif

" gnupg
" Armor files
let g:GPGPreferArmor=1

" diff
if &diff
noremap <Leader>dg V:diffget<CR>
noremap <Leader>dp V:diffput<CR>
endif

" terraform
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_fmt_on_save=1

" instant-markdown
let g:instant_markdown_autoscroll = 1

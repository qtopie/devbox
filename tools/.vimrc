
" vim plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

"Plug 'govim/govim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'artificerpi/autoread.vim'
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
Plug 'chase/vim-ansible-yaml'
Plug 'scrooloose/nerdtree'
Plug 'maksimr/vim-jsbeautify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Initialize plugin system
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" markdown
autocmd FileType markdown nmap <F5> :MarkdownPreview<CR>

call glaive#Install()
filetype plugin indent on    " required
Glaive codefmt plugin[mappings]
Glaive codefmt google_java_executable="java -jar ${WORKSPACE}/bin/google-java-format-1.5-all-deps.jar"
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"

" google codefmt
augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
augroup END


" file tree
map <C-n> :NERDTreeToggle<CR>

" let alt key work, https://stackoverflow.com/a/10216459/4385714
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw
set ttimeout ttimeoutlen=50

" mappings to move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" block dragging from Damian Conway
"runtime plugin/dragvisuals.vim
"vmap  <expr>  <LEFT>    DVB_Drag('left' )
"vmap  <expr>  <RIGHT>   DVB_Drag('right')
"vmap  <expr>  <DOWN>    DVB_Drag('down' )
"vmap  <expr>  <UP>      DVB_Drag('up')
"let g:DVB_TrimWS = 1

" go
"let g:go_fmt_command = "goimports"

" python
filetype on
autocmd FileType python nnoremap <buffer> <F5> :exec '!clear; python3' shellescape(@%, 1)<cr>

" yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>

" my configuration for basic editing
set nu
set expandtab tabstop=4 shiftwidth=4
syntax on

" show whitespace
set listchars=tab:>~,nbsp:_,trail:.
set list

" make the 80th column stand out
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%80v', 100)

" delete
set backspace=indent,eol,start
color desert
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40


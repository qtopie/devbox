set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'artificerpi/autoread.vim'
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
Plugin 'google/vim-glaive'
Plugin 'chase/vim-ansible-yaml'
Plugin 'fatih/vim-go'
Plugin 'suan/vim-instant-markdown'
Plugin 'scrooloose/nerdtree'
Plugin 'maksimr/vim-jsbeautify'

" All of your Plugins must be added before the following line
call vundle#end()            " required
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

" markdown
let g:instant_markdown_autostart = 0
let g:instant_markdown_allow_unsafe_content = 1
autocmd FileType markdown nmap <F5> :InstantMarkdownPreview<CR>

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

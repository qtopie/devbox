" vim plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'artificerpi/autoread.vim'
Plug 'chase/vim-ansible-yaml'
Plug 'scrooloose/nerdtree'
Plug 'maksimr/vim-jsbeautify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Initialize plugin system
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin indent on    " required

" file tree
map <C-n> :NERDTreeToggle<CR>

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

" delete
set backspace=indent,eol,start
color desert
set cursorline
hi CursorLine term=bold cterm=bold guibg=Grey40


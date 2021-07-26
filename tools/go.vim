".vim/after/ftplugin/go.vim

" shortcut like vscode
nnoremap <buffer> <silent> <F2> :hide GoRename<CR>
nnoremap <buffer> <silent> <F4> :hide GoBuild<CR>
nnoremap <buffer> <silent> <F5> :hide GoDebugStart<CR>
nnoremap <buffer> <silent> <C-F5> :hide GoRun<CR>

" Toggle to enable/disable syntax highlighting
function! ToggleSyntax()
  if exists("g:syntax_on")
    syntax off
  else
    syntax on
  endif
endfunction

nnoremap <buffer> <silent> <F3> :call ToggleSyntax()<CR>


" Description: macOS-specific configs

" Use OSX clipboard to copy and to paste
set clipboard+=unnamedplus
" Copy selected text in visual mode
"set clipboard+=autoselect
set clipboard=unnamed

" esc ime off 
function! s:disableIme()
  call jobstart(['osascript', '-e', 'tell application "System Events" to key code {102}'], {'in_io': 'null', 'out_io': 'null', 'err_io': 'null'})
endfunction
inoremap <silent> <ESC> <ESC>:call <SID>disableIme()<CR>


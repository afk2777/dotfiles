"if !exists('g:loaded_vim-ipython-cell') | finish | endif
"------------------------------------------------------------------------------
" slime configuration 
"------------------------------------------------------------------------------
" always use tmux
let g:slime_target = 'tmux'

" fix paste issues in ipython
let g:slime_python_ipython = 1

" always send text to the top-right pane in the current tmux tab without asking
let g:slime_default_config = {
            \ 'socket_name': get(split($TMUX, ','), 0),
            \ 'target_pane': '{top-right}' }
let g:slime_dont_ask_default = 1

"------------------------------------------------------------------------------
" ipython-cell configuration
"------------------------------------------------------------------------------
" Keyboard mappings.  is \ (backslash) by default

" map s to start IPython
nnoremap si :SlimeSend1 ipython --matplotlib<CR>

" map r to run script
nnoremap ri :IPythonCellExecuteCell<CR>

" " map R to run script and time the execution
" nnoremap R :IPythonCellRunTime

" " map c to execute the current cell
" nnoremap c :IPythonCellExecuteCell

" " map C to execute the current cell and jump to the next cell
" nnoremap C :IPythonCellExecuteCellJump

" " map l to clear IPython screen
" nnoremap l :IPythonCellClear

" " map x to close all Matplotlib figure windows
" " nnoremap x :IPythonCellClose

" " map [c and ]c to jump to the previous and next cell header
" nnoremap [c :IPythonCellPrevCell
" nnoremap ]c :IPythonCellNextCell

" " map h to send the current line or current selection to IPython
" nmap h SlimeLineSend
" xmap h SlimeRegionSend

" " map p to run the previous command
" nnoremap p :IPythonCellPrevCommand

" " map Q to restart ipython
" nnoremap Q :IPythonCellRestart

" " map d to start debug mode
" " nnoremap d :SlimeSend1 %debug

" " map q to exit debug mode or IPython
" nnoremap q :SlimeSend1 exit


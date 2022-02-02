" vim-quickrun
let g:quickrun_no_default_key_mappings = 1
let g:quickrun_config = {
    \ '_' : {
        \ 'outputter' : 'error',
        \ 'outputter/error/success' : 'buffer',
        \ 'outputter/error/error'   : 'quickfix',
        \ 'outputter/buffer/split' : ':botleft 8sp',
    \ }
\}

if has('nvim')
    let g:quickrun_config._.runner = 'neovim_job'
elseif exists('*ch_close_in')
    let g:quickrun_config._.runner = 'job'
endif

nnoremap <Leader>r :<C-U>QuickRun<CR>
xnoremap <Leader>r gv:<C-U>QuickRun<CR>


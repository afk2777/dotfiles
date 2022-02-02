" Important!!
if exists('g:vscode') | finish | endif

if has('termguicolors')
  set termguicolors
endif

" The configuration options should be placed before `colorscheme sonokai`.
let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 0 
let g:sonokai_disable_italic_comment = 0

colorscheme sonokai


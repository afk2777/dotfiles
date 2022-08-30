--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- add your own keymapping
lvim.keys.normal_mode["ss"] = ":split<cr><C-w>j"
lvim.keys.normal_mode["sv"] = ":vsplit<cr><C-w>l"
lvim.keys.normal_mode["sh"] = "<C-w>h"
lvim.keys.normal_mode["sk"] = "<C-w>k"
lvim.keys.normal_mode["sj"] = "<C-w>j"
lvim.keys.normal_mode["sl"] = "<C-w>l"
lvim.keys.insert_mode["<C-f>"] = "<right>"
lvim.keys.insert_mode["<C-b>"] = "<left>"
lvim.keys.insert_mode["<C-p>"] = "<up>"
lvim.keys.insert_mode["<C-n>"] = "<down>"
lvim.keys.insert_mode["<C-d>"] = "<delete>"
lvim.keys.insert_mode["<C-e>"] = "<end>"
lvim.keys.insert_mode["<C-a>"] = "<home>"

-- IPython key map
lvim.keys.normal_mode["si"] = ":SlimeSend1 ipython --matplotlib<cr>"
lvim.keys.normal_mode["ri"] = ":IPythonCellExecuteCell<cr>"

lvim.keys.normal_mode["te"] = ":tabedit<cr>"

-- default explore keymap delete
lvim.keys.normal_mode["<leader>e"] = false
lvim.builtin.which_key.mappings["e"] = nil

-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  --   -- for input mode
  --   i = {
  --     ["<C-j>"] = actions.move_selection_next,
  --     ["<C-k>"] = actions.move_selection_previous,
  --     ["<C-n>"] = actions.cycle_history_next,
  --     ["<C-p>"] = actions.cycle_history_prev,
  --   },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvim_web_devicons = false
lvim.builtin.nvimtree.active = false
-- lvim.builtin.nvimtree.setup.view.side = "left"
-- lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

---@usage disable automatic installation of servers
lvim.lsp.automatic_servers_installation = true

---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
vim.list_extend(lvim.lsp.override, { "pyright" })

---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
local opts = {} -- check the lspconfig documentation for a list of all possible options
require("lvim.lsp.manager").setup("pyright", opts)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require 'lspconfig'.html.setup {
  cmd = { "html-languageserver", "--stdio" },
  capabilities = capabilities,
}

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  { command = "isort", filetypes = { "python" } },
  {
    -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--print-with", "100" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "html", "typescript", "typescriptreact" },
  },
}

-- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  {
    command = "flake8",
    filetypes = { "python" },
    extra_args = { "--max-line-length", "100", "--ignore", "E265" },

  },
  {
    -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "shellcheck",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--severity", "warning" },
  },
  {
    command = "codespell",
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "javascript", "python" },
  },
}

-- Additional Plugins
lvim.plugins = {
  -- IPython
  {
    "jpalardy/vim-slime",
    cmd = { 'SlimeSend1' },
    config = function()
      vim.cmd("let g:slime_target = 'tmux'")
      vim.cmd("let g:slime_python_ipython = 1")
      vim.cmd("let g:slime_default_config = {'socket_name': get(split($TMUX, ','), 0), 'target_pane': '{top-right}' }")
      vim.cmd("let g:slime_dont_ask_default = 1")
    end,
  },
  {
    "hanschen/vim-ipython-cell",
    cmd = { 'IPythonCellExecuteCell' },
  },
  -- ranger
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
    end,
  },
  -- defx
  "kristijanhusak/defx-git",
  "kristijanhusak/defx-icons",
  {
    "Shougo/defx.nvim",
    config = function()
      vim.cmd([[
          nnoremap <silent>sf :<C-u>Defx -listed -resume
                \ `expand('%:p:h')` -search=`expand('%:p')`<CR>
          nnoremap <silent>fi :<C-u>Defx -new `expand('%:p:h')` -search=`expand('%:p')`<CR>

          autocmd FileType defx call Defx_my_settings()
          function Defx_my_settings() abort
            " Define mappings
            nnoremap <silent><buffer><expr> <CR>
            \ defx#do_action('open')
            nnoremap <silent><buffer><expr> c
            \ defx#do_action('copy')
            nnoremap <silent><buffer><expr> m
            \ defx#do_action('move')
            nnoremap <silent><buffer><expr> p
            \ defx#do_action('paste')
            nnoremap <silent><buffer><expr> l
            \ defx#do_action('open')
            nnoremap <silent><buffer><expr> E
            \ defx#do_action('open', 'vsplit')
            nnoremap <silent><buffer><expr> P
            \ defx#do_action('open', 'pedit')
            nnoremap <silent><buffer><expr> o
            \ defx#do_action('open_or_close_tree')
            nnoremap <silent><buffer><expr> K
            \ defx#do_action('new_directory')
            nnoremap <silent><buffer><expr> N
            \ defx#do_action('new_file')
            nnoremap <silent><buffer><expr> M
            \ defx#do_action('new_multiple_files')
            nnoremap <silent><buffer><expr> C
            \ defx#do_action('toggle_columns',
            \                'mark:indent:icon:filename:type:size:time')
            nnoremap <silent><buffer><expr> S
            \ defx#do_action('toggle_sort', 'time')
            nnoremap <silent><buffer><expr> d
            \ defx#do_action('remove')
            nnoremap <silent><buffer><expr> r
            \ defx#do_action('rename')
            nnoremap <silent><buffer><expr> !
            \ defx#do_action('execute_command')
            nnoremap <silent><buffer><expr> x
            \ defx#do_action('execute_system')
            nnoremap <silent><buffer><expr> yy
            \ defx#do_action('yank_path')
            nnoremap <silent><buffer><expr> .
            \ defx#do_action('toggle_ignored_files')
            nnoremap <silent><buffer><expr> ;
            \ defx#do_action('repeat')
            nnoremap <silent><buffer><expr> h
            \ defx#do_action('cd', ['..'])
            nnoremap <silent><buffer><expr> ~
            \ defx#do_action('cd')
            nnoremap <silent><buffer><expr> q
            \ defx#do_action('quit')
            nnoremap <silent><buffer><expr> <Space>
            \ defx#do_action('toggle_select') . 'j'
            nnoremap <silent><buffer><expr> *
            \ defx#do_action('toggle_select_all')
            nnoremap <silent><buffer><expr> j
            \ line('.') == line('$') ? 'gg' : 'j'
            nnoremap <silent><buffer><expr> k
            \ line('.') == 1 ? 'G' : 'k'
            nnoremap <silent><buffer><expr> <C-l>
            \ defx#do_action('redraw')
            nnoremap <silent><buffer><expr> <C-g>
            \ defx#do_action('print')
            nnoremap <silent><buffer><expr> cd
            \ defx#do_action('change_vim_cwd')
          endfunction

          call defx#custom#column('icon', {
                \ 'directory_icon': '▸',
                \ 'opened_icon': '▾',
                \ 'root_icon': ' ',
                \ })

          call defx#custom#column('git', 'indicators', {
            \ 'Modified'  : '✹',
            \ 'Staged'    : '✚',
            \ 'Untracked' : '✭',
            \ 'Renamed'   : '➜',
            \ 'Unmerged'  : '═',
            \ 'Ignored'   : '☒',
            \ 'Deleted'   : '✖',
            \ 'Unknown'   : '?'
            \ })
          
          " Setting for defx-icons
          let g:defx_icons_enable_syntax_highlight = 0
          let g:defx_icons_column_length = 2
          let g:defx_icons_directory_icon = ''
          let g:defx_icons_mark_icon = '*'
          let g:defx_icons_copy_icon = ''
          let g:defx_icons_move_icon = ''
          let g:defx_icons_parent_icon = ''
          let g:defx_icons_default_icon = ''
          let g:defx_icons_directory_symlink_icon = ''

          call defx#custom#option('_', {
            \ 'columns': 'indent:git:icon:icons:filename:type:size',
            \ 'winwidth': 40,
            \ 'show_ignored_files': 1,
            \ 'buffer_name': 'exlorer',
            \ 'toggle': 1,
            \ 'resume': 1,
            \ })

          ]])
    end,
  },
  -- outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
  },
  {
    "machakann/vim-sandwich"
  },
}

-- autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }

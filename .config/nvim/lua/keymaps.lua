local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Disable continuations
keymap.set("n", "<Leader>o", "o<Esc>^Da", opts)
keymap.set("n", "<Leader>O", "O<Esc>^Da", opts)

-- Jumplist
keymap.set("n", "<C-m>", "<C-i>", opts)

-- New tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)
-- Move window
keymap.set("n", "sh", "<C-w>h")
keymap.set("n", "sk", "<C-w>k")
keymap.set("n", "sj", "<C-w>j")
keymap.set("n", "sl", "<C-w>l")

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- Diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

vim.keymap.set('n', 'p', 'p`]', { desc = 'Paste and move the end' })
vim.keymap.set('n', 'P', 'P`]', { desc = 'Paste and move the end' })

vim.keymap.set('x', 'p', 'P', { desc = 'Paste without change register' })
vim.keymap.set('x', 'P', 'p', { desc = 'Paste with change register' })

vim.keymap.set({ 'n', 'x' }, 'x', '"_d', { desc = 'Delete into blackhole' })
vim.keymap.set('n', 'X', '"_D', { desc = 'Delete into blackhole' })
vim.keymap.set('o', 'x', 'd', { desc = 'Delete using x' })

vim.keymap.set('c', '<c-b>', '<left>', { desc = 'Emacs like left' })
vim.keymap.set('c', '<c-f>', '<right>', { desc = 'Emacs like right' })
vim.keymap.set('c', '<c-a>', '<home>', { desc = 'Emacs like home' })
vim.keymap.set('c', '<c-e>', '<end>', { desc = 'Emacs like end' })
vim.keymap.set('c', '<c-h>', '<bs>', { desc = 'Emacs like bs' })
vim.keymap.set('c', '<c-d>', '<del>', { desc = 'Emacs like del' })

vim.keymap.set('n', '<space>;', '@:', { desc = 'Re-run the last command' })

vim.keymap.set('n', '<space>w', '<cmd>write<cr>', { desc = 'Write' })

vim.keymap.set({ 'n', 'x' }, 'so', ':source<cr>', { silent = true, desc = 'Source current script' })

vim.keymap.set('n', 'H', '<cmd>bprev<cr>', { desc = 'Emacs like del' })
vim.keymap.set('n', 'L', '<cmd>bnext<cr>', { desc = 'Emacs like del' })


vim.keymap.set('c', '<c-n>', function()
  return vim.bool_fn.wildmenumode() and '<c-n>' or '<down>'
end, { expr = true, desc = 'Select next' })
vim.keymap.set('c', '<c-p>', function()
  return vim.bool_fn.wildmenumode() and '<c-p>' or '<up>'
end, { expr = true, desc = 'Select previous' })

vim.keymap.set('n', '<space>q', function()
  if not pcall(vim.cmd.tabclose) then
    vim.cmd.quit()
  end
end, { desc = 'Quit current tab or window' })

vim.keymap.set('n', 'q:', '<nop>', { desc = 'Disable cmdwin' })

-- abbreviation only for ex-command
local function abbrev_excmd(lhs, rhs, opts)
  vim.keymap.set('ca', lhs, function()
    return vim.fn.getcmdtype() == ':' and rhs or lhs
  end, vim.tbl_extend('force', { expr = true }, opts))
end

abbrev_excmd('qw', 'wq', { desc = 'fix typo' })
abbrev_excmd('lup', 'lua =', { desc = 'lua print' })

-- terminal mode
-- keymap.del("t", "<C-h>", nil)
-- keymap.del("t", "<C-k>", nil)

local M = {}

local keymap = vim.keymap.set

local function keymappings(client, bufnr)
  -- Key mappings
  keymap("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
end

function M.setup(client, bufnr)
  keymappings(client, bufnr)
end

return M

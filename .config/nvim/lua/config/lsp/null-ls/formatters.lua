local M = {}

local nls_sources = require("null-ls.sources")
local api = vim.api

local method = require("null-ls").methods.FORMATTING

function M.format()
  local view = vim.fn.winsaveview()
  print(view)
  vim.lsp.buf.format({
    async = true,
    filter = function(client)
      return client.name ~= "tsserver"
          and client.name ~= "jsonls"
          and client.name ~= "html"
          and client.name ~= "sumneko_lua"
          and client.name ~= "jdt.ls"
      -- and client.name ~= "kotlin_language_server"
    end,
  })
  vim.fn.winrestview(view)
  print("Buffer formatted")
end

function M.setup(client, bufnr)
  local filetype = api.nvim_buf_get_option(bufnr, "filetype")

  local enable = false
  if M.has_formatter(filetype) then
    enable = client.name == "null-ls"
  else
    enable = not (client.name == "null-ls")
  end

  client.server_capabilities.documentFormattingProvder = enable
  client.server_capabilities.documentRangeFormattingProvider = enable
  if client.server_capabilities.documentFormattingProvider then
    local lsp_format_grp = api.nvim_create_augroup("LspFormat", { clear = true })
    api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        vim.lsp.buf.formatting_seq_sync()
      end,
      group = lsp_format_grp,
      buffer = bufnr,
    })
  end
end

function M.has_formatter(filetype)
  local available = nls_sources.get_available(filetype, method)
  return #available > 0
end

return M

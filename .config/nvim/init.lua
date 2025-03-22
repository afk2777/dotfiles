-- bootstrap lazy.nvim, LazyVim and your plugins
if vim.g.vscode then
  -- VS Code経由の設定
  vim.opt.clipboard = "unnamedplus" -- システムクリップボードを使う
  vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
else
  require("config.lazy")
end

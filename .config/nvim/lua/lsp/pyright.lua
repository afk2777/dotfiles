return {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },

  -- プロジェクトに pyproject.toml 等が無い場合は軽量モードに切り替える
  on_init = function(client)
    local root = client.workspace_folders
                 and client.workspace_folders[1]
                 and client.workspace_folders[1].name
                 or ''
    if root ~= ''
      and not (vim.uv.fs_stat(root .. '/pyproject.toml')
           or vim.uv.fs_stat(root .. '/setup.py')
           or vim.uv.fs_stat(root .. '/requirements.txt')) then
      client.config.settings.python.analysis.indexing = false
      client.notify('workspace/didChangeConfiguration')
    end
  end,

  settings = {
    python = {
      analysis = {
        typeCheckingMode = 'basic',   -- “off” | “basic” | “strict”
        autoSearchPaths   = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
}


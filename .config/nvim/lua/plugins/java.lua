return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      full_cmd = function(opts)
        local fname = vim.api.nvim_buf_get_name(0)
        local root_dir = opts.root_dir(fname)
        local project_name = opts.project_name(root_dir)
        local cmd = vim.deepcopy(opts.cmd)
        if project_name then
          vim.list_extend(cmd, {
            "-configuration",
            opts.jdtls_config_dir(project_name),
            "-data",
            opts.jdtls_workspace_dir(project_name),
          })
        end
        -- LombokのJVM引数を追加
        local lombok_jar_path = vim.fn.expand("~/.config/nvim/dependencies/lombok.jar")
        table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar_path)
        return cmd
      end,
    },
  },
}

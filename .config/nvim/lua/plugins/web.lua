return {
  {
    "barrett-ruth/live-server.nvim",
    build = "pnpm add -g live-server",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
    opts = {
      args = { "--port=8082" },
    },
  },
}

local M = {}

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
    profile = {
      enable = true,
      threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },

    display = {
      open_fn = function()
        return require("packer.util").float({ border = "rounded" })
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      })
      vim.cmd([[packadd packer.nvim]])
    end

    -- Run PackerCompile if there are changes in this file
    -- vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
    local packer_grp = vim.api.nvim_create_augroup("packer_user_config", { clear = true })
    vim.api.nvim_create_autocmd(
      { "BufWritePost" },
      { pattern = "init.lua", command = "source <afile> | PackerCompile", group = packer_grp }
    )
  end

  -- Plugins
  local function plugins(use)
    use("wbthomason/packer.nvim")
    -- LSP
    use({
      "neovim/nvim-lspconfig",
      event = { "BufNewFile", "BufReadPre" },
      opt = true,
      wants = {
        "mason.nvim",
        "mason-lspconfig.nvim",
        "mason-tool-installer.nvim",
        "cmp-nvim-lsp",
        "lua-dev.nvim",
        "vim-illuminate", -- highlight
        "null-ls.nvim",
        "schemastore.nvim",
        "typescript.nvim",
        "inlay-hints.nvim", -- 関数の引数の表示等
      },
      config = function()
        require("config.lsp").setup()
      end,
      requires = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "folke/lua-dev.nvim",
        "RRethy/vim-illuminate",
        "jose-elias-alvarez/null-ls.nvim",
        "b0o/schemastore.nvim",
        "jose-elias-alvarez/typescript.nvim",
        {
          "simrat39/inlay-hints.nvim",
          config = function()
            require("inlay-hints").setup()
          end,
        },
      },
    })
    use({
      "glepnir/lspsaga.nvim",
      cmd = { "Lspsaga" },
      branch = "main",
      config = function()
        require("lspsaga").setup({
          code_action_lightbulb = {
            enable = false,
          },
        })
      end,
      requires = {
        { "nvim-tree/nvim-web-devicons" },
        --Please make sure you install markdown and markdown_inline parser
        { "nvim-treesitter/nvim-treesitter" },
      },
    })
    -- Refactoring
    use({
      "ThePrimeagen/refactoring.nvim",
      module = { "refactoring", "telescope" },
      keys = { [[<leader>r]] },
      config = function()
        require("config.refactoring").setup()
      end,
    })
    use({ "python-rope/ropevim", run = "pip install ropevim", disable = true })
    use({
      "kevinhwang91/nvim-bqf",
      ft = "qf",
      disable = false,
      config = function()
        require("bqf").setup()
      end,
    })
    use({ "kevinhwang91/nvim-hlslens", event = "BufReadPre", disable = true })
    use({ "nvim-pack/nvim-spectre", module = "spectre", keys = { "<leader>s" } })
    use({
      "https://gitlab.com/yorickpeterse/nvim-pqf",
      event = "BufReadPre",
      config = function()
        require("pqf").setup()
      end,
    })
    use({
      "andrewferrier/debugprint.nvim",
      module = { "debugprint" },
      keys = { "g?p", "g?P", "g?v", "g?V", "g?o", "g?O" },
      cmd = { "DeleteDebugPrints" },
      config = function()
        require("debugprint").setup()
      end,
    })
    -- Code docStrings
    use({
      "danymat/neogen",
      config = function()
        require("config.neogen").setup()
      end,
      cmd = { "Neogen" },
      module = "neogen",
      disable = false,
    })
    -- completion
    use({
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      opt = true,
      config = function()
        require("config.cmp").setup()
      end,
      wants = { "LuaSnip" },
      requires = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "onsails/lspkind-nvim",
        {
          "L3MON4D3/LuaSnip",
          wants = { "friendly-snippets", "vim-snippets" },
          config = function()
            require("config.snip").setup()
          end,
        },
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
      },
    })
    -- code highlight
    use({
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("config.treesitter").setup()
      end,
    })
    use({
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("nvim-web-devicons").setup({
          override = {},
          default = true,
        })
      end,
    }) -- File icons
    -- file browser
    use({
      "nvim-telescope/telescope.nvim",
      config = function()
        require("config.telescope").setup()
      end,
    })
    use("nvim-telescope/telescope-file-browser.nvim")
    -- other
    use({
      "windwp/nvim-autopairs",
      opt = true,
      event = "InsertEnter",
      wants = "nvim-treesitter",
      module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
      config = function()
        require("config.autopairs").setup()
      end,
    })
    use({
      "windwp/nvim-ts-autotag",
      opt = true,
      wants = "nvim-treesitter",
      event = "InsertEnter",
      config = function()
        require("nvim-ts-autotag").setup({ enable = true })
      end,
    })
    use({
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
    })
    use("machakann/vim-sandwich")
    -- design
    use({
      "svrana/neosolarized.nvim",
      requires = { "tjdevries/colorbuddy.nvim" },
      config = function()
        require("config.neosolarized").setup()
      end,
    })
    use({
      "nvim-lualine/lualine.nvim",
      config = function()
        require("config.lualine").setup()
      end,
    })
    use({
      "akinsho/nvim-bufferline.lua", -- Statusline
      config = function()
        require("config.bufferline").setup()
      end,
    })
    use({
      "norcalli/nvim-colorizer.lua", -- tab design
      config = function()
        require("colorizer").setup({ "*" })
      end,
    })
    -- git
    use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" })
    use({
      "lewis6991/gitsigns.nvim",
      event = "BufReadPre",
      wants = "plenary.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("config.gitsigns").setup()
      end,
    })
    use({
      "dinhhuy258/git.nvim",
      config = function()
        require("config.git").setup()
      end,
    }) -- For git blame & browse
    use({
      "sindrets/diffview.nvim",
      requires = "nvim-lua/plenary.nvim",
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
    })
    -- Better code Comment
    use("JoosepAlviste/nvim-ts-context-commentstring")
    use({
      "numToStr/Comment.nvim",
      keys = { "gc", "gcc", "gbc" },
      config = function()
        require("config.comment").setup()
      end,
    })
    use({
      "jpalardy/vim-slime-ext-plugins",
      setup = function()
        --[[   "let g:slime_default_config = {'socket_name': get(split($TMUX, ','), 0), 'target_pane': '{top-right}' }" ]]
        vim.cmd("let g:ipython_cell_send_ctrl_c = 0")
      end,
    })
    use({
      "Klafyvel/vim-slime-ext-wezterm",
      config = function()
        vim.g.slime_bracketed_paste = 0
        vim.g.slime_target_send = "slime_wezterm#send"
        vim.g.slime_target_config = "slime_wezterm#config"
      end,
    })
    use({
      "hanschen/im-ipython-cell",
      cmd = { "IPythonCellExecuteCell" },
    })
    -- TODO
    use({
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup()
      end,
    })
    -- easy motion
    use({
      "phaazon/hop.nvim",
      branch = "v2", -- optional but strongly recommended
      config = function()
        -- you can configure Hop the way you like here; see :h hop-config
        require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
      end,
    })
    use({
      "akinsho/toggleterm.nvim",
      tag = "*",
      config = function()
        require("toggleterm").setup()
      end,
    })
    if packer_bootstrap then
      print("Neovim restart is required after installation!")
      require("packer").sync()
    end
  end

  -- Init and start packer
  packer_init()
  local packer = require("packer")

  -- Performance
  pcall(require, "impatient")
  -- pcall(require, "packer_compiled")

  packer.init(conf)
  packer.startup(plugins)
end

return M

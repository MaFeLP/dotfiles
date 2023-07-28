-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- fix error when loading the latest LanguageTool version
-- TODO: Fork and update to latest version
vim.g.grammarous_jar_url = 'https://www.languagetool.org/download/LanguageTool-5.9.zip'

require("lazy").setup({
  -- Autocompletion Engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      -- ...
    end,
  },

  -- File finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- speed up the scoring process
      {
        "nvim-telescope/telescope-fzf-native.nvim",
	build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      },
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- Treesitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
    end
  },

  "editorconfig/editorconfig-vim",               -- Add editorconfig support

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },

  {                                                  -- Status Line
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      theme = "powerline_dark",
    },
  },

  --"folke/which-key.nvim",
  --use 'neovim/nvim-lspconfig'                        -- Configurations for Nvim LSP

  -- LSP Configs
  {
    "williamboman/mason.nvim",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
	    config = function (plugin, opts)
          -- Do not set up mason-lspconfig here, but instead after mason itself
	    end,
      },
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-lint",                        -- Neovim linter
      "mhartington/formatter.nvim"
    },
    config = function (plugin, opts)
      require("mason").setup(opts)
      require("mason-lspconfig").setup()
    end,
    lazy = false,
  },

  -- Spell Checking
  'rhysd/vim-grammarous',

  -- Colorschemes
  { "dracula/vim", lazy = true, name = "dracula" },  -- Dracula color scheme
  { "doums/darcula", lazy = true},                   -- JetBrains Color Scheme
  { "Mofiqul/vscode.nvim", lazy = true},             -- VSCode Color Scheme
})


-- Install packages with packer
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'                       -- Plugin Manager manages itself
  use 'neovim/nvim-lspconfig'                        -- Configurations for Nvim LSP
  use 'editorconfig/editorconfig-vim'                -- Add editorconfig support
  use {                                              -- file explorer
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons'        -- filesystem icons
  }
  use {                                              -- Status Line
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    cmd = "TSUpdate"
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' }
    }
  }

  -- AutoCompletion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  -- Colorschemes
--  use {
--    'dracula/vim',
--    as = 'dracula',
--  }
  use 'doums/darcula'                                -- JetBrains Color Scheme
--  use 'Mofiqul/vscode.nvim'                          -- VSCode Color Scheme
end)


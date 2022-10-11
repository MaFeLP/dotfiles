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
end)


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

  -- Treesitter configuration
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()

      -- Workaround for folding sometimes not working
      -- See https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim for more information
      vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
        group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
        callback = function()
          vim.opt.foldmethod     = 'expr'
          vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
        end
      })

      require'nvim-treesitter.configs'.setup {
        ensure_installed = { "qmljs", "regex", "toml" },
        sync_install = false,
        hightlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        }
      }
    end,
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


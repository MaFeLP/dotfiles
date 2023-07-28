-- Add install dir of package to the execution path
package.path = package.path..";/usr/share/neovim-config/?.lua"

-- Set the leader key
vim.g.mapleader = " "

-- Other config files
require 'plugins'
require 'keys'
require 'opt'

-- Set up language servers
require 'lsp'

-- TODO make color scheme toggleable easily
-- For color scheme 'vscode':
--require('vscode').setup{}
-- and change theme to 'vscode'
--require('lualine').setup{
--  options = { theme = "powerline_dark" }
--}

-- Maybe add config for later:
-- Vim-Snip: https://github.com/hrsh7th/vim-vsnip
-- dashboard-nvim: https://github.com/glepnir/dashboard-nvim

-- Treesitter configuration
require'nvim-treesitter.configs'.setup{
  ensure_installed = { "regex" },
  auto_install = true,  -- install modules, when entering a buffer
  highlight = {
    enable = true,
    disable = { "markdown" },  -- NeoVim's built-in markdown highlither is somehow superior...
  },
}

-- Use Treesitter to create automatic folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"


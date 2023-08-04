-- Add install dir of package to the execution path
package.path = package.path..";/usr/share/neovim-config/?.lua"

-- Netrw is the default file browser, but we don't need it with nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set the leader key
vim.g.mapleader = " "

-- Configure plugins
require 'plugins'
require 'opt'

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


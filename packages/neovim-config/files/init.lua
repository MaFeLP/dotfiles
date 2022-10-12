-- Add install dir of package to the execution path
package.path = package.path..";/usr/share/neovim-config/?.lua"

-- Other config files
require 'plug'
require 'keys'
require 'opt'

-- Set up plugins
require('nvim-tree').setup{}
require("lsp")

-- TODO make color scheme toggleable easily
-- For color scheme 'vscode':
--require('vscode').setup{}
-- and change theme to 'vscode'
require('lualine').setup{
  options = { theme = "powerline_dark" }
}

-- Maybe add config for later:
-- Vim-Snip: https://github.com/hrsh7th/vim-vsnip
-- dashboard-nvim: https://github.com/glepnir/dashboard-nvim


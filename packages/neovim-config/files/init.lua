-- Vimplug Vim Plugin Manager
package.path = package.path..";/usr/share/neovim-config/?.lua"
require "plug"

-- Enabled Rust functionalities
-- syntax enable
-- filetype plugin indent on

vim.opt.number = true   -- Adds line numbers

vim.opt.ignorecase = true          -- Make searching case insensitive
vim.opt.smartcase = true           -- ... unless the query has capital letters.
vim.opt.gdefault = true            -- Use 'g' flag by default with :s/foo/bar/.
vim.opt.encoding="UTF-8"           -- Enable UFT-8 encoding
vim.opt.tabstop = 4                -- length of an actual \t character:

-- Enable other non-printable characters
-- TODO make this into a toggle
vim.opt.list = true
vim.opt.listchars="eol:⏎,tab:⇥\\ ,trail:␠,space:⸳"
-- Make tab characters different
--vim.g.indentLine_char_list = ['|', '¦', '┆', '┊']

-- Enable powerline fonts for the status bar
vim.g.airline_powerline_fonts = 1

-- Create file explorer keybinding
vim.api.nvim_set_keymap('i', 'jk', '', {}) -- remap the key used to leave insert mode
vim.api.nvim_set_keymap('n', 'n', [[:NvimTreeToggle]], {}) -- Toggle nvim-tree

require("lsp")
require('nvim-tree').setup{}
require('lualine').setup{
  options = { theme = "powerline_dark" }
}

-- Treesitter: https://github.com/nvim-treesitter/nvim-treesitter
-- Telescope: https://github.com/nvim-telescope/telescope.nvim
-- Vim-Snip: https://github.com/hrsh7th/vim-vsnip
-- AutoCompletion:
--   https://github.com/hrsh7th/nvim-cmp/
--   https://github.com/ms-jpq/coq_nvim
-- QML Language server?: https://invent.kde.org/sdk/qml-lsp

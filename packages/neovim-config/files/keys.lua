-- Create file explorer keybinding
vim.api.nvim_set_keymap('i', 'jk', '', {}) -- remap the key used to leave insert mode
vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>NvimTreeToggle<CR>', {}) -- Toggle nvim-tree

-- Telescope File Finder
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', builtin.find_files, {})
vim.keymap.set('n', 'fg', builtin.live_grep, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})


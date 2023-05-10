-- Create file explorer keybinding
vim.api.nvim_set_keymap('i', 'jk', '', {}) -- remap the key used to leave insert mode
vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>NvimTreeToggle<CR>', {}) -- Toggle nvim-tree

-- Telescope File Finder
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})

vim.api.nvim_set_keymap('n', '<leader>gg', ':GrammarousCheck<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>go', '<Plug>(grammarous-open-info-window)', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gc', '<Plug>(grammarous-close-info-window)', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<Leader>gf', '<Plug>(grammarous-fixit)', { noremap = true })


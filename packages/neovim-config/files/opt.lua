local opt = vim.opt
opt.number = true              -- Adds line numbers
opt.ignorecase = true          -- Make searching case insensitive
opt.smartcase = true           -- ... unless the query has capital letters.
opt.gdefault = true            -- Use 'g' flag by default with :s/foo/bar/.
opt.encoding="UTF-8"           -- Enable UFT-8 encoding
opt.tabstop = 4                -- length of an actual \t character:
opt.termguicolors = true       -- Make colors nice

-- Enable other non-printable characters
-- TODO make this into a toggle
opt.list = true
opt.listchars="eol:⏎,tab:⇥ ,trail:␠,space:⸳"
-- Make tab characters different
--vim.g.indentLine_char_list = ['|', '¦', '┆', '┊']

-- Enable powerline fonts for the status bar
vim.g.airline_powerline_fonts = 1

vim.cmd 'colorscheme darcula'

vim.cmd 'hi CursorLineNr guifg=#ffa500'
opt.cursorline = true
opt.cursorlineopt = 'number'

vim.cmd 'filetype on'
vim.filetype.add({
  extension = {
    qml = 'qmljs',
  }
})


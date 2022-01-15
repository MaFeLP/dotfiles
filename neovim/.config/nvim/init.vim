" Vimplug Vim Plugin Manager
source $HOME/.config/nvim/plugins.vim

" Adds LaTeX support
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'tex': g:vimtex#re#deoplete
      \})

" Enabled Rust functionalities
syntax enable
filetype plugin indent on

set number              " Adds line numbers

set ignorecase          " Make searching case insensitive
set smartcase           " ... unless the query has capital letters.
set gdefault            " Use 'g' flag by default with :s/foo/bar/.
set encoding=UTF-8	" Enable UFT-8 encoding

let g:airline_powerline_fonts = 1

set list
set listchars=eol:⏎,tab:⇥\ ,trail:␠,space:⸳

let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" length of an actual \t character:
set tabstop=4


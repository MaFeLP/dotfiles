if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    "Plug 'roxma/vim-hug-neovim-rpc'
  endif
  let g:deoplete#enable_at_startup = 1

  "Latex
  Plug 'lervag/vimtex'
  Plug 'Konfekt/FastFold'
  "Plug 'matze/vim-tex-fold'

  "Nice Line at the bottom
  Plug 'hugolgst/vimsence'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

  "Rust completion
  Plug 'rust-lang/rust.vim'

  "Editorconfig
  Plug 'editorconfig/editorconfig-vim'

  "Nice indentation and word wrapping
  "Plug 'Yggdroot/indentLine'

call plug#end()

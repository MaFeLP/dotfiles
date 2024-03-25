-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Autocompletion Engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      -- ...
    end,
  },

  -- File finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- speed up the scoring process
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      },
      "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
    keys = {
      { "<leader>ff", function() require('telescope.builtin').find_files() end, desc = "File" },
      { "<leader>fg", function() require('telescope.builtin').live_grep() end, desc = "Grep File" },
      { "<leader>fb", function() require('telescope.builtin').buffers() end, desc = "Buffer" },
      { "<leader>fh", function() require('telescope.builtin').help_tags() end, desc = "Help Pages" },
    },
  },

  -- Treesitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    config = function ()
      require("nvim-treesitter.configs").setup({
          ensure_installed = { "lua", "vim", "vimdoc", "regex", "javascript", "html" },
          sync_install = false,
          indent = { enable = true },
          auto_install = true,  -- install modules, when entering a buffer
          highlight = {
            enable = true,
            disable = { "markdown" },  -- NeoVim's built-in markdown highlither is somehow superior...
          },
        })
        -- Use Treesitter to create automatic folds
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true
    end,
    lazy = false,
  },

  "editorconfig/editorconfig-vim",               -- Add editorconfig support

  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
    keys = {
      { "<C-f>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle the File explorer" },
--    { "<leader>f", "<cmd>NvimTreeToggle<cr>", desc = "Toggle the File explorer" },
    },
  },

  {                                                  -- Status Line
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      theme = "powerline_dark",
    },
  },

  -- LSP Configs
  {
    'RubixDev/mason-update-all',
    lazy = true,
    cmd = "MasonUpdateAll",
    config = function ()
      require('mason-update-all').setup()
    end,
    dependencies = {
      "williamboman/mason.nvim",
      dependencies = {
        {
          "williamboman/mason-lspconfig.nvim",
          config = function ()
            -- Do not set up mason-lspconfig here, but instead after mason itself
          end,
        },
        "neovim/nvim-lspconfig",
        { -- Linter
          "jose-elias-alvarez/null-ls.nvim",
          dependencies = { "nvim-lua/plenary.nvim" },
        },
      },
      config = function ()
        require 'lsp'
      end,
      lazy = false,
    },
  },

  -- Formatter
  {
    "mhartington/formatter.nvim",
    keys = {
      {"<leader>F", "<cmd>Format<cr>", desc = "Format the current buffer" },
    },
    lazy = true,
  },

  -- Debugger
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      {
        "mfussenegger/nvim-dap",
        lazy = true,
      },
      {
        "nvim-neotest/nvim-nio",
        lazy = true,
      },
    },
    event = "VeryLazy",
    keys = {
      { "<leader>dO", function() require'dapui'.open() end, desc = "Open debugger" },
      { "<leader>dC", function() require'dapui'.close() end, desc = "Close debugger window" },
      { "<leader>dT", function() require'dapui'.toggle() end, desc = "Toggle debugger window" },
      { "<leader>db", function() require'dap'.toggle_breakpoint() end, desc = "Breakpoint set/unset" },
      { "<leader>dc", function() require'dap'.continue() end, desc = "Continue Debugging" },
      { "<leader>dd", function() require'dap'.step_over() end, desc = "Step over current line" },
      { "<leader>ds", function() require'dap'.step_into() end, desc = "Step into current line" },
      { "<leader>dr", function() require'dap'.repl.open() end, desc = "Open REPL here" },
    },
    config = function ()
      require("dapui").setup()

      -- Setup dapui to respond to DAP events
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  -- Buffer with diagnostics data
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    keys = {
        { "<leader>xx", function() require('trouble').open() end, desc = "Open Diagnostics Window" },
        { "<leader>xw", function() require('trouble').open('workspace_diagnostics') end, desc = "Open Workspace Diagnostics" },
        { "<leader>xd", function() require('trouble').open('document_diagnostics') end, desc = "Open Document Diagnostics" },
        { "<leader>xq", function() require('trouble').open('quickfix') end, desc = "Show Quick Fixes" },
        { "<leader>xl", function() require('trouble').open('loclist') end, desc = "Window Locations" },
        { "<leader>xr", function() require('trouble').open('lsp_references') end, desc = "Show references" },
        { "<leader>xd", function() require('trouble').open('lsp_definitions') end, desc = "Show references" },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
        local wk = require("which-key")
        wk.setup()

        wk.register({
          ["<leader>f"] = { name = "Find ..." },
          ["<leader>x"] = { name = "Diagnostics ..." },
          ["<leader>d"] = { name = "Debugging ..." },
          ["<leader>g"] = { name = "Grammar ..." },
        })
    end,
  },

  -- Spell Checking
  {
    'rhysd/vim-grammarous',
    lazy = true,
    keys = {
      { "<leader>gg", "<cmd>GrammarousCheck<cr>", desc = "Start Grammar Check" },
      { "<leader>go", "<Plug>(grammarous-open-info-window)", desc = "Open Grammar Window" },
      { "<leader>gc", "<Plug>(grammarous-close-info-window)", desc = "Close Grammar Window" },
      { "<Leader>gf", "<Plug>(grammarous-fixit)", desc = "Fix grammar mistake" },
    },
    init = function()
      -- fix error when loading the latest LanguageTool version
      -- TODO: Fork and update to latest version
      vim.g.grammarous_jar_url = 'https://www.languagetool.org/download/LanguageTool-5.9.zip'
    end,
  },

  -- Colorschemes
  { "dracula/vim", lazy = true, name = "dracula" },  -- Dracula color scheme
  { "doums/darcula", lazy = true},                   -- JetBrains Color Scheme
  { "Mofiqul/vscode.nvim", lazy = true},             -- VSCode Color Scheme
})


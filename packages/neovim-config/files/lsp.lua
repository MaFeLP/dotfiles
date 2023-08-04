require("mason").setup()
require("mason-lspconfig").setup()

-- NOTE:
-- to enable C++ LSP with cmake, run the two following commands:
--
-- cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1
-- ln -s <build_dir>/compile_commands.json <project_dir>/compile_commands.json

-- Register Mason to setup all language servers
require("mason-lspconfig").setup_handlers {
  function (server_name)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    require("lspconfig")[server_name].setup {
      capabilities = capabilities,
    }
  end,

  -- add more file names to the bash language server
  ["bashls"] = function ()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    require"lspconfig".bashls.setup {
      cmd_env = {
        GLOB_PATTERN = "*@(.sh|.inc|.bash|.zsh|.command)",
      },
      capabilities = capabilities,
    }
  end,
}

-- Setup Code completion with cmp
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
--    { name = 'cmdline' },
    { name = 'emoji' },
--    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'treesitter' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline(':', {
  sources = {
    { name = 'cmdline' }
  }
})
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})
cmp.setup.filetype('markdown', {
  sources = cmp.config.sources({
    { name = 'buffer' },
  })
})


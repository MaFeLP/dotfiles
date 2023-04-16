-- Get capabilities from completion engine
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Bash files
require'lspconfig'.bashls.setup{
  cmd_env = {
    GLOB_PATTERN = "*@(.sh|.inc|.bash|.zsh|.command)"
  },
  capabilities = capabilities,
}

-- C++ files
-- Use the following commands to enable this language server:
--
-- cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1
-- ln -s <build_dir>/compile_commands.json <project_dir>/compile_commands.json
require'lspconfig'.clangd.setup{
  capabilities = capabilities,
}

-- CMake Projects
require'lspconfig'.cmake.setup{
  capabilities = capabilities,
}

-- CSS files
require'lspconfig'.cssls.setup{
  capabilities = capabilities,
}

-- Dart files
require'lspconfig'.dartls.setup{
  capabilities = capabilities,
}

-- Dockerfile
require'lspconfig'.dockerls.setup{
  capabilities = capabilities,
}

-- GOlang
require'lspconfig'.gopls.setup{
  capabilities = capabilities,
}

-- HTML & JSON
-- Enable (broadcasting) snippet capability for completion
--capabilities.textDocument.completion.completionItem.snippetSupport = true
require'lspconfig'.html.setup {
  capabilities = capabilities,
}
require'lspconfig'.jsonls.setup {
  capabilities = capabilities,
}

-- Java
require'lspconfig'.java_language_server.setup{
  cmd = { "/usr/bin/java-language-server" },
  capabilities = capabilities,
}

-- JavaScript & Typescript files
vim.g.markdown_fenced_languages = { "ts=typescript" }
require'lspconfig'.denols.setup{
  capabilities = capabilities,
}

-- LaTeX
require'lspconfig'.texlab.setup{
  capabilities = capabilities,
}

-- Lua
require'lspconfig'.lua_ls.setup{
  capabilities = capabilities,
}

-- Python
require'lspconfig'.pyright.setup{
  capabilities = capabilities,
}

-- QML
require'lspconfig'.qml_lsp.setup{
  cmd = { "/usr/bin/qmlls6" },
  capabilities = capabilities,
}

-- Rust
require'lspconfig'.rust_analyzer.setup{
  capabilities = capabilities,
}

-- SQL
require'lspconfig'.sqlls.setup{
  capabilities = capabilities,
}

-- YAML
require'lspconfig'.texlab.setup{
  capabilities = capabilities,
}


-- Do the LSP Server Setup
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
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'cmdline' },
    { name = 'emoji' },
    { name = 'nvim_lua' },
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


-- Bash files
require'lspconfig'.bashls.setup{
  cmd_env = {
    GLOB_PATTERN = "*@(.sh|.inc|.bash|.zsh|.command)"
  }
}

-- C++ files
-- Use the following commands to enable this language server:
--
-- cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1
-- ln -s <build_dir>/compile_commands.json <project_dir>/compile_commands.json
require'lspconfig'.clangd.setup{}

-- CMake Projects
require'lspconfig'.cmake.setup{}

-- CSS files
require'lspconfig'.cssls.setup{}

-- Dart files
require'lspconfig'.dartls.setup{}

-- JavaScript & Typescript files
vim.g.markdown_fenced_languages = {
  "ts=typescript"
}
require'lspconfig'.denols.setup{}

-- Dockerfile
require'lspconfig'.dockerls.setup{}

-- GOlang
require'lspconfig'.gopls.setup{}


-- HTML & JSON
-- TODO add snippet client
-- --Enable (broadcasting) snippet capability for completion
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- 
-- require'lspconfig'.html.setup {
--   capabilities = capabilities,
-- }
-- require'lspconfig'.jsonls.setup {
--   capabilities = capabilities,
-- }

-- Java
--require'lspconfig'.java_language_server.setup{
--  cmd = "/usr/bin/java-language-server"
--}

-- Python
require'lspconfig'.pyright.setup{}

-- Rust
require'lspconfig'.rust_analyzer.setup{}

-- SQL
require'lspconfig'.sqlls.setup{}

-- Lua
require'lspconfig'.sumneko_lua.setup{}

-- LaTeX
require'lspconfig'.texlab.setup{}

-- YAML
require'lspconfig'.texlab.setup{}


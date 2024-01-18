-- Little hack for vimls to shut up on most lines. vim is technically an undefined global...
vim = vim

require('mason').setup {
  registries = {
    'lua:mason-registry.index',
    'github:mason-org/mason-registry',
  },
}
require('mason-registry').refresh()

local servers = {
  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        hint = {
          enable = true,
        },
      },
    },
  },
  -- Rust
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        imports = {
          prefix = 'self',
        },
        cargo = {
          buildScripts = { enable = true },
          features = 'all',
        },
        procMacro = { enable = true },
        workspace = {
          symbol = {
            search = {
              kind = 'all_symbols',
              scope = 'workspace_and_dependencies',
            },
          },
        },
      },
    },
  },
  -- JSON, JSON5
  jsonls = {},
  -- Shell, bash
  bashls = {},
  -- C, C++
  clangd = {},
  -- Dockerfile / docker-compose
  dockerls = {},
  -- Python
  pyright = {
    settings = {
      pyright = {
        disableLanguageServices = true,
      },
    },
  },
  jedi_language_server = {},
  -- TOML
  taplo = {},
  -- Golang
  gopls = {},
  -- Elixir
  elixirls = {},
}
local servers_keys = {}
for k, _ in pairs(servers) do
  table.insert(servers_keys, k)
end
local lsp_zero = require('lsp-zero')
require('mason-lspconfig').setup {
  ensure_installed = servers_keys,
  handlers = {
    lsp_zero.default_setup,
  },
}

lsp_zero.on_attach(function (client, bufnr)
  vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.declaration, { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<Leader>gD', vim.lsp.buf.definition, { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<Leader>t', vim.lsp.buf.rename, { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<Leader>ac', vim.lsp.buf.code_action, { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<Leader>dj', vim.diagnostic.goto_next, { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<Leader>dk', vim.diagnostic.goto_prev, { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { silent = true, buffer = bufnr })

  local augroup_id = vim.api.nvim_create_augroup('CustomLspOnAttach', { clear = false })
  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup_id })
  vim.api.nvim_create_autocmd('CursorHoldI', {
    buffer = bufnr,
    callback = function()
      if client.server_capabilities.signatureHelpProvider then
        vim.lsp.buf.signature_help()
      end
    end
  })
end)

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)

-- Stop diagnostics from taking over focus.
vim.diagnostic.config({ float = { focusable = false } })

local lsp = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
for server, server_params in pairs(servers) do
  local params = {
    handlers = {
      ['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          signs = false,
          virtual_text = false,
          underline = true,
        }
      ),
      ['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          silent = true,
          focusable = false,
        }
      ),
      -- ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false }),
    },
    capabilities = capabilities,
  }
  local effective_params = vim.tbl_deep_extend('force', params, server_params)
  lsp[server].setup(effective_params)
end

local cmp = require('cmp')
cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  formatting = lsp_zero.cmp_format(),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'nvim_lua' },
  }, {
    { name = 'buffer' },
  }),
}

lsp_zero.setup()

vim.diagnostic.config({
  virtual_text = true
})

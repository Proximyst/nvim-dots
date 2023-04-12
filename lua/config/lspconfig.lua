-- Little hack for vimls to shut up on most lines. vim is technically an undefined global...
vim = vim

local servers = {
  -- Lua
  lua_ls = {},
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
  pyright = {},
  -- TOML
  taplo = {},
}
local servers_keys = {}
for k, _ in pairs(servers) do
  table.insert(servers_keys, k)
end
require('mason-lspconfig').setup { ensure_installed = servers_keys }
local lsp = require('lspconfig')
local coq_wrap = require('coq').lsp_ensure_capabilities

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', 'gå', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', 'gä', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)

local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>gD', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>f', '<Cmd>lua vim.lsp.buf.format()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>ac', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>dj', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>dk', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>gr', '<Cmd>Telescope lsp_references<CR>', opts)

  local augroup_id = vim.api.nvim_create_augroup('LSPAttach', { clear = false })
  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup_id })
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    group = augroup_id,
    callback = function()
      if client.server_capabilities.documentHighlightProvider then
        vim.lsp.buf.document_highlight()
      end
      vim.diagnostic.open_float({ bufnr = bufnr }, { focus = false })
    end,
  })
  vim.api.nvim_create_autocmd('CursorHoldI', {
    buffer = bufnr,
    group = augroup_id,
    callback = function()
      if client.server_capabilities.signatureHelpProvider then
        vim.lsp.buf.signature_help()
      end
    end
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    buffer = bufnr,
    group = augroup_id,
    callback = vim.lsp.buf.clear_references,
  })
  vim.api.nvim_create_autocmd('CompleteDone', {
    buffer = bufnr,
    group = augroup_id,
    callback = function()
      local completed_item = vim.v.completed_item
      if not (completed_item
          and completed_item.user_data
          and completed_item.user_data.nvim
          and completed_item.user_data.nvim.lsp
          and completed_item.user_data.nvim.lsp.completion_item) then
        return
      end

      local item = completed_item.user_data.nvim.lsp.completion_item
      vim.lsp.buf_request(bufnr, 'completionItem/resolve', item, function(_, _, result)
        if (result
            and result.params
            and result.params.additionalTextEdits) then
          vim.lsp.util.apply_text_edits(result.params.additionalTextEdits, bufnr, 'utf-8')
        end
      end)
    end,
  })
end

-- Stop diagnostics from taking over focus.
vim.diagnostic.config({ float = { focusable = false } })

for server, server_params in pairs(servers) do
  local params = {
    on_attach = on_attach,
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
      ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false }),
    },
  }
  local effective_params = vim.tbl_deep_extend('force', params, server_params)
  lsp[server].setup(coq_wrap(effective_params))
end

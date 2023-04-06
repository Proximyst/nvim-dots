-- Little hack for vimls to shut up on most lines. vim is technically an undefined global...
vim = vim

local servers = {
  'lua_ls',
  'rust_analyzer',
  'jsonls',
  'bashls',
  'clangd',
  'dockerls',
  'pyright',
}
require('mason-lspconfig').setup { ensure_installed = servers }
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

  local augroup_id = vim.api.nvim_create_augroup("LSPAttach", { clear = false })
  vim.api.nvim_clear_autocmds({ buffer = bufnr, group = augroup_id })
  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = bufnr,
    group = augroup_id,
    callback = function()
      vim.lsp.buf.document_highlight()
      vim.diagnostic.open_float({ bufnr = bufnr }, { focus = false })
    end,
  })
  vim.api.nvim_create_autocmd('CursorHoldI', {
    buffer = bufnr,
    group = augroup_id,
    callback = vim.lsp.buf.signature_help,
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    buffer = bufnr,
    group = augroup_id,
    callback = vim.lsp.buf.clear_references,
  })
end

for _, server in ipairs(servers) do
  lsp[server].setup(coq_wrap({
    on_attach = on_attach,
  }))
end

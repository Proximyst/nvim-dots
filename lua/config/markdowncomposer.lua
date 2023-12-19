-- Little hack for vimls to shut up on most lines. vim is technically an undefined global...
vim = vim

-- Disable automatic folding in Markdown files.
vim.g.vim_markdown_folding_disabled = 1
-- Don't conceal things in Markdown files.
vim.g.vim_markdown_conceal = 0

return {
  {
    'dhruvasagar/vim-table-mode',
    ft = 'markdown',
  },
  {
    'euclio/vim-markdown-composer',
    ft = 'markdown',
    build = '$HOME/.cargo/bin/cargo build --release',
    config = function()
      -- Disable automatic folding in Markdown files.
      vim.g.vim_markdown_folding_disabled = 1
      -- Don't conceal things in Markdown files.
      vim.g.vim_markdown_conceal = 0
    end,
  },
}

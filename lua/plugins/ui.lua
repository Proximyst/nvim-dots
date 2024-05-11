return {
--  {
--    'sainnhe/gruvbox-material',
--    lazy = false,
--    priority = 5000,
--    config = function()
--      vim.opt.termguicolors = true
--      vim.opt.background = 'dark'
--      vim.g.gruvbox_material_background = 'soft'
--      vim.g.gruvbox_material_foreground = 'material' -- material, mix, or original; i wanna try the new stuff.
--      vim.g.gruvbox_material_better_performance = true
--      vim.cmd [[colorscheme gruvbox-material]]
--    end,
--  },
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 5000,
    config = function()
      vim.opt.termguicolors = true
      vim.opt.background = 'dark'
      vim.cmd [[colorscheme catppuccin-macchiato]]
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'VeryLazy',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      enable = true,
      max_lines = 5,
      min_window_height = 10,
      line_numbers = true,
      trim_scope = 'outer',
    },
  },
  'machakann/vim-highlightedyank',
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
    opts = {
      options = {
        -- theme = 'gruvbox-material',
        theme = 'catppuccin-macchiato',
        component_separators = { left = '|', right = '|' },
      },
    },
  },
  {
    'folke/trouble.nvim',
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
}

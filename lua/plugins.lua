-- vim: set ff=unix autoindent ts=2 sw=2 tw=0 et :

-- Little hack for vimls to shut up on most lines. vim is technically an undefined global...
vim = vim

local function install_lazy_nvim()
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local plugins = {
  { 'sainnhe/gruvbox-material',
    lazy = false,
    priority = 5000,
    config = function()
      vim.opt.termguicolors = true
      vim.opt.background = 'dark'
      vim.g.gruvbox_material_background = 'soft'
      vim.g.gruvbox_material_foreground = 'material' -- material, mix, or original; i wanna try the new stuff.
      vim.g.gruvbox_material_better_performance = true
      vim.cmd [[colorscheme gruvbox-material]]
    end,
  },

  'tpope/vim-endwise',
  'tpope/vim-sleuth',
  { 'ms-jpq/coq_nvim',
    dependencies = { { 'ms-jpq/coq.artifacts' } },
    config = function()
      vim.g['coq_settings'] = { auto_start = 'shut-up' }
    end,
  },
  { 'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim',
        dependencies = { 'mason.nvim' },
      },
      { 'simrat39/inlay-hints.nvim' },
      'coq_nvim',
    },
    config = function() require('config.lspconfig') end,
  },
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  { 'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true,
      max_lines = 5,
      min_window_height = 10,
      line_numbers = true,
      trim_scope = 'outer',
    },
  },

  'machakann/vim-highlightedyank',
  { 'notjedi/nvim-rooter.lua',
    config = true,
  },
  { 'nvim-lualine/lualine.nvim',
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
    config = function()
      require('lualine').setup {
        options = {
          theme = 'gruvbox-material',
          component_separators = { left = '|', right = '|' },
        },
      }
    end,
  },
  { 'f-person/git-blame.nvim',
    config = function()
      require('gitblame').setup {
        highlight_group = 'NonText',
      }
    end,
  },
  { 'lewis6991/gitsigns.nvim',
    config = true,
  },
  { 'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function() require('config.telescope') end,
  },
  { 'folke/trouble.nvim',
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },

  { 'euclio/vim-markdown-composer',
    ft = 'markdown',
    build = '$HOME/.cargo/bin/cargo build --release',
    config = function() require('config.markdowncomposer') end,
  },
}
local lazy_opts = {
  checker = {
    enabled = true,
    frequency = 3600, -- seconds; once an hour.
  },
}

install_lazy_nvim()
return require('lazy').setup(plugins, lazy_opts)

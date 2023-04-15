-- vim: set ff=unix autoindent ts=2 sw=2 tw=0 et :

-- Little hack for vimls to shut up on most lines. vim is technically an undefined global...
vim = vim

local function ensure_packer_exists()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  local ok = os.rename(install_path, install_path)
  if not ok then
    vim.fn.system({ 'git', 'clone', '--depth', '1', 'git@github.com:wbthomason/packer.nvim.git', install_path })
    vim.cmd('packadd packer.nvim')
    return true
  end
  return false
end

local packer_bootstrapped = ensure_packer_exists()
local packer = require('packer')

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'tpope/vim-endwise'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-surround'
  use { 'ms-jpq/coq_nvim',
    requires = { { 'ms-jpq/coq.artifacts' } },
    setup = function() vim.g['coq_settings'] = { auto_start = 'shut-up' } end,
  }
  use { 'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'simrat39/inlay-hints.nvim',
    },
    config = function() require('config.lspconfig') end,
    after = { 'coq_nvim', 'mason-lspconfig.nvim' },
  }

  use 'kien/rainbow_parentheses.vim'
  use { 'morhetz/gruvbox',
    config = function()
      vim.g.gruvbox_italic = true
      vim.o.background = 'dark'
      vim.cmd [[colorscheme gruvbox]]
    end,
  }
  use 'machakann/vim-highlightedyank'
  use { 'dylanaraps/root.vim',
    config = function() require('config.rootvim') end,
  }
  use { 'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'gruvbox',
        },
      }
    end,
    requires = { { 'nvim-tree/nvim-web-devicons' } },
  }
  use { 'lewis6991/gitsigns.nvim',
    config = function() require('gitsigns').setup() end,
  }
  use { 'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    config = function() require('config.telescope') end,
  }

  use { 'tbastos/vim-lua', ft = 'lua' }
  use { 'cespare/vim-toml', ft = 'toml' }
  use { 'euclio/vim-markdown-composer',
    ft = 'markdown',
    run = '$HOME/.cargo/bin/cargo build --release',
    config = function() require('config.markdowncomposer') end,
  }
  use { 'elixir-editors/vim-elixir', ft = 'elixir' }

  if packer_bootstrapped then
    packer.sync()
  end
end)

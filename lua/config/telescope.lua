local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

telescope.setup {
  defaults = {
    sorting_strategy = 'ascending',
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-c>'] = actions.close,
      },
      n = {
        ['<C-c>'] = actions.close,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}
vim.api.nvim_set_keymap('n', '<Leader><Tab>', '',
  { noremap = true, silent = true, callback = builtin.find_files})
vim.api.nvim_set_keymap('n', '<Leader>gg', '',
  { noremap = true, silent = true, callback = builtin.live_grep})
vim.api.nvim_set_keymap('n', '<Leader>gb', '',
  { noremap = true, silent = true, callback = builtin.buffers})
vim.api.nvim_set_keymap('n', '<Leader>gh', '',
  { noremap = true, silent = true, callback = builtin.help_tags})

telescope.load_extension('fzf')

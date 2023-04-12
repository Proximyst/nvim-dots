-- vim: set ff=unix autoindent ts=2 sw=2 tw=0 et :

-- Little hack for vimls to shut up on most lines. vim is technically an undefined global...
vim = vim

-- All <Leader> mappings should start with a space.
vim.g.mapleader = ' '
vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>J', '<C-W>j', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>H', '<C-W>h', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>K', '<C-W>k', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>L', '<C-W>l', { silent = true })
vim.api.nvim_set_keymap('n', '<Leader>h', ':noh<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tl', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>th', ':tabprev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tt', ':tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>te', ':tabedit<Space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tj', ':tablast<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tk', ':tabfirst<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tq', ':tabclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tw', ':w<CR>:tabclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>s', '"+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>s', '"+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Esc>', '', {
  noremap = true,
  silent = true,
  callback = function()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).relative ~= '' then
        -- This is a floating window.
        vim.api.nvim_win_close(winid, true)
      end
    end
  end
})

-- Have coloured columns at col 80, 120, 140, and 240.
vim.wo.colorcolumn = '80,120,140,240'
-- ... and have it be lightgrey, cause bright red is ugly.
vim.cmd [[highlight ColorColumn ctermbg=0 guibg=lightgrey]]
-- Display relative numbers on the side.
vim.opt.number = true
vim.opt.relativenumber = true
-- When closing buffers with unsaved modifications, hide it instead of dropping.
vim.opt.hidden = true
-- When using commands, allow for completions.
vim.opt.wildmenu = true
-- Highlight the entire line the cursor is currently on.
vim.opt.cursorline = true
-- When typing searches, show the matches as they're being typed.
vim.opt.incsearch = true
-- Highlight all the previous search matches. Clear with :noh.
vim.opt.hlsearch = true
-- Override the ignorecase option if the search includes uppercase characters.
-- This means searching for "abc" will find both "abc" and "Abc", but searching
--   for "Abc" will not find "abc" or "ABC", but find "Abc".
vim.opt.smartcase = true
-- Allow to backspace anywhere in vim.
vim.opt.backspace = 'indent,eol,start'
-- Disable the vim-builtin info at the bottom of the screen; we use a status
--   line plugin.
vim.opt.ruler = false
vim.opt.showmode = false
-- Make commands not move to the start of line unless 0 is pressed.
vim.opt.startofline = false
-- Certain commands need confirmation; use a dialog for them.
vim.opt.confirm = true
-- Mouse support for normal, visual, insert, command-line, and help mode.
vim.opt.mouse = 'a'
-- Indent smartly when starting a new line.
vim.opt.smartindent = true
-- Disable the stupid beep. Use a visual bell instead.
vim.opt.visualbell = true
-- Make the command input only 1 line tall.
vim.opt.cmdheight = 1
-- Don't make backup files before overwriting files; this is why we have Git.
vim.opt.backup = false
vim.opt.writebackup = false
-- Timeout any unfinished keypresses after 500ms.
vim.opt.timeoutlen = 500
-- ... but don't have timeouts at all for keypresses.
vim.opt.ttimeoutlen = 0
-- Don't redraw the screen while executing macros.
vim.opt.lazyredraw = true
-- Always show the status line.
vim.opt.laststatus = 2
-- Don't show me ins-completion-menu messages.
vim.opt.shortmess:append('c')
-- Use 24-bit colours.
vim.opt.termguicolors = true
-- After 300 milliseconds of inactivity, update the swap file.
vim.opt.updatetime = 300
-- :split should go below, and :vsplit should go to the right of the current
--   buffer.
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Always show text normally.
vim.opt.conceallevel = 0
vim.opt.concealcursor = ''
-- When doing folds, prefer the {{{ }}} markers.
vim.opt.foldmethod = 'marker'
-- Don't expand TAB into spaces.
vim.opt.expandtab = false
-- Each TAB should be 4 spaces long.
vim.opt.tabstop = 4
-- ... and each soft tab should be 0 spaces long, to show something is broken.
vim.opt.softtabstop = 0
-- Shifting should be 4 spaces long.
vim.opt.shiftwidth = 4

-- For JSON, we want to match comments appropriately.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'json',
  callback = function(_args)
    vim.cmd [[syntax match Comment +\/\/.\+$+]]
  end
})

-- Add commands for :Spaces <n> and :Tabs <n> to set the vim mode for what the
--   file uses.
vim.api.nvim_create_user_command('Spaces', function(opts)
  local num = tonumber(opts.fargs[1])
  if num == nil then
    print('error: got a non-number: ' .. opts.fargs[1])
    return
  end
  vim.bo.tabstop = num
  vim.bo.shiftwidth = num
  vim.bo.softtabstop = num
  vim.bo.expandtab = true
end, { nargs = 1, desc = 'Sets the indent size of Spaces for the buffer.' })
vim.api.nvim_create_user_command('Tabs', function(opts)
  local num = tonumber(opts.fargs[1])
  if num == nil then
    print('error: got a non-number: ' .. opts.fargs[1])
    return
  end
  vim.bo.tabstop = num
  vim.bo.shiftwidth = num
  vim.bo.softtabstop = num
  vim.bo.expandtab = false
end, { nargs = 1, desc = 'Sets the indent size of Tabs for the buffer.' })

function Modeline()
  local et = vim.bo.expandtab and '' or 'no'
  local modeline = string.format('vim: set ff=unix autoindent ts=%d sw=%d tw=%d %set :'
  , vim.bo.tabstop
  , vim.bo.shiftwidth
  , vim.bo.textwidth
  , et)
  if not string.find(modeline, ' ') then
    modeline = ' ' .. modeline
  end
end

vim.api.nvim_set_keymap('n', '<Leader>ml', ''
, { noremap = true, silent = true, callback = Modeline })

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

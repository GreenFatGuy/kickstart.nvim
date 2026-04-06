-- Neovim config: core settings in lua/core/, plugins in lua/plugins/<plugin>/.

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require 'core.options'
require 'core.keymaps'
require 'core.autocmds'

require 'bootstrap.lazy'

require('lazy').setup(require 'plugins', {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

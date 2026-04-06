-- Plugin specs live under lua/plugins/<name>/init.lua (one folder per plugin).
-- Add optional specs from lua/custom/plugins/*.lua via lazy's import.
return {
  require 'plugins.vim-sleuth',
  require 'plugins.git-blame',
  require 'plugins.codecompanion',
  require 'plugins.gitsigns',
  require 'plugins.which-key',
  require 'plugins.nvim-tree',
  require 'plugins.telescope',
  require 'plugins.lazydev',
  require 'plugins.luvit-meta',
  require 'plugins.nvim-lspconfig',
  require 'plugins.conform',
  require 'plugins.nvim-cmp',
  require 'plugins.kanagawa',
  require 'plugins.todo-comments',
  require 'plugins.mini',
  require 'plugins.nvim-treesitter',
  { import = 'custom.plugins' },
}

return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      view = {
        width = 30,
        side = 'left',
      },
      renderer = {
        icons = {
          glyphs = {
            default = '📄',
            symlink = '🔗',
          },
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      diagnostics = {
        enable = true,
      },
      git = {
        enable = true,
      },
    }
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
  end,
}

return {
  'rebelot/kanagawa.nvim',
  priority = 1000,
  lazy = false,
  init = function()
    require('kanagawa').setup {
      theme = 'dragon',
      background = {
        dark = 'wave',
        light = 'lotus',
      },
      transparent = false,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
    }
    vim.cmd 'colorscheme kanagawa'
  end,
}

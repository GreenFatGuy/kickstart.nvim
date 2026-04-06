return {
  'olimorris/codecompanion.nvim',
  cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
  keys = {
    { '<leader>aa', '<cmd>CodeCompanionChat<cr>', desc = '[A]I Chat' },
    { '<leader>ap', '<cmd>CodeCompanionActions<cr>', desc = '[A]I Prompt/Actions' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    opts = {
      log_level = 'ERROR',
    },
    strategies = {
      chat = {
        adapter = 'cursor_cli',
      },
      inline = {
        adapter = 'cursor_cli',
      },
      cmd = {
        adapter = 'cursor_cli',
      },
    },
  },
  init = function()
    if vim.fn.executable 'agent' ~= 1 then
      vim.api.nvim_create_user_command('CodeCompanion', function()
        vim.notify('Cursor CLI is not installed (`agent` not found in PATH)', vim.log.levels.WARN)
      end, {})
      vim.api.nvim_create_user_command('CodeCompanionChat', function()
        vim.notify('Cursor CLI is not installed (`agent` not found in PATH)', vim.log.levels.WARN)
      end, {})
      vim.api.nvim_create_user_command('CodeCompanionActions', function()
        vim.notify('Cursor CLI is not installed (`agent` not found in PATH)', vim.log.levels.WARN)
      end, {})
    end
  end,
}

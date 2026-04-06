return {
  'olimorris/codecompanion.nvim',
  cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
  keys = {
    { '<leader>aa', '<cmd>CodeCompanionChat Toggle<cr>', desc = '[A]I Chat Toggle' },
    { '<leader>ac', '<cmd>CodeCompanionChat<cr>', desc = '[A]I Chat' },
    { '<leader>ap', '<cmd>CodeCompanionActions<cr>', desc = '[A]I Prompt/Actions' },
    { '<leader>ah', '<cmd>CodeCompanionHistory<cr>', desc = '[A]I [H]istory' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/codecompanion-history.nvim',
  },
  opts = {
    opts = {
      log_level = 'ERROR',
    },
    extensions = {
      history = {
        enabled = true,
        opts = {
          auto_save = true,
        },
      },
    },
    strategies = {
      chat = {
        adapter = 'cursor_cli',
        window = {
          width = 0.25,
        },
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

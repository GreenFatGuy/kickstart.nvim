return {
  'olimorris/codecompanion.nvim',
  cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions', 'CodeCompanionHistory', 'CodeCompanionSummaries' },
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
          auto_generate_title = false,
        },
      },
    },
    interactions = {
      chat = {
        adapter = 'cursor_cli',
        window = {
          width = 0.25,
        },
        tools = {
          insert_edit_into_file = {
            opts = {
              require_confirmation_after = false,
            },
          },
        },
      },
      shared = {
        keymaps = {
          always_accept = {
            modes = { n = 'Y' },
          },
          accept_change = {
            modes = { n = 'y' },
          },
          reject_change = {
            modes = { n = 'n' },
          },
          cancel = {
            modes = { n = 'x' },
          },
        },
      },
    },
  },
  config = function(_, opts)
    require('codecompanion').setup(opts)
    local approval_prompt = require 'codecompanion.interactions.chat.helpers.approval_prompt'

    -- Serialize approval prompts per chat buffer to avoid keymap collisions
    -- when multiple tool approvals are requested concurrently.
    if not approval_prompt._approval_queue_patch then
      local original_request = approval_prompt.request
      local queue_by_buf = {}
      local active_by_buf = {}
      approval_prompt._approval_queue_state = {
        queue_by_buf = queue_by_buf,
        active_by_buf = active_by_buf,
      }

      local function start_next(bufnr)
        if active_by_buf[bufnr] then
          return
        end

        local queue = queue_by_buf[bufnr]
        if not queue or #queue == 0 then
          return
        end

        local item = table.remove(queue, 1)
        active_by_buf[bufnr] = true

        local wrapped_opts = vim.deepcopy(item.opts)
        wrapped_opts.choices = wrapped_opts.choices or {}
        for _, choice in ipairs(wrapped_opts.choices) do
          local original_cb = choice.callback
          choice.callback = function(...)
            if type(original_cb) == 'function' then
              pcall(original_cb, ...)
            end
            active_by_buf[bufnr] = false
            vim.schedule(function()
              start_next(bufnr)
            end)
          end
        end

        local ok, base_on_done = pcall(original_request, item.chat, wrapped_opts)
        if not ok or type(base_on_done) ~= 'function' then
          active_by_buf[bufnr] = false
          vim.schedule(function()
            start_next(bufnr)
          end)
          return
        end
        item.on_done = function(choice_label)
          pcall(base_on_done, choice_label)
          active_by_buf[bufnr] = false
          vim.schedule(function()
            start_next(bufnr)
          end)
        end

        if item.pending_choice_label then
          item.on_done(item.pending_choice_label)
        end
      end

      approval_prompt.request = function(chat, req_opts)
        local bufnr = chat.bufnr
        queue_by_buf[bufnr] = queue_by_buf[bufnr] or {}

        local item = {
          chat = chat,
          opts = req_opts,
          on_done = nil,
          pending_choice_label = nil,
        }
        table.insert(queue_by_buf[bufnr], item)
        vim.schedule(function()
          start_next(bufnr)
        end)

        return function(choice_label)
          if item.on_done then
            item.on_done(choice_label)
          else
            item.pending_choice_label = choice_label
          end
        end
      end
      approval_prompt._approval_queue_patch = true
    end

    -- Work around ACP mode event recursion with Cursor adapter in current plugin version.
    vim.api.nvim_create_autocmd('User', {
      pattern = 'CodeCompanionChatCreated',
      callback = function(args)
        local bufnr = args.data and args.data.bufnr
        if not bufnr then
          return
        end
        -- Tree-sitter can crash on dynamic chat content in some setups.
        pcall(vim.treesitter.stop, bufnr)
        pcall(vim.api.nvim_clear_autocmds, {
          group = 'codecompanion.chat:' .. bufnr,
          event = 'User',
          pattern = 'CodeCompanionChatACPModeChanged',
        })
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'CodeCompanionChatClosed',
      callback = function(args)
        local bufnr = args.data and args.data.bufnr
        if bufnr then
          local qstate = approval_prompt._approval_queue_state
          if qstate then
            qstate.queue_by_buf[bufnr] = nil
            qstate.active_by_buf[bufnr] = nil
          end
          pcall(require('codecompanion.interactions.chat.tools.approvals').reset, require('codecompanion.interactions.chat.tools.approvals'), bufnr)
        end
      end,
    })
  end,
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

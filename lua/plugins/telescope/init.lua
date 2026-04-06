return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
      config = function()
        require('nvim-web-devicons').setup {
          default = true,
          override = {
            default_icon = {
              icon = '',
              color = '#428850',
              name = 'Default',
            },
            dockerfile = {
              icon = '🐳',
              color = '#458ee6',
              cterm_color = '68',
              name = 'Dockerfile',
            },
          },
          override_by_extension = {
            ['txt'] = {
              icon = '📄',
              color = '#6d8086',
              cterm_color = '66',
              name = 'Text',
            },
            ['log'] = {
              icon = '📜',
              color = '#6d8086',
              cterm_color = '66',
              name = 'Log',
            },
            ['docker'] = {
              icon = '🐳',
              color = '#458ee6',
              cterm_color = '68',
              name = 'Dockerfile',
            },
            ['rs'] = {
              icon = '🦀',
              color = '#dea584',
              cterm_color = '180',
              name = 'Rust',
            },
            ['toml'] = {
              icon = '⚓',
              color = '#dea584',
              cterm_color = '180',
              name = 'Toml',
            },
          },
          override_by_filename = {
            ['Dockerfile'] = {
              icon = '🐳',
              color = '#458ee6',
              cterm_color = '68',
              name = 'Dockerfile',
            },
            ['docker-compose.yaml'] = {
              icon = '🐳',
              color = '#458ee6',
              cterm_color = '68',
              name = 'DockerCompose',
            },
            ['docker-compose.yml'] = {
              icon = '🐳',
              color = '#458ee6',
              cterm_color = '68',
              name = 'DockerCompose',
            },
            ['Cargo.lock'] = {
              icon = '⚓',
              color = '#dea584',
              cterm_color = '180',
              name = 'CargoLock',
            },
            ['Makefile'] = {
              icon = '🛠',
              color = '#6d8086',
              cterm_color = '66',
              name = 'Makefile',
            },
            ['Makefile.in'] = {
              icon = '🛠',
              color = '#6d8086',
              cterm_color = '66',
              name = 'MakefileIn',
            },
            ['Makefile.am'] = {
              icon = '🛠',
              color = '#6d8086',
              cterm_color = '66',
              name = 'MakefileAm',
            },
            ['GNUmakefile'] = {
              icon = '🛠',
              color = '#6d8086',
              cterm_color = '66',
              name = 'GNUMakefile',
            },
            ['CMakeLists.txt'] = {
              icon = '🛠',
              color = '#6d8086',
              cterm_color = '66',
              name = 'CMakeLists',
            },
            ['CMakeCache.txt'] = {
              icon = '🛠',
              color = '#6d8086',
              cterm_color = '66',
              name = 'CMakeCache',
            },
          },
        }
      end,
    },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}

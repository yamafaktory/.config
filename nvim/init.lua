--[[
-- General options.
--]]

vim.g.markdown_fenced_languages = {
  'bash',
  'html',
  'java',
  'javascript',
  'javascriptreact',
  'json',
  'rust',
  'sh=bash',
  'tsx=typescriptreact',
  'typescript',
  'typescriptreact',
  'zig',
}
vim.o.breakindent = true
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.ignorecase = true
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.updatetime = 50
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.undofile = true
vim.wo.number = true
vim.wo.signcolumn = 'yes'

--[[
-- Bootstrap lazy.  
--]]

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--[[
-- Autocommands.
--]]

-- Start default terminal in insert mode.
vim.api.nvim_exec2(
  [[
    augroup TermEvents
      autocmd TermOpen term://* startinsert
    augroup end
  ]],
  {}
)

--[[
-- Lazy plugins.
--]]

local packages = {
  -- Proper lua development.
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- Plenary lua functions.
  {
    'nvim-lua/plenary.nvim',
    dependencies = {
      'Saecki/crates.nvim',
      'lewis6991/gitsigns.nvim',
    },
  },

  -- Icons.
  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },

  -- Status line.
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        component_separators = '',
        globalstatus = true,
        section_separators = '',
        theme = 'rose-pine-alt',
      },
    },
  },

  -- Filesystem explorer.
  {
    'echasnovski/mini.files',
    version = false,
    config = function()
      require('mini.files').setup({})
    end,
    keys = {
      {
        '<leader>t',
        function()
          -- Open mini.files at current buffer position.
          local mini_files = require('mini.files')
          local buf_name = vim.api.nvim_buf_get_name(0)
          local path = vim.fn.filereadable(buf_name) == 1 and buf_name
            or vim.fn.getcwd()
          mini_files.open(path)
          mini_files.reveal_cwd()
        end,
        desc = 'Mini files',
      },
    },
  },

  -- Fuzzy finder.
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('fzf-lua').setup({
        winopts = {
          border = 'single',
          preview = { border = 'single' },
        },
      })
    end,
    keys = {
      { '<leader>b', '<cmd>FzfLua buffers<cr>', desc = 'Fzf buffers' },
      {
        '<leader>d',
        function()
          require('fzf-lua').lsp_definitions({ jump1 = true })
        end,
        desc = 'Fzf lsp definitions',
      },
      { '<leader>f', '<cmd>FzfLua files<cr>', desc = 'Fzf files' },
      {
        '<leader>g',
        function()
          require('fzf-lua').live_grep({ exec_empty_query = true })
        end,

        desc = 'Fzf live grep',
      },
      {
        '<leader>r',
        '<cmd>FzfLua live_grep_resume<cr>',
        desc = 'Fzf live grep resume',
      },
    },
  },

  -- Git related info in the signs columns and popups.
  {
    'lewis6991/gitsigns.nvim',
    config = true,
    lazy = true,
    keys = {
      {
        '<leader>l',
        '<cmd>lua require("gitsigns").blame_line()<cr>',
        desc = 'Gitsigns blame',
      },
    },
  },

  -- Highlight, edit, and navigate code using a fast incremental parsing library.
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    dependencies = {
      'windwp/nvim-ts-autotag',
    },
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = {
      'TSUpdateSync',
    },
    config = function()
      local configs = require('nvim-treesitter.configs')

      ---@diagnostic disable-next-line: missing-fields
      configs.setup({
        ensure_installed = {
          'bash',
          'css',
          'dockerfile',
          'fish',
          'html',
          'javascript',
          'java',
          'json',
          'just',
          'kdl',
          'lua',
          'markdown',
          'rust',
          'scss',
          'sql',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'yaml',
          'vue',
          'zig',
        },
        highlight = {
          additional_vim_regex_highlighting = false,
          autotag = { enable = true },
          enable = true,
          indent = { enable = true },
          keymaps = {
            init_selection = 'gnn',
            node_decremental = 'grm',
            node_incremental = 'grn',
            scope_incremental = 'grc',
          },
          matchup = { enable = true },
        },
      })
    end,
  },

  -- LSP, LSP installer and tab completion.
  'williamboman/mason.nvim', -- Mason.
  'williamboman/mason-lspconfig.nvim', -- Mason LSP bridge.
  {
    -- Collection of configurations for built-in LSP client.
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets', -- Useful snippets to use.
      'moyiz/blink-emoji.nvim', -- Emojis completion.
    },
    version = '*',
    opts = {
      completion = {
        documentation = {
          auto_show = true,
        },
        list = {
          selection = { preselect = false },
        },
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= 'default'
          end,
          draw = {
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 },
              { 'kind' },
              { 'source_name' },
            },
            treesitter = { 'lsp' },
          },
        },
        ghost_text = {
          enabled = true,
        },
      },
      keymap = {
        preset = 'enter',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      signature = {
        enabled = true,
      },
      sources = {
        default = {
          'lazydev',
          'lsp',
          'path',
          'snippets',
          'buffer',
          'emoji',
        },
        providers = {
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = 15,
            opts = { insert = true },
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
  -- Mason tool installer.
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
  },

  {
    'folke/trouble.nvim',
    opts = {
      modes = {
        diagnostics = {
          auto_close = true,
        },
      },
    },
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Trouble Diagnostics',
      },
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Trouble Buffer Diagnostics',
      },
    },
  },

  -- Current theme.
  {
    'rose-pine/neovim',
    lazy = false,
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('rose-pine').setup({
        variant = 'moon',
      })
      vim.cmd('colorscheme rose-pine')
    end,
  },

  -- Rust niceties.
  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = true,
    lazy = true,
  },

  -- Auto-close pairs.
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    lazy = true,
  },

  -- Auto-close tags.
  'windwp/nvim-ts-autotag',

  -- Indentation guides.
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- Formatting.
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader><space>',
        function()
          require('conform').format({ async = true })
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = (function()
        local prettierFormatter =
          { 'prettierd', 'prettier', stop_after_first = true }

        return {
          css = prettierFormatter,
          html = prettierFormatter,
          javascript = prettierFormatter,
          json = prettierFormatter,
          jsonc = prettierFormatter,
          lua = { 'stylua' },
          markdown = prettierFormatter,
          rust = { 'rustfmt', lsp_format = 'fallback' },
          scss = prettierFormatter,
          typescript = prettierFormatter,
          typescriptreact = prettierFormatter,
          vue = prettierFormatter,
          yaml = prettierFormatter,
          zig = { 'zigfmt' },
        }
      end)(),
      default_format_opts = {
        lsp_format = 'fallback',
      },
      formatters = {
        stylua = {
          prepend_args = {
            '--no-editorconfig',
            '--column-width',
            '80',
            '--indent-type',
            'Spaces',
            '--indent-width',
            '2',
            '--line-endings',
            'Unix',
            '--quote-style',
            'AutoPreferSingle',
          },
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Codeium.
  {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    config = true,
    keys = {
      {
        '<A-f>',
        '<cmd>lua require("neocodeium").accept()<cr>',
        desc = 'Neocodeium accept',
        mode = 'i',
      },
      {
        '<A-e>',
        '<cmd>lua require("neocodeium").cycle_or_complete()<cr>',
        desc = 'Neocodeium cycle',
        mode = 'i',
      },
    },
  },

  -- Java.
  -- https://github.com/nvim-java/nvim-java/wiki/Lazyvim
  'nvim-java/nvim-java',
}

require('lazy').setup({
  spec = packages,
  install = { colorscheme = { 'rose-pine' } },
  checker = { enabled = true },
  rocks = {
    enabled = false,
  },
})

--[[
-- LSP Setup.
--]]

-- Diagnostics configuration.
vim.diagnostic.config({
  update_in_insert = true,
})

-- Neocodeium auto-completion settings.
local neocodeium = require('neocodeium')
local blink = require('blink.cmp')

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuOpen',
  callback = function()
    neocodeium.clear()
  end,
})

neocodeium.setup({
  filter = function()
    return not blink.is_visible()
  end,
})

-- Use nice icons for diagnostics.
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
})

-- Use Mason to manage the servers' setup.
-- Each setup must stay in this specific order!
-- See https://github.com/williamboman/mason-lspconfig.nvim#setup
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
require('java').setup({})

-- Prepare on_attach.
-- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ...)
  end
  local lsp_buf = '<cmd>lua vim.lsp.buf.'
  local options = { noremap = true, silent = true }

  -- Add some keymapping.
  buf_set_keymap('gr', lsp_buf .. 'rename()<cr>', options)
  buf_set_keymap('K', lsp_buf .. 'hover()<cr>', options)
  buf_set_keymap('<leader>a', lsp_buf .. 'code_action()<cr>', options)

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)
  end
end

-- Prepare capabilities.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Provide a generic function to configure and enable a server.
local config_and_enable = function(server, more_settings)
  local config = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  if more_settings then
    for k, v in pairs(more_settings) do
      config[k] = v
    end
  end

  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-- List of LSP servers and formatters automatically installed.
local ensure_installed = {
  -- Servers.
  -- See this mapping:
  -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
  'bash-language-server',
  'css-lsp',
  'dockerfile-language-server',
  'eslint-lsp',
  'gradle-language-server',
  'html-lsp',
  'jdtls',
  'json-lsp',
  'just-lsp',
  'lua-language-server',
  'postgrestools',
  'prettier',
  'rust-analyzer',
  'shellcheck',
  'stylua',
  'tailwindcss-language-server',
  'taplo',
  'typescript-language-server',
  'vue-language-server',
  'yaml-language-server',
  'yamllint',
}

mason.setup()

---@diagnostic disable-next-line: missing-fields
mason_lspconfig.setup({
  automatic_installation = true,
  ui = {
    icons = {
      server_installed = '',
      server_pending = '',
      server_uninstalled = '',
    },
  },
})

require('mason-tool-installer').setup({
  auto_update = true,
  ensure_installed = ensure_installed,
  run_on_start = true,
})

-- Setup all the servers.
mason_lspconfig.setup_handlers({
  function(server)
    -- Fix for https://github.com/neovim/nvim-lspconfig/pull/3232.
    if server == 'tsserver' then
      server = 'ts_ls'
    end
    -- Specific rust-analyzer setup.
    if server == 'rust_analyzer' then
      config_and_enable(server, {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            cargo = {
              features = 'all',
            },
            check = {
              command = 'clippy',
            },
            interpret = {
              tests = true,
            },
          },
        },
      })
    elseif server == 'ts_ls' then
      -- Specific tsserver setup.
      local inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }

      config_and_enable(server, {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
          'vue',
        },
        init_options = {
          plugins = {
            {
              name = '@vue/typescript-plugin',
              location = '/usr/lib/node_modules/@vue/typescript-plugin',
              languages = { 'javascript', 'typescript', 'vue' },
            },
          },
        },
        settings = {
          importModuleSpecifierPreference = 'non-relative',
          typescript = {
            inlayHints = inlayHints,
          },
          javascript = {
            inlayHints = inlayHints,
          },
        },
      })
    else
      config_and_enable(server, {
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end
  end,
})

-- Specific zls setup.
-- This LSP is not managed by Mason but by zmv.
config_and_enable('zls', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    warn_style = true,
  },
})

-- Enable some other language servers.
config_and_enable('just')
config_and_enable('postgres_lsp')

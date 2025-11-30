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
vim.opt.endofline = false
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
        'hide',
        winopts = {
          border = 'single',
          fullscreen = true,
          preview = {
            border = 'single',
            -- Using default settings.
            winopts = {
              cursorcolumn = false,
              cursorline = true,
              cursorlineopt = 'both',
              foldenable = false,
              foldmethod = 'manual',
              list = false,
              number = true,
              relativenumber = false,
              scrolloff = 0,
              signcolumn = 'no',
              winblend = 1,
            },
          },
        },
      })
      require('fzf-lua').register_ui_select()
    end,
    keys = {
      { '<leader>z', '<cmd>FzfLua<cr>', desc = 'Fzf' },
      {
        '<leader>b',
        '<cmd>FzfLua buffers resume=true<cr>',
        desc = 'Fzf buffers',
      },
      {
        '<leader>d',
        function()
          require('fzf-lua').lsp_definitions({ jump1 = true })
        end,
        desc = 'Fzf lsp definitions',
      },
      { '<leader>f', '<cmd>FzfLua files resume=true<cr>', desc = 'Fzf files' },
      {
        '<leader>g',
        function()
          require('fzf-lua').live_grep({
            exec_empty_query = true,
            resume = true,
          })
        end,
        desc = 'Fzf live grep',
      },
      {
        '<leader>r',
        function()
          require('fzf-lua').lsp_references({ jump1 = true })
        end,
        desc = 'Fzf lsp references',
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
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = (function()
        local formatter =
          { 'dprint', 'prettier', 'prettierd', stop_after_first = true }

        return {
          css = formatter,
          html = formatter,
          javascript = formatter,
          json = formatter,
          jsonc = formatter,
          lua = { 'stylua' },
          markdown = formatter,
          rust = { 'rustfmt', lsp_format = 'fallback' },
          scss = formatter,
          sh = { 'shfmt' },
          sql = { 'pg_format' },
          typescript = formatter,
          typescriptreact = formatter,
          vue = formatter,
          yaml = formatter,
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

      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*',
        callback = function(args)
          require('conform').format({ bufnr = args.buf })
        end,
      })
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
local mason_tool_installer = require('mason-tool-installer')

-- Use LspAttach autocommand after the language server attaches to the current buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf
    local filetype = vim.bo[bufnr].filetype

    vim.keymap.set('n', 'gr', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover({ border = 'single' })
    end, opts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)

    -- Enable inlay hints if supported.
    if client and client.server_capabilities.inlayHintProvider then
      -- Currently inlay hints with vue are broken.
      if filetype == 'vue' then
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
      else
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end
  end,
})

-- Prepare capabilities.
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- List of LSP servers and formatters automatically installed.
local ensure_installed = {
  -- Servers.
  -- https://mason-registry.dev/registry/list
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
  'pgformatter',
  'postgres-language-server',
  'prettier',
  'rust-analyzer',
  'shellcheck',
  'shfmt',
  'stylua',
  'tailwindcss-language-server',
  'taplo',
  'vtsls',
  'vue-language-server',
  'yaml-language-server',
  'yamllint',
}

mason.setup()

---@diagnostic disable-next-line: missing-fields
mason_lspconfig.setup({
  automatic_enable = { exclude = { 'vue_ls' } },
  auto_update = true,
  ui = {
    check_outdated_packages_on_open = true,
    icons = {
      server_installed = '',
      server_pending = '',
      server_uninstalled = '',
    },
  },
})

mason_tool_installer.setup({
  auto_update = true,
  ensure_installed = ensure_installed,
})

-- Specific rust-analyzer setup.
vim.lsp.config('rust_analyzer', {
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

-- Setup all installed servers.
vim.lsp.config('*', {
  capabilities = capabilities,
})

-- Provide a generic function to configure and enable servers not managed by Mason.
local config_and_enable = function(server, more_settings)
  local config = {
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

-- Specific zls setup.
-- This LSP is not managed by Mason but by zvm.
config_and_enable('zls', {
  capabilities = capabilities,
  settings = {
    warn_style = true,
  },
})

-- Enable some other language servers.
config_and_enable('just')
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#postgres_lsp
config_and_enable('postgres_lsp')

-- Vue setup.
-- https://github.com/vuejs/language-tools/wiki/Neovim
-- sudo npm install -g @vue/typescript-plugin
local vue_language_server_path = vim.fn.expand('$MASON/packages')
  .. '/vue-language-server'
  .. '/node_modules/@vue/language-server'
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}
local shared_settings = {
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = 'all' },
    parameterTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
    variableTypes = { enabled = true },
  },
}
local vtsls_config = {
  settings = {
    typescript = shared_settings,
    javascript = shared_settings,
    vtsls = {
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = {
    'typescript',
    'javascript',
    'javascriptreact',
    'typescriptreact',
    'vue',
  },
}
local vue_ls_config = {
  capabilities = capabilities,
  on_init = function(client)
    client.handlers['tsserver/request'] = function(_, result, context)
      local clients =
        vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
      if #clients == 0 then
        vim.notify(
          'Could not found `vtsls` lsp client, vue_lsp would not work without it.',
          vim.log.levels.ERROR
        )
        return
      end
      local ts_client = clients[1]

      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = 'tsserver/request',
        command = 'typescript.tsserverRequest',
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
        local response_data = { { id, r.body } }
        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify('tsserver/response', response_data)
      end)
    end
  end,
}
vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('vue_ls', vue_ls_config)
vim.lsp.enable({ 'vtsls', 'vue_ls' })

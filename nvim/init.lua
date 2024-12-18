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
-- Helpers.
--]]

local options = { noremap = true, silent = true }
local set_keymap = vim.api.nvim_set_keymap

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
  -- Plenary lua functions.
  {
    'nvim-lua/plenary.nvim',
    dependencies = {
      'Saecki/crates.nvim',
      'lewis6991/gitsigns.nvim',
      'nvim-telescope/telescope.nvim',
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

  -- Telescope.
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    opts = {
      defaults = {
        borderchars = {
          '─',
          '│',
          '─',
          '│',
          '┌',
          '┐',
          '┘',
          '└',
        },
        dynamic_preview_title = true,
        layout_config = {
          horizontal = { width = 0.9 },
        },
        path_display = { 'truncate' },
        -- Keep the same prompt as starship.
        prompt_prefix = '❯ ',
        scroll_strategy = 'limit',
      },
    },
  },

  {
    'nvim-telescope/telescope-file-browser.nvim',
    config = function()
      require('telescope').load_extension('file_browser')
    end,
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    config = function()
      require('telescope').load_extension('fzf')
    end,
    build = 'make',
  },

  -- Git related info in the signs columns and popups.
  { 'lewis6991/gitsigns.nvim', config = true },

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

      configs.setup({
        ensure_installed = {
          'bash',
          'css',
          'dockerfile',
          'fish',
          'graphql',
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
          'toml',
          'tsx',
          'typescript',
          'vim',
          'yaml',
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
    'hrsh7th/nvim-cmp',
    version = false, -- Use latest version.
    dependencies = {
      -- Snippets plugin.
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        -- Install jsregexp.
        build = 'make install_jsregexp',
      },
      'hrsh7th/cmp-emoji', -- Emojis completion.
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp.
      'hrsh7th/cmp-path', -- Paths completion.
      'onsails/lspkind-nvim', -- Adds pictograms to neovim built-in LSP.
      'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp.
    },
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
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
    },
  },

  -- Current theme.
  {
    'rose-pine/neovim',
    lazy = false,
    priority = 1000,
    config = function()
      require('rose-pine').setup({
        highlight_groups = {
          TelescopeBorder = { fg = 'highlight_high', bg = 'none' },
          TelescopeNormal = { bg = 'none' },
          TelescopePromptNormal = { bg = 'base' },
          TelescopeResultsNormal = { fg = 'subtle', bg = 'none' },
          TelescopeSelection = { fg = 'text', bg = 'base' },
          TelescopeSelectionCaret = { fg = 'rose', bg = 'rose' },
        },
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
  },

  -- Auto-close pairs.
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
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
    'mhartington/formatter.nvim',
    config = function()
      -- Use Stylua with a custom configuration.
      -- https://github.com/johnnymorganz/stylua
      local luaFormatter = function()
        local args = table.concat({
          '--column-width 80',
          '--indent-type Spaces',
          '--indent-width 2',
          '--line-endings Unix',
          '--quote-style AutoPreferSingle',
        }, ' ')

        return {
          exe = 'stylua',
          args = {
            args,
            '-',
          },
          stdin = true,
        }
      end

      local prettierFormatter = function()
        return {
          exe = 'prettier',
          args = {
            '--stdin-filepath',
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
          },
          stdin = true,
        }
      end

      -- Apply formatters based on file type.
      require('formatter').setup({
        filetype = {
          css = { prettierFormatter },
          graphql = { prettierFormatter },
          html = { prettierFormatter },
          javascript = { prettierFormatter },
          json = { prettierFormatter },
          jsonc = { prettierFormatter },
          lua = { luaFormatter },
          markdown = { prettierFormatter },
          scss = { prettierFormatter },
          typescript = { prettierFormatter },
          typescriptreact = { prettierFormatter },
          yaml = { prettierFormatter },
        },
      })
    end,
  },

  -- Codeium.
  {
    'monkoose/neocodeium',
    event = 'VeryLazy',
    config = function()
      local neocodeium = require('neocodeium')

      neocodeium.setup()

      vim.keymap.set('i', '<A-f>', neocodeium.accept)
      vim.keymap.set('i', '<A-w>', neocodeium.accept_word)
      vim.keymap.set('i', '<A-a>', neocodeium.accept_line)
      vim.keymap.set('i', '<A-e>', neocodeium.cycle_or_complete)
      vim.keymap.set('i', '<A-r>', function()
        require('neocodeium').cycle_or_complete(-1)
      end)
      vim.keymap.set('i', '<A-c>', neocodeium.clear)
    end,
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
-- Global leader keymapping.
--]]

-- Telescope.
local telescope_builtin = "<Cmd>lua require('telescope.builtin')."
local telescope_builtin_extensions = "<Cmd>lua require('telescope').extensions."
local set_telescope_keymap = function(builtin, method, leader_key)
  set_keymap(
    'n',
    '<Leader>t' .. leader_key,
    builtin .. method .. '<CR>',
    options
  )
end

local telescope_mapping = {
  b = 'buffers()',
  -- Use https://github.com/sharkdp/fd.
  ff = 'find_files({ find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix", "--exclude", ".git" }})',
  gb = 'git_branches()',
  gc = 'git_commits()',
  gs = 'git_status()',
  lg = 'live_grep()',
  lr = 'lsp_references()',
  s = 'spell_suggest()',
}

local telescope_mapping_extensions = {
  -- Default to current buffer location.
  fb = 'file_browser.file_browser({ grouped = true, hidden = true, path = "%:p:h", respect_gitignore = false, sorting_strategy = "ascending" })',
}

for leader_key, method in pairs(telescope_mapping) do
  set_telescope_keymap(telescope_builtin, method, leader_key)
end

for leader_key, method in pairs(telescope_mapping_extensions) do
  set_telescope_keymap(telescope_builtin_extensions, method, leader_key)
end

-- Open default terminal.
set_keymap('n', '<A-t>', '<Cmd>:terminal<CR>', options)

--[[
-- LSP Setup.
--]]

-- Diagnostics configuration.
vim.diagnostic.config({
  update_in_insert = true,
})

-- Start with auto-completion settings.
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
local neocodeium = require('neocodeium')

cmp.event:on('menu_opened', function()
  neocodeium.clear()
end)

neocodeium.setup({
  filter = function()
    return not cmp.visible()
  end,
})

-- See: https://github.com/hrsh7th/nvim-cmp
cmp.setup({
  completion = {
    autocomplete = false,
  },
  experimental = {
    ghost_text = true,
  },
  formatting = {
    format = lspkind.cmp_format({
      ellipsis_char = '...',
      maxwidth = 50,
      mode = 'symbol',
    }),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete({}),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(
          vim.api.nvim_replace_termcodes(
            '<Plug>luasnip-expand-or-jump',
            true,
            true,
            true
          ),
          ''
        )
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(
          vim.api.nvim_replace_termcodes(
            '<Plug>luasnip-jump-prev',
            true,
            true,
            true
          ),
          ''
        )
      else
        fallback()
      end
    end,
  }),
  -- The order is used to display the completion options.
  sources = cmp.config.sources({
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'emoji' },
    { name = 'crates' },
  }),
  view = {
    entries = 'custom',
  },
})

-- Use nice icons for diagnostics.
local function sign_define(name, icon, hl)
  vim.fn.sign_define(name, { text = icon, texthl = hl })
end

sign_define('DiagnosticSignError', '', 'DiagnosticSignError')
sign_define('DiagnosticSignWarn', '', 'DiagnosticSignWarn')
sign_define('DiagnosticSignInformation', '', 'DiagnosticSignInfo')
sign_define('DiagnosticSignHint', '', 'DiagnosticSignHint')

-- Change the border of the documentation hover window.
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'single',
})

-- Use Mason to manage the servers' setup.
-- Each setup must stay in this specific order!
-- See https://github.com/williamboman/mason-lspconfig.nvim#setup
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
require('java').setup({})
local lspconfig = require('lspconfig')

-- Prepare on_attach.
-- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ...)
  end
  local lsp_buf = '<Cmd>lua vim.lsp.buf.'
  local lsp_codelens = '<Cmd>lua vim.lsp.codelens.'
  local gitSigns = '<Cmd>lua require("gitsigns").'

  -- Add some keymapping.
  buf_set_keymap('gd', '<Cmd>Telescope lsp_definitions<CR>', options)
  buf_set_keymap('gr', lsp_buf .. 'rename()<CR>', options)
  buf_set_keymap('K', lsp_buf .. 'hover()<CR>', options)
  buf_set_keymap('<Leader>a', lsp_buf .. 'code_action()<CR>', options)
  buf_set_keymap('<Leader>f', lsp_buf .. 'format{ async = true }<CR>', options)
  buf_set_keymap('<Leader>r', lsp_codelens .. 'run()<CR>', options)
  buf_set_keymap('<Leader>b', gitSigns .. 'blame_line()<CR>', options)

  -- Format on save for Rust files.
  vim.api.nvim_command('au BufWritePre *.rs lua vim.lsp.buf.format()')

  -- Refresh codelens when creating or reading a Rust file.
  vim.api.nvim_command(
    'au BufNewFile,BufRead *.rs lua vim.lsp.codelens.refresh()'
  )

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true)
  end
end

-- Prepare capabilities.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

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
  'graphql-language-service-cli',
  'html-lsp',
  'jdtls',
  'json-lsp',
  'lua-language-server',
  'rust-analyzer',
  'shellcheck',
  'tailwindcss-language-server',
  'taplo',
  'typescript-language-server',
  'yaml-language-server',
  'zls',
  -- Formatters.
  'prettier',
  'stylua',
  'yamllint',
}

mason.setup()

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
      lspconfig.rust_analyzer.setup({
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

      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
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
    elseif server == 'lua_ls' then
      -- Specific lua setup.
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            hint = {
              enable = true,
            },
            telemetry = { enable = false },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          },
        },
      })
    elseif server == 'jdtls' then
      -- Specific jdtls setup.
      lspconfig.jdtls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          -- java = {
          --   inlayHints = { parameterNames = { enabled = 'all' } },
          --   signatureHelp = { enabled = true },
          -- },
        },
      })
    elseif server == 'zls' then
      lspconfig.zls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          -- This won't be needed when https://github.com/zigtools/zls/pull/2009 will be versioned.
          enable_build_on_save = true,
          build_on_save_step = 'check',
        },
      })
    else
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end
  end,
})

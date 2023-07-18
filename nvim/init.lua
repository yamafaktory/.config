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
}
vim.o.breakindent = true
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.ignorecase = true
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.updatetime = 250
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

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

--[[
-- Autocommands.
--]]

-- Start default terminal in insert mode.
vim.api.nvim_exec(
  [[
    augroup TermEvents
      autocmd TermOpen term://* startinsert
    augroup end
  ]],
  false
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
    'kyazdani42/nvim-web-devicons',
    dependencies = {
      'folke/trouble.nvim',
      'nvim-lualine/lualine.nvim',
    },
    config = {
      default = true,
    },
  },

  -- Status line.
  {
    'nvim-lualine/lualine.nvim',
    config = {
      options = {
        component_separators = '',
        globalstatus = true,
        section_separators = '',
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
    config = {
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
    dependencies = {
      'windwp/nvim-ts-autotag',
    },
    build = ':TSUpdate',
    event = 'BufRead',
    cmd = {
      'TSInstall',
      'TSInstallSync',
      'TSBufEnable',
      'TSBufToggle',
      'TSEnableAll',
      'TSInstallFromGrammer',
      'TSToggleAll',
      'TSUpdate',
      'TSUpdateSync',
    },
    config = {
      ensure_installed = { 'all' },
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
    },
  },

  -- Enhance UI.
  { 'stevearc/dressing.nvim', event = 'VeryLazy' },

  -- LSP, LSP installer and tab completion.
  'williamboman/mason.nvim', -- Mason.
  'williamboman/mason-lspconfig.nvim', -- Mason LSP bridge.
  {
    -- Collection of configurations for built-in LSP client.
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'mfussenegger/nvim-jdtls',
      'ray-x/lsp_signature.nvim',
      'williamboman/mason-lspconfig.nvim',
      'williamboman/mason.nvim',
    },
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'L3MON4D3/LuaSnip', -- Snippets plugin.
      'hrsh7th/cmp-emoji', -- Emojis completion.
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp.
      'hrsh7th/cmp-path', -- Paths completion.
      'onsails/lspkind-nvim', -- Adds pictograms to neovim built-in LSP.
      'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp.
    },
  },
  'ray-x/lsp_signature.nvim', -- Live lsp signatures.

  -- Mason tool installer.
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
  },

  -- Get better LSP diagnostics.
  { 'folke/trouble.nvim', config = true },

  -- Current theme.
  {
    'rose-pine/neovim',
    lazy = false,
    priority = 1000,
    config = function()
      require('rose-pine').setup({
        variant = 'moon',
        disable_float_background = true,
      })
      vim.cmd('colorscheme rose-pine')
    end,
  },

  -- Rust niceties.
  'rust-lang/rust.vim',
  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    config = true,
  },

  -- Java extensions.
  'mfussenegger/nvim-jdtls',

  -- Auto-close pairs.
  {
    'windwp/nvim-autopairs',
    event = 'BufRead',
    config = true,
  },

  -- Auto-close tags.
  'windwp/nvim-ts-autotag',

  -- Comments.
  {
    'numToStr/Comment.nvim',
    config = true,
  },

  -- Indentation guides.
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('indent_blankline').setup({
        char_highlight_list = { 'IndentBlanklineIndent' },
        space_char_blankline = ' ',
      })
      -- Use a custom color for the guide.
      -- Take it from the theme directly.
      vim.cmd(
        string.format(
          [[highlight IndentBlanklineIndent guifg=%s gui=nocombine]],
          require('rose-pine.palette').highlight_low
        )
      )
    end,
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
          lua = { luaFormatter },
          markdown = { prettierFormatter },
          svelte = { prettierFormatter },
          typescript = { prettierFormatter },
          typescriptreact = { prettierFormatter },
          yaml = { prettierFormatter },
        },
      })
    end,
  },

  -- Open file in GitHub + GitLab.
  'almo7aya/openingh.nvim',
}

require('lazy').setup(packages)

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

-- Trouble.
set_keymap('n', '<Leader>tr', '<Cmd>Trouble<CR>', options)

--[[
-- LSP Setup.
--]]

-- Use no prefix for diagnostics and update diagnostics in insert mode.
vim.diagnostic.config({
  virtual_text = {
    prefix = '',
  },
  update_in_insert = true,
})

-- Start with auto-completion settings.
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

-- See: https://github.com/hrsh7th/nvim-cmp
cmp.setup({
  experimental = {
    ghost_text = true,
  },
  formatting = {
    format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
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

sign_define('DiagnosticSignError', '💣', 'DiagnosticSignError')
sign_define('DiagnosticSignWarn', '⚠️', 'DiagnosticSignWarn')
sign_define('DiagnosticSignInformation', ' ', 'DiagnosticSignInfo')
sign_define('DiagnosticSignHint', '💡', 'DiagnosticSignHint')

-- Change the border of the documentation hover window.
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'single',
})

-- Use Mason to manage the servers' setup.
-- Each setup must stay in this specific order!
-- See https://github.com/williamboman/mason-lspconfig.nvim#setup
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local lspconfig = require('lspconfig')

-- Prepare on_attach.
-- https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
local on_attach = function(_, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ...)
  end
  local lsp_buf = '<Cmd>lua vim.lsp.buf.'
  local lsp_codelens = '<Cmd>lua vim.lsp.codelens.'

  -- Add some keymapping.
  buf_set_keymap('gd', lsp_buf .. 'definition()<CR>', options)
  buf_set_keymap('gr', lsp_buf .. 'rename()<CR>', options)
  buf_set_keymap('K', lsp_buf .. 'hover()<CR>', options)
  buf_set_keymap('<Leader>a', lsp_buf .. 'code_action()<CR>', options)
  buf_set_keymap('<Leader>d', lsp_buf .. 'type_definition()<CR>', options)
  buf_set_keymap('<Leader>s', lsp_buf .. 'signature_help()<CR>', options)
  buf_set_keymap('<Leader>f', lsp_buf .. 'format{ async = true }<CR>', options)
  buf_set_keymap('<Leader>r', lsp_codelens .. 'run()<CR>', options)

  require('lsp_signature').on_attach({
    floating_window = false,
    handler_opts = {
      border = 'single',
    },
    hint_prefix = '👻 ',
  })

  -- Format on save for Rust files.
  vim.api.nvim_command('au BufWritePre *.rs lua vim.lsp.buf.format()')

  -- Refresh codelens when creating or reading a Rust file.
  vim.api.nvim_command(
    'au BufNewFile,BufRead *.rs lua vim.lsp.codelens.refresh()'
  )
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
  'json-lsp',
  'ltex-ls',
  'lua-language-server',
  'rust-analyzer',
  'shellcheck',
  'svelte-language-server',
  'tailwindcss-language-server',
  'taplo',
  'typescript-language-server',
  'yaml-language-server',
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
              features = 'all',
            },
            procMacro = {
              enable = true,
            },
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
            diagnostics = {
              enable = true,
              -- Fix issue with global vim being undefined for lua.
              globals = { 'vim' },
              disable = { 'lowercase-global' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files.
              library = vim.api.nvim_get_runtime_file('', true),
            },
          },
        },
      })
    elseif server == 'jdtls' then
      -- Noop - we don't want two clients!
      -- The LSP is attached based on the file type.
    else
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end
  end,
})

-- Special case for Java.
-- https://github.com/mfussenegger/nvim-jdtls
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/guides/setup-with-nvim-jdtls.md
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    local jdtls = require('jdtls')
    local mason_registry = require('mason-registry')
    local jdtls_pkg = mason_registry.get_package('jdtls')
    local jdtls_path = jdtls_pkg:get_install_path()
    local jdtls_bin = jdtls_path .. '/bin/jdtls'
    local root_markers = {
      '.git',
      'mvnw',
      'gradlew',
      'pom.xml',
      'build.gradle',
    }
    local root_dir = require('jdtls.setup').find_root(root_markers)
    local workspace_folder = '/tmp/nvim/jdtls/'
      .. vim.fn.fnamemodify(root_dir, ':p:h:t')
    local config = {
      cmd = {
        jdtls_bin,
        '-data',
        workspace_folder,
      },
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir,
      settings = {
        java = {
          configuration = {
            updateBuildConfiguration = 'automatic',
          },
          codeGeneration = {
            toString = {
              template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
            },
            useBlocks = true,
          },
          contentProvider = {
            preferred = 'fernflower',
          },
          eclipse = {
            downloadSources = true,
          },
          extendedClientCapabilities = jdtls.extendedClientCapabilities,
          implementationsCodeLens = {
            enabled = true,
          },
          maven = {
            downloadSources = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          signatureHelp = {
            enabled = true,
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
        },
      },
    }

    jdtls.start_or_attach(config)
  end,
})

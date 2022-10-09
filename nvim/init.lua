--[[
-- General options.
--]]

vim.g.markdown_fenced_languages = {
  'bash',
  'html',
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
-- Global Packer setup.
--]]

local install_path = vim.fn.stdpath('data')
  .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute(
    '!git clone https://github.com/wbthomason/packer.nvim ' .. install_path
  )
end

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

-- Configure Neovim to automatically run :PackerCompile whenever init.lua is
-- updated with an autocommand.
vim.api.nvim_exec(
  [[
    augroup Packer
      autocmd!
      autocmd BufWritePost init.lua PackerCompile
    augroup end
  ]],
  false
)

--[[
-- Packer plugins.
--]]

require('packer').startup(function(use)
  -- Let packer manage itself.
  use({ 'wbthomason/packer.nvim', opt = true })

  -- Icons.
  use({
    'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        default = true,
      })
    end,
  })

  -- Status line.
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          globalstatus = true,
          theme = 'tokyonight',
        },
      })
    end,
  })

  -- Telescope.
  use({
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
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
          path_display = { 'truncate' },
          -- Keep the same prompt as starship.
          prompt_prefix = '❯ ',
          scroll_strategy = 'limit',
        },
      })
    end,
  })
  use({
    'nvim-telescope/telescope-file-browser.nvim',
    requires = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension('file_browser')
    end,
  })
  use({
    'nvim-telescope/telescope-fzf-native.nvim',
    requires = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension('fzf')
    end,
    run = 'make',
  })

  -- Git related info in the signs columns and popups.
  use({
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup()
    end,
  })

  -- Highlight, edit, and navigate code using a fast incremental parsing library.
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
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
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'bash',
          'css',
          'dockerfile',
          'fish',
          'graphql',
          'html',
          'javascript',
          'json',
          'lua',
          'rust',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'yaml',
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
          matchup = { enable = true },
          indent = { enable = true },
          autotag = { enable = true },
          keymaps = {
            init_selection = 'gnn',
            node_decremental = 'grm',
            node_incremental = 'grn',
            scope_incremental = 'grc',
          },
        },
      })
    end,
  })

  -- Enhance UI.
  use('stevearc/dressing.nvim')

  -- LSP, LSP installer and tab completion.
  use({
    'williamboman/mason.nvim', -- Mason.
    'williamboman/mason-lspconfig.nvim', -- Mason LSP bridge.
    'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client.
  })
  use('hrsh7th/nvim-cmp') -- Autocompletion plugin.
  use('hrsh7th/cmp-nvim-lsp') -- LSP source for nvim-cmp.
  use('saadparwaiz1/cmp_luasnip') -- Snippets source for nvim-cmp.
  use('L3MON4D3/LuaSnip') -- Snippets plugin.
  use('onsails/lspkind-nvim') -- Adds pictograms to neovim built-in LSP.
  use('hrsh7th/cmp-path') -- Paths completion.
  use({
    'David-Kunz/cmp-npm', -- npm packages autocompletion.
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('cmp-npm').setup()
    end,
  })
  use('ray-x/lsp_signature.nvim') -- Live lsp signatures.
  use('hrsh7th/cmp-emoji') -- Emojis completion.

  -- Mason tool installer.
  use('WhoIsSethDaniel/mason-tool-installer.nvim')

  -- Get better LSP diagnostics.
  use({
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('trouble').setup()
    end,
  })

  -- Current theme.
  use({
    'folke/tokyonight.nvim',
    config = function()
      require('tokyonight').setup({
        hide_inactive_statusline = false,
        lualine_bold = true,
        style = 'storm',
        styles = {
          floats = 'transparent',
          functions = 'italic',
          variables = 'italic',
        },
      })
      vim.cmd('colorscheme tokyonight')
    end,
  })

  -- Rust niceties.
  use('rust-lang/rust.vim')
  use({
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  })

  -- Auto-close pairs.
  use({
    'windwp/nvim-autopairs',
    event = 'BufRead',
    config = function()
      require('nvim-autopairs').setup()
    end,
  })

  -- Auto-close tags.
  use({ 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' })

  -- Comments.
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  })

  -- Formatting.
  use({
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
          typescript = { prettierFormatter },
          typescriptreact = { prettierFormatter },
          yaml = { prettierFormatter },
        },
      })

      -- Execute formatting on buffer save.
      vim.api.nvim_exec(
        [[
	  augroup FormatAutogroup
	    autocmd!
	    autocmd BufWritePost *.css,*.html,*.json,*.js,*.jsx,*.lua,*.md,*.ts,*.tsx,*.yml FormatWrite
	  augroup END
        ]],
        true
      )
    end,
  })
end)

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
    { name = 'npm', keyword_length = 4 },
  }),
  view = {
    entries = 'custom',
  },
})

-- Use nice icons for diagnostics.
local function sign_define(name, icon, hl)
  vim.fn.sign_define(name, { text = icon, texthl = hl })
end

sign_define('DiagnosticSignError', ' ', 'DiagnosticSignError')
sign_define('DiagnosticSignWarn', '⚠️ ', 'DiagnosticSignWarn')
sign_define('DiagnosticSignInformation', ' ', 'DiagnosticSignInfo')
sign_define('DiagnosticSignHint', ' ', 'DiagnosticSignHint')

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
  buf_set_keymap('<Leader>r', lsp_codelens .. 'run()<CR>', options)

  require('lsp_signature').on_attach({
    floating_window = false,
    handler_opts = {
      border = 'single',
    },
    hint_prefix = '👻 ',
  })

  -- Format on save for Rust files.
  vim.api.nvim_command('au BufWritePre *.rs lua vim.lsp.buf.formatting_sync()')

  -- Refresh codelens when creating or reading a Rust file.
  vim.api.nvim_command(
    'au BufNewFile,BufRead *.rs lua vim.lsp.codelens.refresh()'
  )
end

-- Prepare capabilities.
local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- List of LSP servers and formatters automatically installed.
local ensure_installed = {
  -- Servers.
  -- See this mapping:
  -- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
  'bash-language-server',
  'dockerfile-language-server',
  'eslint-lsp',
  'graphql-language-service-cli',
  'html-lsp',
  'json-lsp',
  'ltex-ls',
  'lua-language-server',
  'rust-analyzer',
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

-- Setup all the servers by default.
mason_lspconfig.setup_handlers({
  function(server)
    lspconfig[server].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
})

-- Specific rust-analyzer setup.
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ['rust-analyzer'] = {
      assist = {
        importEnforceGranularity = true,
        importPrefix = 'crate',
      },
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      -- Add clippy lints for Rust.
      checkOnSave = {
        command = 'clippy',
      },
      procMacro = {
        enable = true,
      },
    },
  },
})

-- Specific sumneko_lua setup.
lspconfig.sumneko_lua.setup({
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
        library = vim.api.nvim_get_runtime_file('', true),
      },
    },
  },
})

-- Specific tsserver setup.
lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    documentFormatting = true,
    -- Ensure that tsconfig works in monorepos.
    root_dir = lspconfig.util.root_pattern(
      'package.json',
      'yarn.lock',
      'lerna.json',
      '.git'
    ),
  },
})

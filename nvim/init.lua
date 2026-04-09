-- vim.pack guide: https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack.html

--[[
-- Startup optimisation.
-- Enable Lua module caching (~30% startup improvement). Must be first.
--]]

vim.loader.enable()

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
vim.opt.number = true
vim.opt.signcolumn = 'yes'

--[[
-- Plugins.
-- Managed by vim.pack (built-in since Neovim 0.12).
-- Plugins auto-update once per day in the background (force = true skips confirmation).
-- Manual update: :lua vim.pack.update()
-- Delete unused: :lua vim.pack.del({ 'plugin-name' })
--]]

vim.pack.add({
  -- Filesystem explorer.
  { src = 'https://github.com/echasnovski/mini.files' },
  -- Auto-close pairs.
  { src = 'https://github.com/echasnovski/mini.pairs' },
  -- Surround motions (sa/sd/sr).
  { src = 'https://github.com/echasnovski/mini.surround' },
  -- Proper Lua development (lazydev integration with blink.cmp).
  { src = 'https://github.com/folke/lazydev.nvim' },
  -- Diagnostics list.
  { src = 'https://github.com/folke/trouble.nvim' },
  -- Keybinding hints.
  { src = 'https://github.com/folke/which-key.nvim' },
  -- Fuzzy finder.
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  -- Git signs in the gutter and blame popup.
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  -- Indentation guides.
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  -- Emoji completion source for blink.cmp.
  { src = 'https://github.com/moyiz/blink-emoji.nvim' },
  -- LSP client configurations.
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  -- Plenary Lua functions (required by several plugins).
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  -- Status line.
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
  -- Icons (used by fzf-lua and others).
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  -- Treesitter: highlight, indent, and incremental selection.
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  -- Snippets library (used by blink.cmp).
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  -- Current theme.
  { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine' },
  -- Rust Cargo.toml crate version hints.
  { src = 'https://github.com/Saecki/crates.nvim' },
  -- Completion engine (version-pinned for stability).
  -- Pin to a release tag so the pre-built native library (.so) is included.
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1.10.2' },
  -- Formatting.
  { src = 'https://github.com/stevearc/conform.nvim' },
  -- Mason tool installer (formatters, linters).
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  -- Mason: LSP/formatter installer.
  { src = 'https://github.com/williamboman/mason.nvim' },
  -- Mason ↔ nvim-lspconfig bridge.
  { src = 'https://github.com/williamboman/mason-lspconfig.nvim' },
  -- Auto-close HTML/JSX tags (used by nvim-treesitter).
  { src = 'https://github.com/windwp/nvim-ts-autotag' },
})

-- Auto-update plugins once per day in the background.
vim.schedule(function()
  local stamp = vim.fn.stdpath('data') .. '/vim-pack-last-update'
  local stat = vim.uv.fs_stat(stamp)
  local today = os.date('%Y-%m-%d')
  if not stat or vim.fn.readfile(stamp)[1] ~= today then
    vim.pack.update(nil, { force = true })
    vim.fn.writefile({ today }, stamp)
  end
end)

--[[
-- Colorscheme.
-- Set up before any other UI plugin to avoid flicker.
--]]

require('rose-pine').setup({
  variant = 'moon',
})
vim.cmd('colorscheme rose-pine')

--[[
-- Status line.
--]]

require('lualine').setup({
  options = {
    component_separators = '',
    globalstatus = true,
    section_separators = '',
    theme = 'rose-pine-alt',
  },
})

--[[
-- Filesystem explorer.
--]]

vim.keymap.set('n', '<leader>t', function()
  local mini_files = require('mini.files')
  local buf_name = vim.api.nvim_buf_get_name(0)
  local path = vim.fn.filereadable(buf_name) == 1 and buf_name
    or vim.fn.getcwd()
  mini_files.open(path)
  mini_files.reveal_cwd()
end, { desc = 'Mini files' })

--[[
-- Fuzzy finder.
--]]

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

vim.keymap.set('n', '<leader>z', '<cmd>FzfLua<cr>', { desc = 'Fzf' })
vim.keymap.set(
  'n',
  '<leader>b',
  '<cmd>FzfLua buffers resume=true<cr>',
  { desc = 'Fzf buffers' }
)
vim.keymap.set('n', '<leader>d', function()
  require('fzf-lua').lsp_definitions({ jump1 = true })
end, { desc = 'Fzf lsp definitions' })
vim.keymap.set(
  'n',
  '<leader>f',
  '<cmd>FzfLua files resume=true<cr>',
  { desc = 'Fzf files' }
)
vim.keymap.set('n', '<leader>g', function()
  require('fzf-lua').live_grep({ exec_empty_query = true, resume = true })
end, { desc = 'Fzf live grep' })
vim.keymap.set('n', '<leader>r', function()
  require('fzf-lua').lsp_references({ jump1 = true })
end, { desc = 'Fzf lsp references' })

--[[
-- Git signs.
--]]

require('gitsigns').setup()

vim.keymap.set(
  'n',
  '<leader>l',
  '<cmd>lua require("gitsigns").blame_line()<cr>',
  { desc = 'Gitsigns blame' }
)

--[[
-- Treesitter: syntax highlighting and parser management.
-- The new nvim-treesitter (main branch) only installs parsers; highlighting
-- must be enabled explicitly per buffer via vim.treesitter.start().
-- Requires the tree-sitter CLI for compilation (paru -S tree-sitter-cli).
--]]

-- Enable treesitter highlighting for any filetype that has a parser installed.
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Ensure parsers are installed. Skips already-installed ones.
-- Requires the tree-sitter CLI; silently skips if not available.
if vim.fn.executable('tree-sitter') == 1 then
  vim.schedule(function()
    require('nvim-treesitter.install').install({
      'bash',
      'css',
      'dockerfile',
      'fish',
      'html',
      'java',
      'javascript',
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
      'zig',
    })
  end)
end

-- Run :TSUpdate automatically after nvim-treesitter is updated.
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind == 'update' then
      vim.cmd('TSUpdate')
    end
  end,
})

--[[
-- Completion (blink.cmp).
--]]

---@module 'blink.cmp'
---@type blink.cmp.Config
require('blink.cmp').setup({
  completion = {
    documentation = {
      auto_show = true,
    },
    ghost_text = {
      enabled = true,
    },
  },
  keymap = {
    preset = 'default',
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
})

--[[
-- Formatting (conform.nvim).
--]]

---@module "conform"
---@type conform.setupOpts
require('conform').setup({
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
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set('n', '<leader>p', function()
  require('conform').format({ async = true })
end, { desc = 'Format buffer' })

--[[
-- Diagnostics list (trouble.nvim).
--]]

require('trouble').setup({
  modes = {
    diagnostics = {
      auto_close = true,
    },
  },
})

vim.keymap.set(
  'n',
  '<leader>xX',
  '<cmd>Trouble diagnostics toggle<cr>',
  { desc = 'Trouble Diagnostics' }
)
vim.keymap.set(
  'n',
  '<leader>xx',
  '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
  { desc = 'Trouble Buffer Diagnostics' }
)

--[[
-- Indentation guides.
--]]

require('ibl').setup()

--[[
-- Deferred plugins.
-- Loaded after startup to avoid blocking the initial render.
--]]

vim.schedule(function()
  -- Keybinding hints.
  require('which-key').setup({
    spec = {
      { '<leader>x', group = 'diagnostics' },
    },
  })
  -- Auto-close pairs.
  require('mini.pairs').setup()
  -- Surround motions (sa/sd/sr).
  require('mini.surround').setup()
end)

--[[
-- Filetype-deferred plugins.
--]]

-- lazydev: Lua LSP improvements. Only meaningful for Lua files.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lua',
  once = true,
  callback = function()
    require('lazydev').setup({
      library = {
        -- Load luvit types when the `vim.uv` word is found.
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    })
  end,
})

-- crates.nvim: Cargo.toml crate version hints. Only needed in Rust projects.
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = 'Cargo.toml',
  once = true,
  callback = function()
    require('crates').setup({})
  end,
})

--[[
-- LSP Setup.
--]]

-- Diagnostics configuration.
vim.diagnostic.config({
  update_in_insert = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
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

    vim.keymap.set('n', 'gr', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover({ border = 'single' })
    end, opts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)

    -- Enable inlay hints if supported.
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
  'tsgo',
  'yaml-language-server',
  'yamllint',
}

mason.setup({
  ui = {
    check_outdated_packages_on_open = true,
    icons = {
      server_installed = '',
      server_pending = '',
      server_uninstalled = '',
    },
  },
})

mason_lspconfig.setup({
  automatic_enable = true,
  auto_update = true,
})

mason_tool_installer.setup({
  auto_update = true,
  ensure_installed = ensure_installed,
})

-- Specific rust-analyzer setup.
vim.lsp.config('rust_analyzer', {
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

-- Specific zls setup.
-- This LSP is not managed by Mason but by zvm.
vim.lsp.config('zls', {
  settings = {
    warn_style = true,
  },
})
vim.lsp.enable('zls')

-- TypeScript/JavaScript setup via tsgo.
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
vim.lsp.config('tsgo', {
  settings = {
    typescript = shared_settings,
    javascript = shared_settings,
  },
})

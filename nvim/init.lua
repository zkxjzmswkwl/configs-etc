------------------------------------------------------------
-- Bootstrap packer
------------------------------------------------------------
vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'hrsh7th/nvim-cmp'

  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'

  -- Colors
  use {'srcery-colors/srcery-vim', as = 'srcery'}
  use 'blazkowolf/gruber-darker.nvim'
  use { 'catppuccin/nvim', as = 'catppuccin' }
  use 'aktersnurra/no-clown-fiesta.nvim'
  use { 'Everblush/nvim', as = 'everblush' }
  use { 'uloco/bluloco.nvim', requires = { 'rktjmp/lush.nvim' } }
  use 'rafi/awesome-vim-colorschemes'
  use 'xero/miasma.nvim'
  use({ 'rose-pine/neovim', as = 'rose-pine' })

  -- UI / Utils
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'
  use 'ThePrimeagen/vim-be-good'
  use 'ThePrimeagen/harpoon'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'vim-autoformat/vim-autoformat'
  use 'darrikonn/vim-gofmt'

  -- Terminal
  use 'akinsho/toggleterm.nvim'
  use {
    's1n7ax/nvim-terminal',
    config = function()
      vim.o.hidden = true
      require('nvim-terminal').setup()
    end,
  }

  -- Telescope
	use {
	  'nvim-telescope/telescope.nvim',
	  requires = { 'nvim-lua/plenary.nvim' }
	}

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })()
    end,
  }

  -- Formatter (modern)
  use 'stevearc/conform.nvim'
end)

------------------------------------------------------------
-- Core options
------------------------------------------------------------
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.g.mapleader = " "

------------------------------------------------------------
-- Colorscheme
------------------------------------------------------------
vim.cmd [[colorscheme srcery]]

------------------------------------------------------------
-- LSP (CORRECT for Neovim 0.11 + lsp-zero v1)
------------------------------------------------------------
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'clangd', 'ols' },
})

vim.lsp.config.clangd = {}
vim.lsp.config.ols = {}

vim.lsp.enable({ 'clangd', 'ols' })
------------------------------------------------------------
-- Completion
------------------------------------------------------------
local cmp = require('cmp')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  mapping = {
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

------------------------------------------------------------
-- Formatting (stylua FIXED — not an LSP)
------------------------------------------------------------
require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    c = { 'clang-format' },
    cpp = { 'clang-format' },
  },
})

vim.keymap.set('n', '<leader>f', function()
  require('conform').format({ async = true })
end)

------------------------------------------------------------
-- Telescope
------------------------------------------------------------
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fg', builtin.git_files)
vim.keymap.set('n', '<leader>fs', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
require("telescope").setup({
  pickers = { colorscheme = { enable_preview = true } }
})

------------------------------------------------------------
-- Harpoon
------------------------------------------------------------
local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

vim.keymap.set('n', '<leader>a', mark.add_file)
vim.keymap.set('n', '<leader>l', ui.toggle_quick_menu)
vim.keymap.set('n', '<C-1>', function() ui.nav_file(1) end)
vim.keymap.set('n', '<C-2>', function() ui.nav_file(2) end)
vim.keymap.set('n', '<C-3>', function() ui.nav_file(3) end)
vim.keymap.set('n', '<C-4>', function() ui.nav_file(4) end)
vim.keymap.set('n', '<C-5>', function() ui.nav_file(5) end)
vim.keymap.set('n', '<C-6>', function() ui.nav_file(6) end)
vim.keymap.set('n', '<C-7>', function() ui.nav_file(7) end)
vim.keymap.set('n', '<C-8>', function() ui.nav_file(8) end)
vim.keymap.set('n', '<C-9>', function() ui.nav_file(9) end)
vim.keymap.set('n', '<C-0>', function() ui.nav_file(0) end)

------------------------------------------------------------
-- Nvim-tree
------------------------------------------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup()
vim.keymap.set('n', '<C-n>', ':NvimTreeOpen<CR>')

------------------------------------------------------------
-- Toggleterm
------------------------------------------------------------
require("toggleterm").setup({
  size = 20,
  open_mapping = [[<c-\>]],
  direction = "float",
  start_in_insert = true,
  close_on_exit = true,
})

function _G.set_terminal_keymaps()
  local opts = { noremap = true }
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

------------------------------------------------------------
-- Diagnostics
------------------------------------------------------------
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)


local g   = vim.g
local o   = vim.o
local opt = vim.opt
local A   = vim.api

-- cmd('syntax on')
-- vim.api.nvim_command('filetype plugin indent on')

o.termguicolors = true
-- o.background = 'dark'

-- Do not save when switching buffers
-- o.hidden = true

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

-- Better editor UI
o.number = true
o.relativenumber = true
-- o.numberwidth = 2
-- o.signcolumn = 'yes'
o.cursorline = true

-- Better editing experience
o.expandtab = true
o.smarttab = true
o.cindent = true
o.autoindent = true
-- o.smartindent = true
o.wrap = true
-- o.textwidth = 300
o.tabstop = 4
o.shiftwidth = 4
-- o.softtabstop = 4
o.softtabstop = -1 -- If negative, shiftwidth value is used
o.list = true
-- o.listchars = 'trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂'
-- o.listchars = 'eol:¬,space:·,lead: ,trail:·,nbsp:◇,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ,'
-- o.formatoptions = 'qrn1'

-- Makes neovim and host OS clipboard play nicely with each other
o.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
-- o.smartcase = true

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false
-- o.backupdir = '/tmp/'
-- o.directory = '/tmp/'
-- o.undodir = '/tmp/'

-- Remember 50 items in commandline history
o.history = 50

-- Better buffer splitting
o.splitbelow = true
o.splitright = true

-- Preserve view while jumping
-- BUG This option causes an error!
-- o.jumpoptions = 'view'

-- BUG: this won't update the search count after pressing `n` or `N`
-- When running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen
-- o.lazyredraw = true

-- Better folds (don't fold by default)
-- o.foldmethod = 'indent'
-- o.foldlevelstart = 99
-- o.foldnestmax = 3
-- o.foldminlines = 1
--
-- opt.mouse = "a"

-- Map <leader> to space
g.mapleader = ' '
g.maplocalleader = ' '

-- General settings
--
--

require('lualine').setup()

-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-gruvbox-dark-medium')
-- vim.g.gruvbox_contrast_dark = 'hard'
vim.cmd("colorscheme gruvbox")

-- Keybinds
local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

-- Fix * (Keep the cursor position, don't move to next match)
map('n', '*', '*N')
-- Fix n and N. Keeping cursor in center
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')
-- Mimic shell movements
map('i', '<C-E>', '<ESC>A')
map('i', '<C-A>', '<ESC>I')

-- Quit neovim
map('n', '<M-q>', ':q<CR>')

map('n', '<leader>p', 'viw"_dP')

-- PLUGINS
--
-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- A better status line
  use {
     'nvim-lualine/lualine.nvim',
     requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- File management --
  -- use 'vifm/vifm.vim'
  -- use 'scrooloose/nerdtree'
  use 'preservim/nerdtree'
  use 'tiagofumo/vim-nerdtree-syntax-highlight'
  -- use 'ryanoasis/vim-devicons'

  -- Productivity --
  use 'vimwiki/vimwiki'
  -- use 'jreybert/vimagit'
  use 'junegunn/fzf'
  use 'tpope/vim-surround'

  -- Tim Pope Plugins --
  use 'tpope/vim-surround'

  -- Syntax Highlighting and Colors --
  -- use 'PotatoesMaster/i3-vim-syntax'
  -- use 'kovetskiy/sxhkd-vim'
  use 'vim-python/python-syntax'
  use 'ap/vim-css-color'

  -- Junegunn Choi Plugins --
  -- use 'junegunn/goyo.vim'
  -- use 'junegunn/limelight.vim'
  use 'junegunn/vim-emoji'

  -- Colorschemes
  -- use 'RRethy/nvim-base16'
  use("gruvbox-community/gruvbox")

  -- Other stuff
  -- use 'frazrepo/vim-rainbow'
end)

require'lspconfig'.pyright.setup{}
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

-- Editing settings
o.number = true
o.relativenumber = true
-- o.numberwidth = 2
-- o.signcolumn = 'yes'
o.cursorline = true

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
vim.opt.wrap = false -- No Wrap lines
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
-- vim.cmd("autocmd!")
-- vim.opt.cmdheight = 1
--
vim.cmd([[
set runtimepath+=~/.vim
set rtp+=~/.fzf
set noerrorbells
set noeb vb t_vb=
set autoread
set autowrite
set wildmenu
set nocompatible
set shiftround
set hls
set autochdir
set complete+=kspell
set shortmess+=c
set completeopt+=longest,menuone
set completeopt+=preview
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

let g:jedi#popup_on_dot = 1
" Syntastic
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let NERDTreeShowHidden=1

" Disable tab key for vimwiki (enables autocomplete via tabbing)
let g:vimwiki_key_mappings = { 'table_mappings': 0 }
]])
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
-- map('n', '*', '*N')
-- Fix n and N. Keeping cursor in center
-- map('n', 'n', 'nzz')
-- map('n', 'N', 'Nzz')

-- Mimic shell movements
map('i', '<C-E>', '<ESC>A')
map('i', '<C-A>', '<ESC>I')
map('i', '<C-v>', '<Esc>"+p')
map('i', '<C-a>', '<Esc>gg"yG') -- Copy everything from file into clipboard
map('i', '<C-BS>', '<C-W>a') -- Copy everything from file into clipboard
-- Undo break points
-- map('i', ',', ',<c-g>u')
-- map('i', '.', '.<c-g>u')
-- map('i', '!', '!<c-g>u')
-- map('i', '?', '?<c-g>u')

-- Make shift-insert work like in Xterm
map('i', '<S-Insert>', '<Esc><MiddleMouse>A')
map('n', '<S-Insert>', '<MiddleMouse>')

map('n', '<M-q>', ':q<CR>') -- Quit neovim
map('n', '<M-z>', ':noh<CR>')
-- map('n', '<M-x>', ':call CompileRun()<CR>')
map('n', 'Y', 'y$') -- Yank till end of line
map('n', 'F4', '<Esc>:set cursorline!<CR>')
map('n', 'F5', '<Esc>:setlocal spell! spelllang=en_us<CR>')
map('n', 'F6', '<Esc>:setlocal spell! spelllang=sv<CR>')

map('n', '<leader>p', 'viw"_dP') -- Replace from void
map('n', '<leader>d', '"_d') -- Delete to void
map('v', '<leader>d', '"_d') -- Delete to void

-- Paste from previous registers
map('n', '<leader>1', '"1p')
map('n', '<leader>2', '"2p')
map('n', '<leader>3', '"3p')
map('n', '<leader>4', '"4p')
map('n', '<leader>5', '"5p')

map('n', '<M-w>', ':NERDTreeToggle ~/<CR>')
map('n', '<M-e>', ':NERDTreeToggle %:p<CR>')
-- map('n', '<C-b>', ':NERDTreeToggle<CR>')
map('n', '<M-d>', ':FZF<CR>')
map('n', '<M-a>', ':FZF ~/<CR>')
map('n', '<M-A>', ':FZF /<CR>')

-- Vimgrep and QuickFix Lists
map('n', '<M-f>', ':vimgrep // **/*.txt<left><left><left><left><left><left><left><left><left><left><C-f>i')
map('n', '<M-g>', ':vimgrep // **/*<Left><Left><Left><Left><Left><Left><C-f>i')
map('n', '<M-v>', ':cfdo s//x/gc<left><left><left><left><left><C-f>i')
map('n', '<M-c>', ':cnext<CR>')
map('n', '<M-p>', ':cprev<CR>')
map('n', '<M-l>', ':clast<CR>')
map('n', '<M-b>', ':copen<CR>')

-- Window management and movement
map('n', '<M-u>', ':resize +2<CR>')
map('n', '<M-i>', ':resize -2<CR>')
map('n', '<M-o>', ':vertical resize +2<CR>')
map('n', '<M-y>', ':vertical resize -2<CR>')
map('n', '<M-h>', '<Plug>WinMoveLeft')
map('n', '<M-j>', '<Plug>WinMoveDown')
map('n', '<M-k>', '<Plug>WinMoveUp')
map('n', '<M-l>', '<Plug>WinMoveRight')

-- Moving text and indentation
map('x', 'K', ":move '<-2<CR>gv-gv")
map('x', 'J', ":move '>+1<CR>gv-gv")
map('n', '<leader>j', ':join<CR>')
map('n', '<leader>J', ':join!<CR>')
map('n', '<leader>z', '<Plug>Zoom')

-- Indentation
map('v', '<leader><', ':le<CR>')
map('n', '<leader><', ':le<CR>')
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Tab keybinds
map('n', '<M-t>', ':tabe<CR>')
map('n', '<M-s>', ':split<CR>')
map('n', '<M-Enter>', ':vsp<CR>')
map('n', '<M-<>', ':vsp<CR>')
-- Go to tab by number
map('n', '<M-1>', '1gt')
map('n', '<M-2>', '2gt')
map('n', '<M-3>', '3gt')
map('n', '<M-4>', '4gt')
map('n', '<M-5>', '5gt')
map('n', '<M-6>', '6gt')
map('n', '<M-7>', '7gt')
map('n', '<M-8>', '8gt')
map('n', '<M-9>', '9gt')
map('n', '<M-0>', ':tablast<CR>')

-- Session management
map('n', '<leader>o', '<C-^>')
map('n', '<leader>m', ':mks! ~/.vim/sessions/s.vim<CR>')
map('n', '<leader>,', ':mks! ~/.vim/sessions/s2.vim<CR>')
map('n', '<leader>.', ':so ~/.vim/sessions/s.vim<CR>')
map('n', '<leader>-', ':so ~/.vim/sessions/s2.vim<CR>')

-- Open vim config in new tab
map('n', '<M-m>', ':tabe ~/.config/nvim/init.lua<CR>')
map('n', '<M-,>', ':tabe ~/.config/i3/config<CR>')
map('n', '<M-.>', ':tabe ~/.zshrc<CR>')
map('n', '<C-c>', 'y')
-- map('v', '<C-c>', 'y')

map('n', '<leader>s', "/\\s\\+$/<CR>") -- Show extra whitespace
map('n', '<leader>ws', ':%s/\\s\\+$<CR>') -- Remove all extra whitespace
map('n', '<leader>wu', ':%s/\\%u200b//g<cr>') -- Remove all extra unicode chars
map('n', '<leader>wb', ':%s/[[:cntrl:]]//g<cr>') -- Remove all hidden characters
map('n', '<leader>r', 'gqG<C-o>zz') -- Format rest of the text with vim formatting, go back and center screen
map('v', '<leader>gu', ':s/\\<./\\u&/g<cr>') -- Capitalize first letter of each word on visually selected line

-- Use tab and s-tab to navigate the completion list
vim.keymap.set('i', '<Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-N>' or '<Tab>'
end, {expr = true})

vim.keymap.set('i', '<S-Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-P>' or '<S-Tab>'
end, {expr = true})


-- vim.api.nvim_command('autocmd BufEnter *.tex :set wrap linebreak nolist spell')
-- Filetype shortcuts
vim.cmd([[
autocmd FileType html inoremap <i<Tab> <em></em> <Space><++><Esc>/<<Enter>GNi
autocmd FileType html inoremap <b<Tab> <b></b><Space><++><Esc>/<<Enter>GNi
autocmd FileType html inoremap <h1<Tab> <h1></h1><Space><++><Esc>/<<Enter>GNi
autocmd FileType html inoremap <h2<Tab> <h2></h2><Space><++><Esc>>/<<Enter>GNi
autocmd FileType html inoremap <im<Tab> <img></img><Space><++><Esc>/<<Enter>GNi

autocmd FileType java inoremap fore<Tab> for (String s : obj){<Enter><Enter>}<Esc>?obj<Enter>ciw
autocmd FileType java inoremap for<Tab> for(int i = 0; i < val; i++){<Enter><Enter>}<Esc>?val<Enter>ciw
autocmd FileType java inoremap sout<Tab> System.out.println("");<Esc>?""<Enter>li
autocmd FileType java inoremap psvm<Tab> public static void main(String[] args){<Enter><Enter>}<Esc>?{<Enter>o

autocmd FileType cs inoremap sout<Tab> Console.WriteLine("");<Esc>?""<Enter>li
autocmd FileType cs inoremap fore<Tab> for each (object o : obj){<Enter><Enter>}<Esc>?obj<Enter>ciw
autocmd FileType cs inoremap for<Tab> for(int i = 0; i < val; i++){<Enter><Enter>}<Esc>?val<Enter>ciw

autocmd FileType sql inoremap fun<Tab> delimiter //<Enter>create function x ()<Enter>returns int<Enter>no sql<Enter>begin<Enter><Enter><Enter>end //<Enter>delimiter ;<Esc>/x<Enter>GN
autocmd FileType sql inoremap pro<Tab> delimiter //<Enter>create procedure x ()<Enter>begin<Enter><Enter><Enter>end //<Enter>delimiter ;<Esc>/x<Enter>GN
autocmd FileType sql inoremap vie<Tab> create view x as<Enter>select <Esc>/x<Enter>GN

autocmd FileType vtxt,vimwiki,wiki,text inoremap line<Tab> ----------------------------------------------------------------------------------<Enter>
autocmd FileType vtxt,vimwiki,wiki,text inoremap date<Tab> <-- <C-R>=strftime("%Y-%m-%d %a")<CR><Esc>A -->
autocmd FileType c inoremap for<Tab> for(int i = 0; i < val; i++){<Enter><Enter>}<Esc>?val<Enter>ciw

]])

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
  -- use 'scrooloose/nerdtree'
  use 'preservim/nerdtree'
  use 'tiagofumo/vim-nerdtree-syntax-highlight'
  -- use 'vifm/vifm.vim'
  -- use 'ryanoasis/vim-devicons'

  -- Productivity --
  use 'vimwiki/vimwiki'
  use 'tpope/vim-surround'
  use 'junegunn/fzf'
  -- use 'junegunn/goyo.vim'
  -- use 'junegunn/limelight.vim'
  use 'junegunn/vim-emoji'
  -- use 'jreybert/vimagit'

  -- Syntax Highlighting and Colors --
  use 'vim-python/python-syntax'
  use 'ap/vim-css-color'
  use 'vim-syntastic/syntastic'
  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  -- use 'mechatroner/rainbow_csv'
  -- use 'PotatoesMaster/i3-vim-syntax'
  -- use 'kovetskiy/sxhkd-vim'

  -- Colorschemes
  use("gruvbox-community/gruvbox")
  -- use 'RRethy/nvim-base16'

  -- Other stuff
  -- use 'frazrepo/vim-rainbow'
end)

" GENERAL {{{
syntax enable " Enable syntax highlighting
let mapleader = "\<Space>" " Setup leader key
" }}}

" VARS {{{
set autoindent
set autoread " autoload file changes
set autowriteall " autosave files
set background=dark " dark colorscheme
set backspace=indent,eol,start " allow backspace in insert mode
"set diffopt+=vertical " split diffopt in vertical mode
set encoding=utf-8 " set character encoding to UTF-8
set expandtab " convert tabs to spaces
set hidden " hide when switching buffers instead of unloading
set hlsearch " highlights the string matched by the search
set ignorecase " make searching case insensitive
set incsearch " incremental search
set nobackup " disable backups
set nocompatible " use Vim settings, rather than Vi
set noswapfile " disable swapfile
set nowrap " disable line wrapping
set number " enable line numbers
set scrolloff=10 " keep cursor at the minimum 10 rows from the screen borders
set shiftwidth=4 " 4 spaces
set showmatch " show matching brackets
set sidescroll=1 " incrementally scroll one character
set smartcase " unless the query has capital letters
set splitbelow " open new split below
set splitright " open new split right
set t_Co=256
set tabstop=4 " 4 spaces
set termguicolors " enable True color
set ttyfast " always assume a fast terminal
set updatetime=250 " reduce update time in Vim
set wildmenu " visual autocomplete for command menu (ctrl-n and ctrl-p to scroll thru matches)
" }}}

" Mappings Configuration
noremap <C-b> :NERDTreeToggle<CR>

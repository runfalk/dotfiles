set encoding=utf-8  " Use sensible encoding (fixes pasting of unicode)
set nocompatible  " be iMproved, required

" Plugins (must use single quotes)
call plug#begin()
Plug 'editorconfig/editorconfig-vim'
Plug 'lyuts/vim-rtags'
Plug 'mbbill/undotree'
Plug 'mkitt/tabline.vim'
Plug 'othree/eregex.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()


" Look and theme
syntax on  " Syntax highlighting
set number  " Line numbering
colorscheme gruvbox  " Color scheme (from aweome-vim colorschemes)
set background=dark  " Force dark mode
set colorcolumn=80,120  " Helpful rulers
set fillchars+=vert:│  " Fix ugly vertical separator
set hlsearch  " Highlight search results
set incsearch  " Interactive highlight for search


" Basic functionality
set backspace=indent,eol,start  " Make backspace sensible
set mouse=a  " Mouse support
set wildmode=longest,list,full  " Fuzzy complete
set wildmenu  " Fuzzy complete
set expandtab  " Tab is spaces
set tabstop=4 shiftwidth=4 softtabstop=4  " Tab is 4 spaces
set directory=~/.vim/swapfiles//  " Put swapfiles in a better place

" Show whitespace at EOL
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter,InsertLeave * match ExtraWhitespace /\s\+$/

" Some NeoVim specific settings
if has("nvim")
    set guicursor=  " Fix slim cursor on insert mode
endif


" Open NERDTree when passing a directory as argument to Vim
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe "NERDTree" argv()[0] | wincmd p | ene | endif

" Close Vim when NERDTree is the only active buffer
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Change NERDTree directory when changing :pwd (requires Vim 8.0.1459)
if exists("##DirChanged")
    autocmd DirChanged global :NERDTreeCWD<CR>
endif


" Airline statusbar configuration
set noshowmode  " Don't show mode in command bar
let g:airline_theme = "gruvbox"
let g:airline_powerline_fonts = 1  " Requires Nerd fonts
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = "unique_tail_improved"
let g:airline_section_z = "%#__accent_bold#%{g:airline_symbols.linenr} %l/%L%#__restore__# (%v)"


" RTags configuration
let g:rtagsUseDefaultMappings = 0


" Leader
let mapleader = "-"

" Alt+Left/Right navigation for windows
nnoremap <silent> <A-Left> :wincmd h<CR>
nnoremap <silent> <A-Right> :wincmd l<CR>

" Alt+Up/Down for buffer navigation
nnoremap <silent> <A-Up> :bprev<CR>
nnoremap <silent> <A-Down> :bnext<CR>

" Clear highlighting by double tapping escape
nnoremap <silent> <esc><esc> :noh<CR>

" Tree style undo
nnoremap <silent> <C-z> :UndotreeToggle<CR>

" Multi cursor editing (Sublime style)
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_next_key = "<C-d>"
let g:multi_cursor_prev_key = "<C-S-d>"
let g:multi_cursor_skip_key = "<C-A-d>"
let g:multi_cursor_quit_key = "<esc>"

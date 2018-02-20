set encoding=utf-8  " Use sensible encoding (fixes pasting of unicode) 
set nocompatible  " be iMproved, required

call plug#begin()
Plug 'rafi/awesome-vim-colorschemes'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mkitt/tabline.vim'
call plug#end()

" Settings goes here
syntax on  " Syntax highlighting
set number  " Line numbering
colorscheme molokai  " Color scheme (from aweome-vim colorschemes)
set backspace=indent,eol,start  " Make backspace sensible
set colorcolumn=80,120  " Helpful rulers
set fillchars+=vert:│  " Fix ugly vertical separator
set mouse=a  " Mouse support
set wildmode=longest,list,full  " Fuzzy complete
set wildmenu  " Fuzzy complete

" Open NERDTree when passing a directory as argument to Vim
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Change NERDTree directory when changing :pwd (requires Vim 8.0.1459)
" autocmd DirChanged global :NERDTreeCWD<CR>

" Airline statusbar configuration
set noshowmode
let g:airline_theme='molokai'
let g:airline_powerline_fonts = 1  " Requires Nerd fonts
let g:airline#extensions#tabline#enabled = 1

" Alt+Left/Right navigation for windows
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" Alt+Up/Down for buffer navigation
nmap <silent> <A-Up> :bprev<CR>
nmap <silent> <A-Down> :bnext<CR>

" Some NeoVim specific settings
if has('nvim')
    set guicursor=  " Re-enable block cursor
endif

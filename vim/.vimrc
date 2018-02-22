set encoding=utf-8  " Use sensible encoding (fixes pasting of unicode)
set nocompatible  " be iMproved, required

" Plugins (must use single quotes)
call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.vim/fzf', 'do': './install --bin' }
Plug 'lyuts/vim-rtags'
Plug 'mbbill/undotree'
Plug 'mkitt/tabline.vim'
Plug 'othree/eregex.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'sgur/vim-editorconfig'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Deoplete support
if has("nvim")
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
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
let g:python3_host_prog = expand("~") . "/.vim/python3-venv/bin/python"  " Python 3 venv

" Show whitespace at EOL
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter,InsertLeave * match ExtraWhitespace /\s\+$/

" Some NeoVim specific settings
if has("nvim")
    set guicursor=  " Fix slim cursor on insert mode
endif


" Airline statusbar configuration
set noshowmode  " Don't show mode in command bar
let g:airline_theme = "gruvbox"
let g:airline_powerline_fonts = 1  " Requires Nerd fonts
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = "unique_tail_improved"
let g:airline_section_z = "%#__accent_bold#%{g:airline_symbols.linenr} %l/%L%#__restore__# (%v)"


" FZF
command! -bang FZFHidden
  \ call fzf#run(fzf#wrap("find-hidden", {"source": "find . -not \\( -name .git -prune \\) -type f -print 2> /dev/null"}, <bang>0))
let g:fzf_action = {"ctrl-v": "vsplit"}
let g:fzf_layout = {"down": "~30%"}

" Make FZF respect current theme
let g:fzf_colors =
\ { "fg":      ["fg", "Normal"],
  \ "bg":      ["bg", "Normal"],
  \ "hl":      ["fg", "Comment"],
  \ "fg+":     ["fg", "CursorLine", "CursorColumn", "Normal"],
  \ "bg+":     ["bg", "CursorLine", "CursorColumn"],
  \ "hl+":     ["fg", "Statement"],
  \ "info":    ["fg", "PreProc"],
  \ "border":  ["fg", "Ignore"],
  \ "prompt":  ["fg", "Conditional"],
  \ "pointer": ["fg", "Exception"],
  \ "marker":  ["fg", "Keyword"],
  \ "spinner": ["fg", "Label"],
  \ "header":  ["fg", "Comment"] }


" Deoplete
let g:deoplete#enable_at_startup = 1


" RTags configuration (key bindings in cpp.vim)
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

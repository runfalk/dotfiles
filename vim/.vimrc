set encoding=utf-8  " Use sensible encoding (fixes pasting of unicode)
set nocompatible  " Disable Vi compatibility

" Plugins (must use single quotes)
call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.vim/fzf', 'do': './install --bin' }
Plug 'lyuts/vim-rtags'
Plug 'mbbill/undotree'
Plug 'othree/eregex.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'runfalk/vim-fzf-extended'  " Depends on junegunn/fzf
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
highlight! link String GruvboxYellow
set colorcolumn=80,120  " Helpful rulers
set fillchars+=vert:│  " Fix ugly vertical separator
set hlsearch  " Highlight search results
set incsearch  " Interactive highlight for search
set showcmd  " Show key presses in status bar


" Basic functionality
set backspace=indent,eol,start  " Make backspace sensible
set mouse=a  " Mouse support
set wildmode=longest,list,full  " Fuzzy complete
set wildmenu  " Fuzzy complete
set tabstop=4  " Render tabs as 4 spaces
set expandtab  " Tab is spaces
set shiftwidth=4 softtabstop=4  " Tab is 4 spaces
set directory=~/.vim/swapfiles//  " Put swapfiles in a better place

" Load a virtualenv version of Python for plugins
let g:python3_host_prog = expand("~") . "/.vim/python3-venv/bin/python"

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
let g:airline_section_z = "%#__accent_bold#%{g:airline_symbols.linenr} %l/%L%#__restore__# (%v)"


" FZF configuration
let g:fzf_action = {"ctrl-v": "vsplit"}
let g:fzf_layout = {"down": "~30%"}

" Hide status line in FZF window
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noruler
\   | autocmd BufLeave <buffer> set laststatus=2 ruler

" Shorthands for FZF searches
function! s:CommandAbbreviation(cmd, meaning)
    execute
    \    "cabbrev <expr> " . a:cmd . " " .
    \    "getcmdtype() == ':' && getcmdline() =~ '^" . a:cmd . "$' ?"
    \    "'" . a:meaning . "' : '" . a:cmd . "'"
endfunction

call s:CommandAbbreviation("bs", "FZFBuffers")
call s:CommandAbbreviation("defs", "FZFDefinitions")
call s:CommandAbbreviation("open", "FZFFiles")


" Deoplete
let g:deoplete#enable_at_startup = 1


" Fix multiple cursors conflict with Deoplete
function! Multiple_cursors_before()
    let g:deoplete#disable_auto_complete = 1
endfunction
function! Multiple_cursors_after()
    let g:deoplete#disable_auto_complete = 0
endfunction

" RTags configuration (key bindings in cpp.vim)
let g:rtagsUseDefaultMappings = 0


" Leader
let mapleader = "-"

" Alt+Left/Right/Up/Down navigation for windows
nnoremap <silent> <A-Left> :wincmd h<CR>
nnoremap <silent> <A-Right> :wincmd l<CR>
nnoremap <silent> <A-Up> :wincmd k<CR>
nnoremap <silent> <A-Down> :wincmd j<CR>

" Tree style undo
nnoremap <silent> <C-z> :UndotreeToggle<CR>

" Clear search highlighting
nmap <silent> <C-c> :let@/=""<CR>

" Multi cursor editing (Sublime style)
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_next_key = "<C-d>"
let g:multi_cursor_prev_key = "<C-S-d>"
let g:multi_cursor_skip_key = "<C-A-d>"
let g:multi_cursor_quit_key = "<esc>"

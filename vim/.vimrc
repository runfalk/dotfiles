set encoding=utf-8  " Use sensible encoding (fixes pasting of unicode)
set nocompatible  " Disable Vi compatibility

" Set suda prefix before loading the module
let g:suda#prefix = "sudo://"

" Plugins (must use single quotes)
call plug#begin()
Plug 'junegunn/fzf', { 'dir': '~/.vim/fzf', 'do': './install --bin' }
Plug 'lambdalisue/suda.vim'
Plug 'mbbill/undotree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'othree/eregex.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'easymotion/vim-easymotion'
Plug 'runfalk/vim-fzf-extended'  " Depends on junegunn/fzf
Plug 'sgur/vim-editorconfig'
Plug 'sheerun/vim-polyglot'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()


" Look and theme
syntax on  " Syntax highlighting
set number  " Line numbering
silent! colorscheme gruvbox  " Color scheme (from aweome-vim colorschemes)
set background=dark  " Force dark mode
highlight! link String GruvboxYellow
set colorcolumn=80,120  " Helpful rulers
set fillchars+=vert:│  " Fix ugly vertical separator
set hlsearch  " Highlight search results
set incsearch  " Interactive highlight for search
set showcmd  " Show key presses in status bar
highlight clear SignColumn  " Make gutter have same background as line numbers


" Basic functionality
set hidden  " Don't complain about unsaved changes when switching files
set backspace=indent,eol,start  " Make backspace sensible work for indentation and newlines
set mouse=a  " Mouse support
set wildmode=longest,list,full  " Fuzzy complete
set wildmenu  " Fuzzy complete
set tabstop=4  " Render tabs as 4 spaces
set expandtab  " Tab is spaces
set shiftwidth=4 softtabstop=4  " Tab is 4 spaces
set directory=~/.vim/swapfiles//  " Put swapfiles in a better place
set backupcopy=yes  " Make auto-reloaders able to detect when Vim saves a file
set guicursor=  " Fix slim cursor on insert mode

" Load a virtualenv version of Python for plugins
let g:python_host_prog = expand("~") . "/.vim/python3-venv/bin/python"
let g:python3_host_prog = expand("~") . "/.vim/python3-venv/bin/python"

" Show whitespace at EOL
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter,InsertLeave * match ExtraWhitespace /\s\+$/


" coc.nvim autocomplete
set shortmess+=c  " Don't pass messages to |ins-completion-menu|.
set signcolumn=yes   " Always make space for symbols in gutter
set updatetime=300  " Trigger CursorHold faster when idling
let g:coc_global_extensions= [
\   'coc-java',
\   'coc-json',
\   'coc-omnisharp',
\   'coc-python',
\   'coc-rust-analyzer'
\]


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


" Keybindings
let mapleader = " "

" Multi cursor editing (Sublime style)
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_next_key = "<C-d>"
let g:multi_cursor_prev_key = "<C-S-d>"
let g:multi_cursor_skip_key = "<C-A-d>"
let g:multi_cursor_quit_key = "<esc>"

" Alt+Left/Right/Up/Down navigation for windows
nnoremap <silent> <A-Left> :wincmd h<CR>
nnoremap <silent> <A-Right> :wincmd l<CR>
nnoremap <silent> <A-Up> :wincmd k<CR>
nnoremap <silent> <A-Down> :wincmd j<CR>

" Tree style undo
nnoremap <silent> <C-z> :UndotreeToggle<CR>

" Clear search highlighting
nmap <silent> <C-c> :let@/=""<CR>

" Make search center selection vertically
nnoremap <silent> N Nzz
nnoremap <silent> n nzz

" Make Home key respect indenting
function! ExtendedHome()
    let column = col(".")
    normal! ^
    if column == col(".")
        normal! 0
    endif
endfunction
noremap <silent> <Home> :call ExtendedHome()<CR>
inoremap <silent> <Home> <C-O>:call ExtendedHome()<CR>

" Map FZF things to key bindings
nnoremap <silent> <leader>s :FZFBuffers<CR>
nnoremap <silent> <leader>d :FZFDefinitions<CR>
nnoremap <silent> <leader>f :FZFFiles<CR>
nnoremap <silent> <leader>g :FZFGitFiles<CR>


" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Goto code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Refactoring
nmap <leader>rf <Plug>(coc-refactor)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ac  <Plug>(coc-codeaction)

" Show documentation
nmap <silent> <leader><space> :call CocAction('doHover')<CR>

" Easy motion
let g:EasyMotion_do_mapping = 0
highlight! link EasyMotionTarget String
map s <Plug>(easymotion-bd-f)
nmap s <Plug>(easymotion-overwin-f)

-- Setup plugins (remember trailing semi-colon)
-- (Use :PaqInstall or :PaqUpdate)
require "paq" {
    -- Let Paq manage itself
    "savq/paq-nvim";

    -- Syntax highlighting
    {"nvim-treesitter/nvim-treesitter"};

    -- LSP support
    "neovim/nvim-lspconfig";

    -- Extensions for LSP (like variable types in Rust)
    "nvim-lua/lsp_extensions.nvim";

    -- Auto complete (with LSP support)
    "hrsh7th/cmp-nvim-lsp";
    "hrsh7th/cmp-buffer";
    "hrsh7th/cmp-path";
    "hrsh7th/cmp-cmdline";
    "hrsh7th/nvim-cmp";

    "L3MON4D3/LuaSnip";
    "saadparwaiz1/cmp_luasnip";

    -- Easy motion like
    "phaazon/hop.nvim";

    -- Gruvbox color scheme with treesitter support
    "rktjmp/lush.nvim";
    "npxbr/gruvbox.nvim";

    -- Airline
    "hoob3rt/lualine.nvim";

    -- Allow closing a buffer without messing up the window layout
    "famiu/bufdelete.nvim";

    -- Fuzzy finder
    "nvim-lua/popup.nvim";
    "nvim-lua/plenary.nvim";
    "nvim-telescope/telescope.nvim";

    -- Multiple cursors support
    "mg979/vim-visual-multi";

    "editorconfig/editorconfig-vim";
}

vim.o.mouse = "a"

-- Color theme support
vim.o.termguicolors = true

-- Display line numbers and gutter
vim.o.signcolumn = "yes"
vim.o.number = true

-- Get rid of the modern slim cursor for insert mode
vim.o.guicursor = ""

-- Make backspace work like a normal editor
vim.o.backspace = "indent,eol,start"

-- Allow opening another buffer while there are unsaved changes
vim.o.hidden = true

-- Make saving work with change detection
vim.o.backupcopy = "yes"

-- Use soft tabs
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- Live preview of regex substitution
vim.o.inccommand = "nosplit"

-- Enable treesitter for all major languages
local ts = require "nvim-treesitter.configs"
ts.setup {ensure_installed = "maintained", highlight = {enable = true}}

vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- Airline
require "lualine".setup {
    options = {theme = "gruvbox"};
}
vim.opt.showmode = false

-- Make language dependent colorcolumn
vim.o.colorcolumn = "80,120"
vim.cmd([[autocmd FileType javascript set colorcolumn=100]])
vim.cmd([[autocmd FileType python set colorcolumn=80,88]])
vim.cmd([[autocmd FileType rust set colorcolumn=100]])

-- Disable most of multiple cursors since we're only interested in sublime style ctrl+d
vim.g.VM_default_mappings = 0
vim.g.VM_maps = {
    ["Find Under"] = "<C-d>",
    ["Find Subword Under"] = "<C-d>",
}

-- Setup Telescope (fuzzy finder)
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = require("telescope.actions").close,
            },
        },
    },
})

-- Configure hop (EasyMotion like)
require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })

-- Configure autocomplete
vim.o.completeopt="menu,menuone,noselect"
local cmp = require "cmp"
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'buffer' },
    }),
})

-- Autocomplete for search
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Configure language servers
local capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

local nvim_lsp = require "lspconfig"

-- Rust analyzer configuration
nvim_lsp.rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

-- Keyboard mappings below here
vim.g.mapleader = " "

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Alt+Left/Right/Up/Down navigation for windows
map("n", "<A-Left>", ":wincmd h<CR>")
map("n", "<A-Right>", ":wincmd l<CR>")
map("n", "<A-Up>", ":wincmd k<CR>")
map("n", "<A-Down>", ":wincmd j<CR>")

-- Clear search highlighting
map("n", "<C-c>", ":let@/=''<CR>")

-- Make search center selection vertically
map("n", "N", "Nzz")
map("n", "n", "nzz")

-- Close current buffer
map("n", "<leader>q", ":Bwipeout<CR>")

-- Telescope bindings
map("n", "<leader>s", "<cmd>lua require 'telescope.builtin'.buffers()<CR>")
map("n", "<leader>d", "<cmd>lua require 'telescope.builtin'.live_grep()<CR>")
map("n", "<leader>f", "<cmd>lua require 'telescope.builtin'.find_files()<CR>")
map("n", "<leader>g", "<cmd>lua require 'telescope.builtin'.git_files()<CR>")

-- Language server bindings
map("n", "gd", "<cmd>lua require 'telescope.builtin'.lsp_definitions()<CR>")
map("n", "gi", "<cmd>lua require 'telescope.builtin'.lsp_implementations()<CR>")
map("n", "gr", "<cmd>lua require 'telescope.builtin'.lsp_references()<CR>")
map("n", "<leader><space>", "<cmd>lua vim.lsp.buf.hover()<CR>")

-- Hop/EasyMotion
map("n", "s", "<cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.AFTER_CURSOR })<cr>")
map("n", "S", "<cmd>lua require('hop').hint_char1({ direction = require('hop.hint').HintDirection.BEFORE_CURSOR })<cr>")
map("n", "gw", "<cmd>lua require('hop').hint_words()<cr>")

-- Language server refactoring
map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<leader>ac", "<cmd>lua vim.lsp.buf.code_action()<CR>")

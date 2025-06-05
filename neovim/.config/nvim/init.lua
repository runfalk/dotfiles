-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.o.mouse = "a"

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

-- Make language dependent colorcolumn
vim.o.colorcolumn = "80,120"
vim.cmd([[autocmd FileType javascript set colorcolumn=100]])
vim.cmd([[autocmd FileType python set colorcolumn=88]])
vim.cmd([[autocmd FileType rust set colorcolumn=100]])

-- Simplify keymaps
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend("force", options, opts) end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Keyboard mappings below here
vim.g.mapleader = " "

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


-- Language server bindings
map("n", "<leader><space>", vim.lsp.buf.hover)
map("n", "<leader>r", vim.lsp.buf.format)
map("v", "<leader>r", vim.lsp.buf.format)

-- Language server refactoring
map("n", "<leader>rn", vim.lsp.buf.rename)
map("n", "<leader>ac", vim.lsp.buf.code_action)

-- Enable inline diagnostics
vim.diagnostic.config({
   virtual_text = {
        -- Skip HINT level
        severity = { min = vim.diagnostic.severity.INFO },
   },
   signs = {
        -- Skip HINT level
        severity = { min = vim.diagnostic.severity.INFO },
   },
})

local plugins = {
    {
        -- Color theme, must not be lazy loaded and should be loaded first
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = true,
        init = function()
            vim.o.background = "dark" -- or "light" for light mode
            vim.cmd([[colorscheme gruvbox]])
        end,
    },
    {
        -- Language server support
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local nvim_lsp = require("lspconfig")

            -- Rust analyzer configuration
            if vim.fn.executable("rust-analyzer") == 1 then
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
            end

            -- Pyright python language server support
            if vim.fn.executable("pyright") == 1 then
                nvim_lsp.pyright.setup({
                    capabilities = capabilities,
                })
            end

            -- Pyright python language server support
            if vim.fn.executable("ruff") == 1 then
                nvim_lsp.ruff.setup({
                    capabilities = capabilities,
                })
            end
        end
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    {
        -- Auto-complete
        "hrsh7th/nvim-cmp",
        lazy = false,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            vim.o.completeopt="menu,menuone,noselect"
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ['<Down>'] = cmp.mapping(
                        cmp.mapping.select_next_item({
                            behavior = cmp.SelectBehavior.Select,
                        }),
                        {'i'}
                    ),
                    ['<Up>'] = cmp.mapping(
                        cmp.mapping.select_prev_item({
                            behavior = cmp.SelectBehavior.Select,
                        }),
                        {'i'}
                    ),

                    -- Don't override arrow keys in command mode since they are
                    -- far more useful with their defaults
                    ['<C-Down>'] = cmp.mapping(
                        cmp.mapping.select_next_item({
                            behavior = cmp.SelectBehavior.Select,
                        }),
                        {'c'}
                    ),
                    ['<C-Up>'] = cmp.mapping(
                        cmp.mapping.select_prev_item({
                            behavior = cmp.SelectBehavior.Select,
                        }),
                        {'c'}
                    ),

                    -- Use escape to cancel the auto complete without exiting
                    -- the current mode if a value was selected
                    ['<Esc>'] = cmp.mapping({
                        i = function(fallback)
                            if cmp.visible() and cmp.get_selected_entry() then
                                cmp.close()
                            else
                                fallback()
                            end
                        end,
                        i = function(fallback)
                            if cmp.visible() and cmp.get_selected_entry() then
                                cmp.close()
                            else
                                local codes = vim.api.nvim_replace_termcodes(
                                    "<C-c>", true, true, true
                                )
                                vim.api.nvim_feedkeys(codes, 'n', true)
                            end
                        end,
                    }),

                    -- Autocomplete on enter if a value was selected
                    ['<CR>'] = cmp.mapping(
                        function(fallback)
                            if cmp.visible() and cmp.get_selected_entry() then
                                cmp.confirm({
                                    behavior = cmp.ConfirmBehavior.Replace,
                                    select = false,
                                })
                            else
                                fallback()
                            end
                        end,
                        {"i", "c"}
                    ),
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

            -- Autocomplete for commands
            cmp.setup.cmdline(':', {
                sources = {
                    { name = 'cmdline' },
                },
            })
        end,
    },
    {
        -- Fuzzy finder
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = require("telescope.actions").close,
                        },
                    },
                },
            })

            -- Telescope bindings
            local telescope_cmds = require("telescope.builtin")
            map("n", "<leader>s", telescope_cmds.buffers)
            map("n", "<leader>d", telescope_cmds.live_grep)
            map("n", "<leader>f", telescope_cmds.find_files)
            map("n", "<leader>g", function()
                telescope_cmds.git_files({ show_untracked = false })
            end)
            map("n", "<leader>l", telescope_cmds.grep_string)
            map("n", "<leader>p", telescope_cmds.treesitter)

            map("n", "gd", telescope_cmds.lsp_definitions)
            map("n", "gi", telescope_cmds.lsp_implementations)
            map("n", "gr", telescope_cmds.lsp_references)
        end,
    },
    {
        -- Syntax highlighting support for most languages
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "asm",
                    "bash",
                    "c",
                    "comment",
                    "cpp",
                    "css",
                    "csv",
                    "dart",
                    "diff",
                    "dockerfile",
                    "editorconfig",
                    "git_config",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "glsl",
                    "go",
                    "hlsl",
                    "html",
                    "java",
                    "javascript",
                    "jsdoc",
                    "json",
                    "json5",
                    "lua",
                    "markdown",
                    "meson",
                    "ninja",
                    "perl",
                    "php",
                    "python",
                    "query",
                    "regex",
                    "rst",
                    "rust",
                    "scss",
                    "sql",
                    "ssh_config",
                    "toml",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "wgsl",
                    "wgsl_bevy",
                    "xml",
                    "yaml",
                    "zig",
                },
                sync_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },
    {
        -- Easy motion like
        "smoka7/hop.nvim",
        lazy = false,
        opts = {
            keys = "etovxqpdygfblzhckisuran",
        },
        config = function(opts)
            local hop = require("hop")
            hop.setup(opts)
            local dir = require("hop.hint").HintDirection
            map("n", "s", function() hop.hint_char1({ direction = dir.AFTER_CURSOR }) end)
            map("n", "S", function() hop.hint_char1({ direction = dir.BEFORE_CURSOR }) end)
            map("n", "gw", function() hop.hint_words() end)
        end,
    },
    {
        -- Git blame support
        "FabijanZulj/blame.nvim",
        lazy = false,
        opts = {
            date_format = "%Y-%m-%d",
            format_fn = function(line_porcelain, config, idx)
                local hash = string.sub(line_porcelain.hash, 0, 7)
                local is_commited = hash ~= "0000000"
                if is_commited then
                    local formatted_date = os.date(
                        config.date_format,
                        line_porcelain.committer_time
                    )
                    return {
                        idx = idx,
                        values = {
                            { textValue = line_porcelain.author, hl = "Comment" },
                            { textValue = formatted_date, hl = hash },
                            { textValue = hash, hl = hash },
                        },
                        format = "%s %s %s",
                    }
                else
                    return {
                        idx = idx,
                        values = {
                            { textValue = "Not committed", hl = "Comment" },
                        },
                        format = "%s",
                    }
                end
            end,
        },
        config = function(opts)
            require("blame").setup(opts)
            map("n", "gb", "<cmd>BlameToggle virtual<cr>")
        end,
    },
    {
        -- Change status line look and feel
        "hoob3rt/lualine.nvim",
        lazy = false,
        init = function()
            vim.opt.showmode = false
        end,
        config = true,
    },
    {
        -- Allow closing a buffer without messing up the window layout
        "famiu/bufdelete.nvim",
        lazy = false,
        config = function()
            map("n", "<leader>q", require("bufdelete").bufdelete)
        end,
    },
}

-- Setup lazy.nvim
require("lazy").setup({
  spec = plugins,
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "gruvbox" } },
})

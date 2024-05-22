local h = require("vim-helpers")
local set = h.set

local function colorscheme_config()
    -- General theme
    vim.cmd.colorscheme("desert")
    vim.cmd.highlight("Normal", "ctermfg=188 ctermbg=None")
end

local function airline_init()
end

local function nerdtree_config()
    set({ "n", "v" }, "<Leader>dt", ":NERDTreeFocus<CR>")
    set({ "n", "v" }, "<Leader>dT", ":NERDTreeClose<CR>")
    set({ "n", "v" }, "<Leader>t", ":NERDTreeToggle<CR>")
    set({ "n", "v" }, "<Leader>T", ":NERDTreeFind<CR>")
end

local function toggle_inlay_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

local function lsp_config()
    local lspconfig = require("lspconfig")

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Buffer local mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local opts = { buffer = ev.buf }
            vim.keymap.set('n', '<Leader>ch', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', '<Leader>cs', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<Leader>di', toggle_inlay_hints, opts)
            vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', '<Leader>rr', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<Leader>rf', function()
                vim.lsp.buf.format { async = true }
            end, opts)

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', 'gs', builtin.lsp_document_symbols)
            vim.keymap.set('n', 'gS', builtin.lsp_workspace_symbols)
            vim.keymap.set('n', 'gr', builtin.lsp_references)
            vim.keymap.set('n', 'gc', builtin.lsp_incoming_calls)
            vim.keymap.set('n', 'gC', builtin.lsp_outgoing_calls)
            vim.keymap.set('n', 'gi', builtin.lsp_implementations)
            vim.keymap.set('n', 'gd', builtin.lsp_definitions)
            vim.keymap.set('n', 'gD', builtin.lsp_type_definitions)
        end
    })
end

local function rust_config()
end

local function telescope_config()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
end

local function mason_config()
    require("mason").setup()
end

local function mason_lsp_config()
    local lspconfig = require("mason-lspconfig");

    lspconfig.setup {
        ensure_installed = { "lua_ls", "rust_analyzer", "pyright" },
    }

    lspconfig.setup_handlers {
        function(server_name)
            require("lspconfig")[server_name].setup {}
        end,

        ["rust_analyzer"] = function()
            rust_config()
        end
    }
end

require("lazy-bootstrap").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = { "bash", "c", "cpp", "dockerfile", "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore", "hcl", "json", "lua", "markdown", "markdown_inline", "python", "rust", "sql", "vim", "vimdoc" },
                highlight = { enable = true, }
            }
        end
    },
    {
        "vim-airline/vim-airline",
        init = airline_init,
        dependencies = {
            "vim-airline/vim-airline-themes",
        }
    },
    {
        "jnurmine/Zenburn",
        config = colorscheme_config,
    },
    {
        "preservim/nerdtree",
        config = nerdtree_config,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = mason_config,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = mason_lsp_config,
        lazy = false,
        dependencies = { "williamboman/mason.nvim" },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = lsp_config,
        opts = {
            inlay_hints = { enabled = true },
        },
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^4',
        lazy = false,
        init = rust_config,
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = telescope_config,
    },

})

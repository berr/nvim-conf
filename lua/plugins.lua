local b = require("bindings")
local h = require("vim-helpers")
local set = h.set

local function colorscheme_config()
    -- General theme
    vim.cmd.colorscheme("desert")
    vim.cmd.highlight("Normal", "ctermfg=188 ctermbg=None")
end

local function airline_init()
end

local function lua_line_config()
    local l = require('lualine');
    l.setup({
        options = { theme = 'auto' },
    });
end

local function neo_tree_config()
    local neo_tree = require('neo-tree.command');
    local global_position = 'left';

    vim.keymap.set('n', b.tree_toggle, function()
        neo_tree.execute(
            { action = 'show', position = global_position, toggle = true })
    end);
    vim.keymap.set('n', b.tree_focus, function()
        neo_tree.execute(
            { action = 'focus', position = global_position, toggle = false })
    end);
    vim.keymap.set('n', b.tree_close, function()
        neo_tree.execute(
            { action = 'close', position = global_position, toggle = false })
    end);
end

local function toggle_inlay_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

local function lsp_config()
    local lspconfig = require("lspconfig")

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', b.code_diagnostic_open_float, vim.diagnostic.open_float)
    vim.keymap.set('n', b.code_diagnostic_previous, vim.diagnostic.goto_prev)
    vim.keymap.set('n', b.code_diagnostic_next, vim.diagnostic.goto_next)
    vim.keymap.set('n', b.code_diagnostic_set_loclist, vim.diagnostic.setloclist)

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
            vim.keymap.set('n', b.code_hover, vim.lsp.buf.hover, opts)
            vim.keymap.set('n', b.code_signature_help, vim.lsp.buf.signature_help, opts)
            vim.keymap.set({'n','v'}, b.code_action, vim.lsp.buf.code_action, opts)

            vim.keymap.set('n', b.code_rename_symbol, vim.lsp.buf.rename, opts)
            vim.keymap.set('n', b.code_format_file, function()
                vim.lsp.buf.format { async = true }
            end, opts)

            vim.keymap.set('n', b.code_display_hints, toggle_inlay_hints, opts)

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', b.code_list_symbols, builtin.lsp_document_symbols)
            vim.keymap.set('n', b.code_list_workspace_symbols, builtin.lsp_workspace_symbols)
            vim.keymap.set('n', b.code_list_references, builtin.lsp_references)
            vim.keymap.set('n', b.code_list_incoming_calls, builtin.lsp_incoming_calls)
            vim.keymap.set('n', b.code_list_outgoing_calls, builtin.lsp_outgoing_calls)
            vim.keymap.set('n', b.code_list_implementations, builtin.lsp_implementations)
            vim.keymap.set('n', b.code_list_definitions, builtin.lsp_definitions)
            vim.keymap.set('n', b.code_list_type_definitions, builtin.lsp_type_definitions)
        end
    })
end

local function rust_config()
end

local function telescope_config()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', b.file_find, builtin.find_files, {})
    vim.keymap.set('n', b.file_find_grep, builtin.live_grep, {})
    vim.keymap.set('n', b.list_buffers, builtin.buffers, {})
    vim.keymap.set('n', b.list_help_tags, builtin.help_tags, {})
    vim.keymap.set('n', b.list_marks, builtin.marks, {})
    vim.keymap.set('n', b.list_jumplist, builtin.jumplist, {})
    vim.keymap.set('n', b.list_registers, builtin.registers, {})
    vim.keymap.set('n', b.list_highlights, builtin.highlights, {})
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

local function dap_config()
    local dap = require('dap')
    dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
        name = 'lldb'
    }

    dap.configurations.rust = {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    }
end

local function cmp_config()
    local cmp = require('cmp')

    cmp.setup({
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        window = {
            -- completion = cmp.config.window.bordered(),
            -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources(
            {
                { name = 'nvim_lsp' },
                { name = 'vsnip' },
            },
            {
                { name = 'buffer' },
            })
    })

    -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
    -- Set configuration for specific filetype.
    --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]
    --

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
    })

    -- Set up lspconfig.
    -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    -- require('lspconfig')['rust'].setup {
    --    capabilities = capabilities
    -- }
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
        "jnurmine/Zenburn",
        config = colorscheme_config,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        config = neo_tree_config
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
        "mfussenegger/nvim-dap",
        lazy = true,
        config = dap_config,
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

    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    {
        'hrsh7th/nvim-cmp',
        config = cmp_config,
        dependencies = { "neovim/nvim-lspconfig" },
    },
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
    'tpope/vim-fugitive',
    'tpope/vim-surround',
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = lua_line_config,
    },
    'tpope/vim-commentary',
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
})

local b = require("bindings")
local h = require("vim-helpers")
local set = h.set

local function colorscheme_config()
    vim.cmd.colorscheme("kanagawa-dragon")
end


local function lua_line_config()
    local l = require('lualine');
    l.setup({
        options = { theme = 'auto' },
    });
end

local function hydra_config()
    local Hydra = require("hydra")
    local h1 = Hydra({
        name = "Window Management (Immediate)",
        mode = "n",
        body = "<leader>w",
        config = {
            exit=true,
        },
        heads = { 
            -- Window resizing
            { "h", "<C-w>h", { desc = "Move window left", exit = true } },
            { "j", "<C-w>j", { desc = "Move window down", exit = true } },
            { "k", "<C-w>k", { desc = "Move window up", exit = true } },
            { "l", "<C-w>l", { desc = "Move window right", exit = true } },
            { "K", "<C-w>+", { desc = "Increase window height", exit = true } },
            { "J", "<C-w>-", { desc = "Decrease window height", exit = true } },
            { "H", "<C-w><", { desc = "Increase window width", exit = true } },
            { "L", "<C-w>>", { desc = "Decrease window width", exit = true } }, 
            { "=", "<C-w>=", { desc = "Equalize window sizes", exit = true } },

            -- Window splitting and closing
            { "s", "<C-w>s", { desc = "Split window horizontally", exit = true } },
            { "v", "<C-w>v", { desc = "Split window vertically", exit = true } },
            { "c", "<C-w>c", { desc = "Close current window", exit = true } },
            { "o", "<C-w>o", { desc = "Close other windows", exit = true } },

            -- Exiting Hydra
            -- { "q", nil, { exit = true, desc = "Quit Hydra" } },
        }
    })




    local h2 = Hydra({
        name = "Window Management (Mode)",
        mode = "n",
        body = "<leader>W",
        config = {
            hint = {
                type = "window",
                position = 'middle',
            }
        },
        heads = { 
            -- Window resizing
            { "h", "<C-w>h", { desc = "Move window left" } },
            -- { "j", "<C-w>j", { desc = "Move window down" } },
            -- { "k", "<C-w>k", { desc = "Move window up" } },
            -- { "l", "<C-w>l", { desc = "Move window right" } },
            -- { "K", "<C-w>+", { desc = "Increase window height" } },
            -- { "J", "<C-w>-", { desc = "Decrease window height" } },
            -- { "H", "<C-w><", { desc = "Increase window width" } },
            -- { "L", "<C-w>>", { desc = "Decrease window width" } }, 
            -- { "=", "<C-w>=", { desc = "Equalize window sizes" } },

            -- Window splitting and closing
            -- { "s", "<C-w>s", { desc = "Split window horizontally", exit = true } },
            -- { "v", "<C-w>v", { desc = "Split window vertically", exit = true } },
            -- { "c", "<C-w>c", { desc = "Close current window", exit = true } },
            -- { "o", "<C-w>o", { desc = "Close other windows", exit = true } },

            -- Exiting Hydra
            -- { "q", nil, { exit = true, desc = "Quit Hydra" } },
        }
    })

    -- table.insert(h2.hint, { "q", nil, { exit = true, desc = "Quit Hydra" } })

    local t = require('telescope.builtin')
    Hydra({
        name = "Telescope",
        mode = "n",
        body = "<leader>f",
        config = {
            invoke_on_body = true,
        },
        heads = {
            { "f", t.find_files, { desc = "Find file" } },
            { "g", t.live_grep, { desc = "Find in file" } },
            { "b", t.buffers, { desc = "Find buffer" } },
            { "m", t.marks, { desc = "Find mark" } },
            { "j", t.jumplist, { desc = "Find jump" } },
            { "r", t.registers, { desc = "Find register" } },
            { "h", t.highlights, { desc = "Find highlight" } },
            { "t", t.help_tags, { desc = "Find help tag" } },
    }})

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

-- local function toggle_inlay_hints()
--     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
-- end

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
            vim.keymap.set({ 'n', 'v' }, b.code_action, vim.lsp.buf.code_action, opts)

            vim.keymap.set('n', b.code_rename_symbol, vim.lsp.buf.rename, opts)
            vim.keymap.set('n', b.code_format_file, function()
                vim.lsp.buf.format { async = true }
            end, opts)

            -- vim.keymap.set('n', b.code_display_hints, toggle_inlay_hints, opts)

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

-- local function neotest_config()
--     require("neotest").setup({
--         adapters = {
--             require("neotest-python")({
--                 dap = { justMyCode = false },
--             }),
--             require("rustaceanvim.neotest"),
--         },
--     })
-- end

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
            return true;
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
end

require("lazy-bootstrap").setup({
    {
        "rebelot/kanagawa.nvim",
        config = colorscheme_config,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = lua_line_config,
    },
    {
        "nvimtools/hydra.nvim",
        config = hydra_config, 
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons"
        },
        lazy = false,
        config = neo_tree_config
    },
    {
        "mason-org/mason.nvim",
        opts = {},
        dependencies = { },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
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
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "bash", "c", "cpp", "dockerfile", "git_config", "git_rebase",
                    "gitattributes", "gitcommit", "gitignore", "hcl", "json", "lua",
                    "markdown", "markdown_inline", "python", "rust", "sql",
                    "vim", "vimdoc" },
                highlight = { enable = true, }
            }
        end
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^4',
        lazy = false,
        init = rust_config,
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = telescope_config,
    },
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

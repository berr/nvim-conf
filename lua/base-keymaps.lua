local h = require("vim-helpers")
local set = h.set
local autocmd = vim.api.nvim_create_autocmd

vim.g.mapleader = ","

-- Quit vim when no changes were made
set("n", "q", ":q<CR>")
set("n", "Q", ":bd<CR>")

-- Call autocomplete
set("i", "<C-Space>", "<C-x><C-o>", { noremap = true })
autocmd("CompleteDone", {pattern = "*", command = "pclose"})

set("n", "gh", "gg")
set("n", "ge", "G")

set("n", "<Leader>fo", ":e", { silent = false });
set("n", "<Leader>fO", ":e %:p:h/", { silent = false });

set("n", "<Leader>w", "<C-w>")

set("n", "<Leader>fs", ":w<CR>", { silent = false })
set("n", "<Leader>fr", ":edit!<CR>", { silent = false })

set({"n", "v"}, "<Leader>dh", ":nohl<CR>")
set({"n", "v"}, "<Leader>dw", h.toggle_whitespace)
set({"n", "v"}, "<Leader>dl", h.toggle_line_numbers)
set({"n", "v"}, "<Leader>dL", h.toggle_relative_line_numbers)


vim.keymap.set('n', 'gO', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
vim.keymap.set('n', 'go', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")


local h = require("vim-helpers")
local set = h.set

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.guicursor = ""

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Copy on mouse selection
set("v", "<LeftRelease>", '"*ygv')

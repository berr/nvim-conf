local h = require("vim-helpers")
local b = require("bindings")

vim.g.mapleader = b.leader

h.set_i(b.auto_complete, "<C-x><C-o>", { noremap = true })

h.set_n(b.go_first_line, "gg")
h.set_n(b.go_last_line, "G")
h.set_n(b.go_beginning_line, "0")
h.set_n(b.go_non_white_beginning_line, "^")
h.set_n(b.go_non_white_end_line, "g_")
h.set_n(b.go_end_line, "$")
h.set_n(b.go_back, "<C-o>")
h.set_n(b.go_next, "<C-i>")

h.set_n(b.file_open_cmd, ":e", { silent = false });

h.set_n(b.window_commands, "<C-w>")

h.set_n(b.file_save, ":w<CR>", { silent = false })
h.set_n(b.file_reload, ":edit!<CR>", { silent = false })
h.set_n(b.file_ending_windows, ":w +ff=dos<CR>", { silent = false })
h.set_n(b.file_ending_linux, ":w +ff=unix<CR>", { silent = false })
h.set_n(b.file_ending_mac, ":w +ff=mac<CR>", { silent = false })

h.set_n(b.duplicate_line_above, "yyP", {})
h.set_n(b.duplicate_line_below, "yyp", {})
h.set_n(b.move_line_up, "ddkP", {})
h.set_n(b.move_line_down, "ddjP", {})

h.set_nv(b.disable_highlights, ":nohl<CR>")
h.set_nv(b.toggle_whitespace, h.toggle_whitespace)
h.set_nv(b.toggle_line_numbers, h.toggle_line_numbers)
h.set_nv(b.toggle_relative_line_numbers, h.toggle_relative_line_numbers)

h.set_n(b.macro_toggle, "q")
h.set_n(b.macro_apply, "@")

h.set_n(b.mark_set, "m")
h.set_n(b.mark_jump, "'")
h.set_n(b.register, "\"")


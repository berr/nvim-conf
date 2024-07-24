local bindings                        = {}

bindings.leader                       = ','

bindings.file_find                    = '<leader>ff'
bindings.file_find_grep               = '<leader>fg'
bindings.file_reload                  = '<leader>fr'
bindings.file_open_cmd                = '<leader>fo'
bindings.file_save                    = '<leader>fs'
bindings.file_ending_linux            = '<leader>fll'
bindings.file_ending_windows          = '<leader>flw'
bindings.file_ending_mac              = '<leader>flm'

bindings.macro_toggle                 = 'm'
bindings.macro_apply                  = 'M'

bindings.mark_set                     = 'q'
bindings.mark_jump                    = 'gq'
bindings.register                     = '<C-r>'

bindings.go_first_line                = 'g!'
bindings.go_last_line                 = 'g)'
bindings.go_beginning_line            = 'g1'
bindings.go_non_white_beginning_line  = 'g2'
bindings.go_non_white_end_line        = 'g9'
bindings.go_end_line                  = 'g0'
bindings.go_back                      = 'gb'
bindings.go_next                      = 'gn'

bindings.duplicate_line_below         = '<C-d>'
bindings.duplicate_line_above         = '<C-D>'
bindings.move_line_up                 = '<C-k>'
bindings.move_line_down               = '<C-j>'
bindings.delete_empty_line            = 'ds'

bindings.auto_complete                = '<C-Space>'
bindings.window_commands              = '<leader>w'
bindings.buffer_close                 = '<leader>bq'

bindings.disable_highlights           = '<leader>dh'
bindings.toggle_whitespace            = '<leader>dw'
bindings.toggle_line_numbers          = '<leader>dl'
bindings.toggle_relative_line_numbers = '<leader>dL'

bindings.tree_toggle                  = '<leader>tt'
bindings.tree_focus                   = '<leader>tf'
bindings.tree_close                   = '<leader>tc'

bindings.list_buffers                 = '<leader>lb'
bindings.list_help_tags               = '<leader>l?'
bindings.list_marks                   = '<leader>lq'
bindings.list_jumplist                = '<leader>lj'
bindings.list_registers               = '<leader>lr'
bindings.list_highlights              = '<leader>lh'

bindings.code_diagnostic_open_float   = '<leader>cdf'
bindings.code_diagnostic_next         = '<leader>cdp'
bindings.code_diagnostic_previous     = '<leader>cdn'
bindings.code_diagnostic_set_loclist  = '<leader>cdl'

bindings.code_list_symbols            = 'gs'
bindings.code_list_workspace_symbols  = 'gS'
bindings.code_list_references         = 'gr'
bindings.code_list_incoming_calls     = 'gc'
bindings.code_list_outgoing_calls     = 'gC'
bindings.code_list_implementations    = 'gi'
bindings.code_list_definitions        = 'gd'
bindings.code_list_type_definitions   = 'gD'

bindings.code_hover                   = '<leader>ch'
bindings.code_signature_help          = '<leader>cs'
bindings.code_action                  = '<leader>ca'
bindings.code_rename_symbol           = '<leader>cr'
bindings.code_format_file             = '<leader>cf'
bindings.code_display_hints           = '<leader>di'

return bindings

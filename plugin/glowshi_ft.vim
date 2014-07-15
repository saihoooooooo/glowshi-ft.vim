if exists('g:loaded_glowshi_ft')
  finish
endif
let g:loaded_glowshi_ft = 1

let s:save_cpo = &cpo
set cpo&vim

let s:true  = !0
let s:false = 0

let g:glowshi_ft_ignorecase            = get(g:,'glowshi_ft_ignorecase', s:false)
let g:glowshi_ft_timeoutlen            = get(g:,'glowshi_ft_timeoutlen', 0)
let g:glowshi_ft_fix_key               = get(g:,'glowshi_ft_fix_key', "[\<NL>\<CR>]")
let g:glowshi_ft_cancel_key            = get(g:,'glowshi_ft_cancel_key', "\<ESC>")
let g:glowshi_ft_selected_hl_ctermfg   = get(g:,'glowshi_ft_selected_hl_ctermfg', 'Black')
let g:glowshi_ft_selected_hl_ctermbg   = get(g:,'glowshi_ft_selected_hl_ctermbg', 'White')
let g:glowshi_ft_selected_hl_guifg     = get(g:,'glowshi_ft_selected_hl_guifg', '#000000')
let g:glowshi_ft_selected_hl_guibg     = get(g:,'glowshi_ft_selected_hl_guibg', '#FFFFFF')
let g:glowshi_ft_candidates_hl_ctermfg = get(g:,'glowshi_ft_candidates_hl_ctermfg', 'Black')
let g:glowshi_ft_candidates_hl_ctermbg = get(g:,'glowshi_ft_candidates_hl_ctermbg', 'Red')
let g:glowshi_ft_candidates_hl_guifg   = get(g:,'glowshi_ft_candidates_hl_guifg', '#000000')
let g:glowshi_ft_candidates_hl_guibg   = get(g:,'glowshi_ft_candidates_hl_guibg', '#FF0000')

noremap  <silent><plug>(glowshi-ft-f)  :<C-u>call glowshi_ft#gs_f()<cr>
xnoremap <silent><plug>(glowshi-ft-f)  <ESC>:<C-u>call glowshi_ft#gs_fv()<cr>
noremap  <silent><plug>(glowshi-ft-F)  :<C-u>call glowshi_ft#gs_F()<cr>
xnoremap <silent><plug>(glowshi-ft-F)  <ESC>:<C-u>call glowshi_ft#gs_Fv()<cr>
noremap  <silent><plug>(glowshi-ft-t)  :<C-u>call glowshi_ft#gs_t()<cr>
xnoremap <silent><plug>(glowshi-ft-t)  <ESC>:<C-u>call glowshi_ft#gs_tv()<cr>
noremap  <silent><plug>(glowshi-ft-T)  :<C-u>call glowshi_ft#gs_T()<cr>
xnoremap <silent><plug>(glowshi-ft-T)  <ESC>:<C-u>call glowshi_ft#gs_Tv()<cr>

if !get(g:, 'glowshi_ft_no_default_key_mappings', s:false)
    map  f <plug>(glowshi-ft-f)
    map  F <plug>(glowshi-ft-F)
    map  t <plug>(glowshi-ft-t)
    map  T <plug>(glowshi-ft-T)
endif

let &cpo = s:save_cpo
unlet s:save_cpo

if exists('g:loaded_glowshift')
  finish
endif
let g:loaded_glowshift = 1

let s:save_cpo = &cpo
set cpo&vim

let s:true  = !0
let s:false = 0

let g:glowshift_ignorecase            = get(g:,'glowshift_ignorecase', s:false)
let g:glowshift_t_highlight_exactly   = get(g:,'glowshift_t_highlight_exactly', s:false)
let g:glowshift_selected_hl_ctermfg   = get(g:,'glowshift_selected_hl_ctermfg', 'Black')
let g:glowshift_selected_hl_ctermbg   = get(g:,'glowshift_selected_hl_ctermbg', 'White')
let g:glowshift_selected_hl_guifg     = get(g:,'glowshift_selected_hl_guifg', '#000000')
let g:glowshift_selected_hl_guibg     = get(g:,'glowshift_selected_hl_guibg', '#FFFFFF')
let g:glowshift_candidates_hl_ctermfg = get(g:,'glowshift_candidates_hl_ctermfg', 'Black')
let g:glowshift_candidates_hl_ctermbg = get(g:,'glowshift_candidates_hl_ctermbg', 'Red')
let g:glowshift_candidates_hl_guifg   = get(g:,'glowshift_candidates_hl_guifg', '#000000')
let g:glowshift_candidates_hl_guibg   = get(g:,'glowshift_candidates_hl_guibg', '#FF0000')

noremap  <silent> <plug>(glowshift-f)  :<C-u>call glowshift#gs_f()<cr>
xnoremap <silent> <plug>(glowshift-fv) :<C-u>call glowshift#gs_fv()<cr>
noremap  <silent> <plug>(glowshift-F)  :<C-u>call glowshift#gs_F()<cr>
xnoremap <silent> <plug>(glowshift-Fv) :<C-u>call glowshift#gs_Fv()<cr>
noremap  <silent> <plug>(glowshift-t)  :<C-u>call glowshift#gs_t()<cr>
xnoremap <silent> <plug>(glowshift-tv) :<C-u>call glowshift#gs_tv()<cr>
noremap  <silent> <plug>(glowshift-T)  :<C-u>call glowshift#gs_T()<cr>
xnoremap <silent> <plug>(glowshift-Tv) :<C-u>call glowshift#gs_Tv()<cr>

if !get(g:, 'glowshift_no_default_key_mappings', s:false)
    map  f <plug>(glowshift-f)
    xmap f <plug>(glowshift-fv)
    map  F <plug>(glowshift-F)
    xmap F <plug>(glowshift-Fv)
    map  t <plug>(glowshift-t)
    xmap t <plug>(glowshift-tv)
    map  T <plug>(glowshift-T)
    xmap T <plug>(glowshift-Tv)
endif

augroup Glowshift
    autocmd!
    execute 'autocmd ColorScheme * highlight GlowshiftSelected'
\         . ' ctermfg=' .  g:glowshift_selected_hl_ctermfg
\         . ' guifg=' . g:glowshift_selected_hl_guifg
\         . ' ctermbg=' .  g:glowshift_selected_hl_ctermbg
\         . ' guibg=' . g:glowshift_selected_hl_guibg
    execute 'autocmd ColorScheme * highlight GlowshiftCandidates'
\         . ' ctermfg=' .  g:glowshift_candidates_hl_ctermfg
\         . ' guifg=' . g:glowshift_candidates_hl_guifg
\         . ' ctermbg=' .  g:glowshift_candidates_hl_ctermbg
\         . ' guibg=' . g:glowshift_candidates_hl_guibg
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

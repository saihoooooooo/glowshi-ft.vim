if exists('g:loaded_glowshi_ft')
  finish
endif
let g:loaded_glowshi_ft = 1

let s:save_cpo = &cpo
set cpo&vim

let s:TRUE  = !0
let s:FALSE = 0

let g:glowshi_ft_ignorecase            = get(g:,'glowshi_ft_ignorecase', s:FALSE)
let g:glowshi_ft_nohlsearch            = get(g:,'glowshi_ft_nohlsearch', s:TRUE)
let g:glowshi_ft_timeoutlen            = get(g:,'glowshi_ft_timeoutlen', 0)
let g:glowshi_ft_vcount_forced_landing = get(g:,'glowshi_ft_vcount_forced_landing', s:FALSE)
let g:glowshi_ft_fix_key               = get(g:,'glowshi_ft_fix_key', "[\<NL>\<CR>]")
let g:glowshi_ft_cancel_key            = get(g:,'glowshi_ft_cancel_key', "\<ESC>")
let g:glowshi_ft_selected_hl_ctermfg   = get(g:,'glowshi_ft_selected_hl_ctermfg', 'Black')
let g:glowshi_ft_selected_hl_ctermbg   = get(g:,'glowshi_ft_selected_hl_ctermbg', 'White')
let g:glowshi_ft_selected_hl_guifg     = get(g:,'glowshi_ft_selected_hl_guifg', '#000000')
let g:glowshi_ft_selected_hl_guibg     = get(g:,'glowshi_ft_selected_hl_guibg', '#FFFFFF')
let g:glowshi_ft_selected_hl_link      = get(g:,'glowshi_ft_selected_hl_link', '')
let g:glowshi_ft_candidates_hl_ctermfg = get(g:,'glowshi_ft_candidates_hl_ctermfg', 'Black')
let g:glowshi_ft_candidates_hl_ctermbg = get(g:,'glowshi_ft_candidates_hl_ctermbg', 'Red')
let g:glowshi_ft_candidates_hl_guifg   = get(g:,'glowshi_ft_candidates_hl_guifg', '#000000')
let g:glowshi_ft_candidates_hl_guibg   = get(g:,'glowshi_ft_candidates_hl_guibg', '#FF0000')
let g:glowshi_ft_candidates_hl_link    = get(g:,'glowshi_ft_candidates_hl_link', '')

noremap  <silent><plug>(glowshi-ft-f)        :<C-u>call glowshi_ft#gs_f(0, v:count)<CR>
noremap  <silent><plug>(glowshi-ft-F)        :<C-u>call glowshi_ft#gs_F(0, v:count)<CR>
noremap  <silent><plug>(glowshi-ft-t)        :<C-u>call glowshi_ft#gs_t(0, v:count)<CR>
noremap  <silent><plug>(glowshi-ft-T)        :<C-u>call glowshi_ft#gs_T(0, v:count)<CR>
noremap  <silent><plug>(glowshi-ft-repeat)   :<C-u>call glowshi_ft#gs_repeat(0, v:count)<CR>
noremap  <silent><plug>(glowshi-ft-opposite) :<C-u>call glowshi_ft#gs_opposite(0, v:count)<CR>

xnoremap <expr><silent><plug>(glowshi-ft-f)        printf("\<ESC>:\<C-u>call glowshi_ft#gs_f(!0, %d)\<CR>", v:count)
xnoremap <expr><silent><plug>(glowshi-ft-F)        printf("\<ESC>:\<C-u>call glowshi_ft#gs_F(!0, %d)\<CR>", v:count)
xnoremap <expr><silent><plug>(glowshi-ft-t)        printf("\<ESC>:\<C-u>call glowshi_ft#gs_t(!0, %d)\<CR>", v:count)
xnoremap <expr><silent><plug>(glowshi-ft-T)        printf("\<ESC>:\<C-u>call glowshi_ft#gs_T(!0, %d)\<CR>", v:count)
xnoremap <expr><silent><plug>(glowshi-ft-repeat)   printf("\<ESC>:\<C-u>call glowshi_ft#gs_repeat(!0, %d)\<CR>", v:count)
xnoremap <expr><silent><plug>(glowshi-ft-opposite) printf("\<ESC>:\<C-u>call glowshi_ft#gs_opposite(!0, %d)\<CR>", v:count)

if !get(g:, 'glowshi_ft_no_default_key_mappings', s:FALSE)
    try
        map <unique>f <plug>(glowshi-ft-f)
        map <unique>F <plug>(glowshi-ft-F)
        map <unique>t <plug>(glowshi-ft-t)
        map <unique>T <plug>(glowshi-ft-T)
        map <unique>; <plug>(glowshi-ft-repeat)
        map <unique>, <plug>(glowshi-ft-opposite)
    catch /^Vim\%((\a\+)\)\=:E227/
        try
            unmap f
            unmap F
            unmap t
            unmap T
            unmap ;
            unmap ,
        catch
        endtry
        echoerr matchstr(v:exception, 'E\d\+.*')
    endtry
endif

if !hlexists('GlowshiFtSelected')
    highlight GlowshiFtSelected NONE
endif

if !hlexists('GlowshiFtCandidates')
    highlight GlowshiFtCandidates NONE
endif

let &cpo = s:save_cpo
unlet s:save_cpo

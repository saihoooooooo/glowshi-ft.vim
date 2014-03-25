scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:true       = !0
let s:false      = 0
let s:directions = {
\     'right': 1,
\     'left' : 2,
\ }

function! glowshi_ft#gs_f()
    call glowshi_ft#gs(s:false, s:directions.right, s:false)
endfunction

function! glowshi_ft#gs_fv()
    call glowshi_ft#gs(s:false, s:directions.right, s:true)
endfunction

function! glowshi_ft#gs_F()
    call glowshi_ft#gs(s:false, s:directions.left, s:false)
endfunction

function! glowshi_ft#gs_Fv()
    call glowshi_ft#gs(s:false, s:directions.left, s:true)
endfunction

function! glowshi_ft#gs_t()
    call glowshi_ft#gs(s:true, s:directions.right, s:false)
endfunction

function! glowshi_ft#gs_tv()
    call glowshi_ft#gs(s:true, s:directions.right, s:true)
endfunction

function! glowshi_ft#gs_T()
    call glowshi_ft#gs(s:true, s:directions.left, s:false)
endfunction

function! glowshi_ft#gs_Tv()
    call glowshi_ft#gs(s:true, s:directions.left, s:true)
endfunction

function! glowshi_ft#gs(till_before, direction, visualmode)
    call glowshi_ft#init()

    let s:till_before = a:till_before
    let s:direction   = a:direction
    let s:visualmode  = a:visualmode
    let s:mode        = mode(1)
    let current_pos   = getpos('.')

    echo 'char: '
    let c = nr2char(getchar())
    echon c

    if len(c)
        let poslist    = []
        let search_flg = (s:direction == s:directions.left) ? 'b' : ''
        while search("\\V" . c, search_flg, line('.'))
            call add(poslist, getpos('.'))
        endwhile

        if poslist != []
            call setpos('.', current_pos)

            let selected = 0
            if len(poslist) > 1
                let selected = glowshi_ft#choose_pos(poslist)
            endif

            if selected != -1
                call glowshi_ft#move(poslist, selected)
            endif
        endif
    endif

    if getpos('.') == current_pos && s:visualmode == s:true
        normal! gv
    endif

    call glowshi_ft#clean()
endfunction

function glowshi_ft#init()
    let s:till_before     = ''
    let s:direction       = ''
    let s:visualmode      = ''
    let s:mode            = ''
    let s:feedkey         = ''
    let s:orig_ignorecase = &ignorecase
    let &ignorecase       = g:glowshi_ft_ignorecase
endfunction

function glowshi_ft#clean()
    let &ignorecase = s:orig_ignorecase
    if s:feedkey != ''
        call feedkeys(s:feedkey)
    endif
endfunction

function! glowshi_ft#choose_pos(poslist)
    let selected = 0
    if s:direction == s:directions.left
        call reverse(a:poslist)
        let selected = len(a:poslist) - 1
    endif

    let vcount = 1

    while s:true
        let regexp_selected   = ''
        let regexp_candidates = []

        for pos in a:poslist
            let row = pos[1]
            let col = pos[2]

            if s:till_before == s:true && g:glowshi_ft_t_highlight_actually == s:true
                if s:direction == s:directions.left
                    let col += 1
                elseif s:direction == s:directions.right
                    let col -= 1
                endif
            endif

            if pos == a:poslist[selected]
                let regexp_selected = printf('\%%%dl\%%%dc', row, col)
            else
                call add(regexp_candidates, printf('\%%%dl\%%%dc', row, col))
            endif
        endfor

        let match_selected = matchadd('GlowshiFtSelected', regexp_selected)
        let match_candidates = matchadd('GlowshiFtCandidates', join(regexp_candidates, '\|'))

        redraw
        let c = getchar()
        if type(c) == type(0)
            let c = nr2char(c)
        endif

        call matchdelete(match_selected)
        call matchdelete(match_candidates)

        if c == 'h'
            let selected = (selected - vcount + len(a:poslist)) % len(a:poslist)
            let vcount = 1
        elseif c == 'l'
            let selected = (selected + vcount) % len(a:poslist)
            let vcount = 1
        elseif c == '^'
            let selected = 0
        elseif c == '$'
            let selected = len(a:poslist) - 1
        elseif c =~ '^[0-9]$'
            if vcount < 10 && c != '0'
                let vcount = c
            elseif c == '0'
                let selected = 0
            else
                let vcount .= c
            endif
        elseif c == g:glowshi_ft_fix_key
            break
        elseif c == g:glowshi_ft_cancel_key
            return -1
        else
            let s:feedkey = c
            break
        endif
    endwhile

    return selected
endfunction

function! glowshi_ft#move(poslist, selected)
    let pos = a:poslist[a:selected]

    if s:till_before == s:true
        if s:direction == s:directions.left
            let pos[2] += 1
        elseif s:direction == s:directions.right
            let pos[2] -= 1
        endif
    endif

    if s:mode == 'no'
        if s:direction == s:directions.right
            let pos[2] += 1
        endif
    elseif s:visualmode == s:true
        normal! gv
    endif

    call setpos('.', pos)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

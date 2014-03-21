scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:true       = !0
let s:false      = 0
let s:directions = {
\     'right': 1,
\     'left' : 2,
\ }

let s:till_before = ''
let s:direction   = ''
let s:visualmode  = ''
let s:orig_ic     = ''
let s:mode        = ''

function! glowshift#gs_f()
    call glowshift#gs(s:false, s:directions.right, s:false)
endfunction

function! glowshift#gs_fv()
    call glowshift#gs(s:false, s:directions.right, s:true)
endfunction

function! glowshift#gs_F()
    call glowshift#gs(s:false, s:directions.left, s:false)
endfunction

function! glowshift#gs_Fv()
    call glowshift#gs(s:false, s:directions.left, s:true)
endfunction

function! glowshift#gs_t()
    call glowshift#gs(s:true, s:directions.right, s:false)
endfunction

function! glowshift#gs_tv()
    call glowshift#gs(s:true, s:directions.right, s:true)
endfunction

function! glowshift#gs_T()
    call glowshift#gs(s:true, s:directions.left, s:false)
endfunction

function! glowshift#gs_Tv()
    call glowshift#gs(s:true, s:directions.left, s:true)
endfunction

function! glowshift#gs(till_before, direction, visualmode)
    call glowshift#init()

    let s:till_before = a:till_before
    let s:direction = a:direction
    let s:visualmode = a:visualmode

    let s:mode = mode(1)

    echo 'char: '
    let c = nr2char(getchar())
    echon c

    if len(c)
        let current_pos = getpos('.')
        let poslist = []
        let search_flg = (s:direction == s:directions.left) ? 'b' : ''
        while search("\\V" . c, search_flg, line('.'))
            call add(poslist, getpos('.'))
        endwhile

        if poslist != []
            call setpos('.', current_pos)

            let selected = 0
            if len(poslist) > 1
                let selected = glowshift#choose_pos(poslist)
            endif

            call glowshift#move(poslist, selected)
        endif
    endif

    call glowshift#clean()
endfunction

function glowshift#init()
    let s:orig_ic = &ignorecase
    let &ignorecase = g:glowshift_ignorecase
endfunction

function glowshift#clean()
    let &ignorecase = s:orig_ic
endfunction

function! glowshift#choose_pos(poslist)
    let selected = 0
    if s:direction == s:directions.left
        call reverse(a:poslist)
        let selected = len(a:poslist) - 1
    endif

    let vcount = 1

    while s:true
        let regexp_selected = ''
        let regexp_candidates = []

        for pos in a:poslist
            let row = pos[1]
            let col = pos[2]

            if s:till_before == s:true && g:glowshift_t_highlight_exactly == s:true
                if s:direction == s:directions.right
                    let col -= 1
                elseif s:direction == s:directions.left
                    let col += 1
                endif
            endif

            if pos == a:poslist[selected]
                let regexp_selected = printf('\%%%dl\%%%dc', row, col)
            else
                call add(regexp_candidates, printf('\%%%dl\%%%dc', row, col))
            endif
        endfor

        let match_selected = matchadd('GlowshiftSelected', regexp_selected)
        let match_candidates = matchadd('GlowshiftCandidates', join(regexp_candidates, '\|'))

        redraw

        let c = nr2char(getchar())

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
        elseif c =~ '[0-9]'
            if vcount < 10 && c != '0'
                let vcount = c
            elseif c == '0'
                let selected = 0
            else
                let vcount .= c
            endif
        elseif c == "\<ESC>"
            return
        else
            break
        endif
    endwhile

    return selected
endfunction

function! glowshift#move(poslist, selected)
    let pos = a:poslist[a:selected]

    if s:till_before == s:true
        if s:direction == s:directions.right
            let pos[2] -= 1
        elseif s:direction == s:directions.left
            let pos[2] += 1
        endif
    endif

    if s:mode == 'no'
        if s:direction == s:directions.right
            let pos[2] += 1
        endif
    elseif s:visualmode == s:true
        normal! v
    endif

    call setpos('.', pos)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

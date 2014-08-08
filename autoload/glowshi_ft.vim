scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:TRUE = !0
let s:FALSE = 0
let s:DIRECTIONS = {
\     'RIGHT': 1,
\     'LEFT': 2,
\ }

function! glowshi_ft#map(till_before, direction)
    call s:init()

    echo 'char: '
    let s:c = getchar()
    if type(s:c) == type(0)
        let s:c = nr2char(s:c)
    endif
    redraw

    return s:map(a:till_before, a:direction, s:FALSE)
endfunction

function! glowshi_ft#map_repeat(opposite)
    if !exists('s:last')
        return
    endif
    call s:init()
    let direction = s:last.direction
    if a:opposite == s:TRUE
        let direction = (direction == s:DIRECTIONS.LEFT) ? s:DIRECTIONS.RIGHT : s:DIRECTIONS.LEFT
    endif
    return s:map(s:last.till_before, direction, s:TRUE)
endfunction

function! s:map(till_before, direction, repeat)
    return printf(":\<C-u>call glowshi_ft#main(%d, %d, %d)\<CR>", a:till_before, a:direction, a:repeat)
endfunction

function! s:init()
    let s:mode = mode(1)
    if s:mode == 'v'
        let s:v_cursor_pos = getpos('.')
    endif
endfunction

function! glowshi_ft#main(till_before, direction, repeat)
    let vcount = v:count
    let s:orig_ignorecase = &ignorecase
    let &ignorecase = g:glowshi_ft_ignorecase
    let s:orig_smartcase = &smartcase
    let &smartcase = g:glowshi_ft_smartcase
    if a:repeat == s:FALSE
        let s:last = {
        \     'till_before': a:till_before,
        \     'direction': a:direction,
        \ }
    endif

    try
        " Return the position of the cursor in visualmode.
        if s:mode == 'v'
            call setpos('.', s:v_cursor_pos)
        endif

        let poslist = s:get_poslist(a:till_before, a:direction, a:repeat)

        if a:repeat == s:FALSE
            call s:fake_ftFT_history(a:till_before, a:direction)
        endif

        let pos = s:choose_pos(poslist, a:direction, vcount)

        if s:mode == 'v'
            normal! gv
        endif

        if type(pos) == type([])
            call s:move(a:till_before, a:direction, pos)
        endif
    finally
        call s:clean()
    endtry
endfunction

function! s:get_poslist(till_before, direction, repeat)
    let current_pos = getpos('.')

    " Care of cpo-;
    if a:repeat == s:TRUE && a:till_before == s:TRUE
    \     && (v:version >= 704 || v:version == 703 && has("patch235")) && &cpo !~ ';'
        if a:direction == s:DIRECTIONS.RIGHT
            normal! l
        elseif a:direction == s:DIRECTIONS.LEFT
            normal! h
        endif
    endif

    let poslist = []
    let flag = (a:direction == s:DIRECTIONS.LEFT) ? 'b' : ''
    while search("\\V" . s:c, flag, line('.'))
        call add(poslist, getpos('.'))
    endwhile

    call setpos('.', current_pos)
    return poslist
endfunction

function! s:choose_pos(poslist, direction, default)
    if a:direction == s:DIRECTIONS.RIGHT
        let selected = (a:default <= 1) ? 0 : a:default - 1
    elseif a:direction == s:DIRECTIONS.LEFT
        call reverse(a:poslist)
        let selected = (a:default <= 1) ? len(a:poslist) - 1 : len(a:poslist) - a:default
    endif

    if selected < 0 || selected > len(a:poslist) - 1
        return s:FALSE
    endif

    if len(a:poslist) == 1 || a:default > 0 && g:glowshi_ft_vcount_forced_landing == s:TRUE
        return a:poslist[selected]
    endif

    call glowshi_ft#highlight()
    let orig_cursor = s:hide_cursor()
    call s:copy_cursor(orig_cursor)
    if g:glowshi_ft_nohlsearch == s:TRUE
        nohlsearch
    endif

    try
        let vcount = 0
        echo 'char: ' . s:c

        while s:TRUE
            let match_candidates = matchadd('GlowshiFtCandidates', s:regexp_candidates(a:poslist))
            let match_selected = matchadd('GlowshiFtSelected', s:regexp(a:poslist[selected]))

            redraw
            if g:glowshi_ft_timeoutlen > 0
                let c = s:getchar_with_timeout()
            else
                let c = getchar()
            endif
            if type(c) == type(0)
                let c = nr2char(c)
            endif

            call matchdelete(match_selected)
            call matchdelete(match_candidates)

            if c ==# 'h'
                let selected = (selected - ((vcount > 0) ? vcount : 1) + len(a:poslist)) % len(a:poslist)
                let vcount = 0
            elseif c ==# 'l'
                let selected = (selected + ((vcount > 0) ? vcount : 1)) % len(a:poslist)
                let vcount = 0
            elseif c == '^'
                let selected = 0
            elseif c == '$'
                let selected = len(a:poslist) - 1
            elseif c =~ '^[0-9]$'
                if vcount == 0
                    if c != '0'
                        let vcount = c
                    else
                        let selected = 0
                    endif
                else
                    let vcount .= c
                endif
            elseif c =~# g:glowshi_ft_fix_key
                break
            elseif c =~# g:glowshi_ft_cancel_key
                return s:FALSE
            else
                if c != ''
                    call feedkeys((vcount > 1 ? vcount : '') . c)
                endif
                break
            endif
        endwhile

        return a:poslist[selected]
    finally
        call s:show_cursor(orig_cursor)
    endtry
endfunction

function! s:regexp(pos)
    return printf('\%%%dl\%%%dc', a:pos[1], a:pos[2])
endfunction

function! s:regexp_candidates(poslist)
    let pattern = []
    for pos in a:poslist
        call add(pattern, s:regexp(pos))
    endfor
    return join(pattern, '\|')
endfunction

function! s:getchar_with_timeout()
    let start = reltime()
    let key = ''
    while s:TRUE
        let duration_sec = str2float(reltimestr(reltime(start)))
        if duration_sec * 1000 > g:glowshi_ft_timeoutlen
            break
        endif
        let key = getchar(0)
        if type(key) != 0 || key != 0
            break
        endif
        sleep 50m
    endwhile
    return key
endfunction

function! s:fake_ftFT_history(till_before, direction)
    let current_pos = getpos('.')

    if a:direction == s:DIRECTIONS.RIGHT
        if a:till_before == s:FALSE
            execute 'normal! f' . s:c
        elseif a:till_before == s:TRUE
            execute 'normal! t' . s:c
        endif
    elseif a:direction == s:DIRECTIONS.LEFT
        if a:till_before == s:FALSE
            execute 'normal! F' . s:c
        elseif a:till_before == s:TRUE
            execute 'normal! T' . s:c
        endif
    endif

    call setpos('.', current_pos)
endfunction

function! s:move(till_before, direction, pos)
    let pos = a:pos[:]
    if a:till_before == s:TRUE
        if a:direction == s:DIRECTIONS.RIGHT
            let pos[2] -=1
        elseif a:direction == s:DIRECTIONS.LEFT
            let pos[2] +=1
        endif
    endif

    if s:mode == 'no'
        if a:direction == s:DIRECTIONS.LEFT
            normal! h
        endif
        normal! v
    endif

    call setpos('.', pos)
endfunction

function! s:clean()
    let &ignorecase = s:orig_ignorecase
    let &smartcase = s:orig_smartcase
    call s:clear_cmdline()
endfunction

function! s:clear_cmdline()
    echo
endfunction

function! s:hlexists(name)
    return strlen(a:name) > 0 && hlexists(a:name)
endfunction

function! glowshi_ft#highlight()
    if s:hlexists(g:glowshi_ft_selected_hl_link)
        let glowshi_ft_selected_hl_link = g:glowshi_ft_selected_hl_link
        if has('gui_running') && glowshi_ft_selected_hl_link ==? 'cursor'
            let glowshi_ft_selected_hl_link = 'GlowshiFtCursor'
        endif
        execute 'highlight! link GlowshiFtSelected ' . glowshi_ft_selected_hl_link
    else
        execute 'highlight GlowshiFtSelected'
        \     . ' ctermfg=' . g:glowshi_ft_selected_hl_ctermfg
        \     . ' guifg=' . g:glowshi_ft_selected_hl_guifg
        \     . ' ctermbg=' . g:glowshi_ft_selected_hl_ctermbg
        \     . ' guibg=' . g:glowshi_ft_selected_hl_guibg
    endif

    if s:hlexists(g:glowshi_ft_candidates_hl_link)
        let glowshi_ft_candidates_hl_link = g:glowshi_ft_candidates_hl_link
        if has('gui_running') && glowshi_ft_candidates_hl_link ==? 'cursor'
            let glowshi_ft_candidates_hl_link = 'GlowshiFtCursor'
        endif
        execute 'highlight! link GlowshiFtCandidates ' . glowshi_ft_candidates_hl_link
    else
        execute 'highlight GlowshiFtCandidates'
        \     . ' ctermfg=' . g:glowshi_ft_candidates_hl_ctermfg
        \     . ' guifg=' . g:glowshi_ft_candidates_hl_guifg
        \     . ' ctermbg=' . g:glowshi_ft_candidates_hl_ctermbg
        \     . ' guibg=' . g:glowshi_ft_candidates_hl_guibg
    endif
endfunction

function! s:hide_cursor()
    if has('gui_running')
        let hlid = hlID('Cursor')
        let hlid_trans = synIDtrans(hlid)
        if hlid != hlid_trans
            let orig_cursor = synIDattr(hlid_trans, 'name')
            highlight link Cursor NONE
        else
            redir => hl
            silent highlight Cursor
            redir END
            let orig_cursor = matchstr(substitute(hl, '[\r\n]', '', 'g'), 'xxx \zs.*')
            highlight Cursor NONE
        endif
    else
        let orig_cursor = &t_ve
        let &t_ve = ''
    endif
    return orig_cursor
endfunction

function! s:copy_cursor(orig_cursor)
    if has('gui_running')
        if hlexists(a:orig_cursor)
            execute 'highlight! link GlowshiFtCursor ' . a:orig_cursor
        else
            execute 'highlight GlowshiFtCursor ' . a:orig_cursor
        endif
    endif
endfunction

function! s:show_cursor(orig_cursor)
    if has('gui_running')
        if hlexists(a:orig_cursor)
            execute 'highlight! link Cursor ' . a:orig_cursor
        else
            execute 'highlight Cursor ' . a:orig_cursor
        endif
    else
        let &t_ve = a:orig_cursor
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

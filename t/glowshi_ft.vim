let g:glowshi_ft_no_default_key_mappings = 1
map f <Plug>(glowshi-ft-f)
map f <Plug>(glowshi-ft-f)
map F <Plug>(glowshi-ft-F)
map t <Plug>(glowshi-ft-t)
map T <Plug>(glowshi-ft-T)
map : <Plug>(glowshi-ft-repeat)
map , <Plug>(glowshi-ft-opposite)
let g:glowshi_ft_selected_hl_link = 'Cursor'
let g:glowshi_ft_candidates_hl_link = 'Search'

source plugin/glowshi_ft.vim

function! Getchar()
    return getline('.')[col('.') - 1]
endfunction

function! Getcol()
    return col('.')
endfunction

describe 'glowshi-ft-f'
  before
    new
    put! ='aaaaaaaaaabaaaaaaaaaacaaaaaaaaaacaaaaaaaaaa'
  end

  after
    close!
  end

  it 'has highlight'
    Expect hlexists('GlowshiFtSelected') == 1
    Expect hlexists('GlowshiFtCandidates') == 1
    Expect hlexists('GlowshiFtCursor') == 1
  end

  it 'one target'
    Expect Getchar() == 'a'
    silent normal fb
    Expect Getchar() == 'b'
  end

  it 'multi target'
    Expect Getchar() == 'a'
    silent normal fcl\
    Expect Getchar() == 'c'
    Expect Getcol() == 33
  end
end

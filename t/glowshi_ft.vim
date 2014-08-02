let g:glowshi_ft_no_default_key_mappings = 1
map f <Plug>(glowshi-ft-f)
map f <Plug>(glowshi-ft-f)
map F <Plug>(glowshi-ft-F)
map t <Plug>(glowshi-ft-t)
map T <Plug>(glowshi-ft-T)
map : <Plug>(glowshi-ft-repeat)
map , <Plug>(glowshi-ft-opposite)
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

  it 'one target'
    silent normal fb
    Expect Getchar() == 'b'
  end

  it 'multi target'
    silent normal fcl\
    Expect Getchar() == 'c'
    Expect Getcol() == 33
  end
end

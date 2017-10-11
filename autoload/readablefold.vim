scriptencoding utf-8

function! readablefold#foldtext() abort
  let tabstop = exists('b:readablefold_tabstop')
        \ ? b:readablefold_tabstop
        \ : s:get_tabstop()
  let number_width = exists('b:readablefold_number_width')
        \ ? b:readablefold_number_width
        \ : s:get_number_width()
  let signcolumn_width = exists('b:readablefold_signcolumn_width')
        \ ? b:readablefold_signcolumn_width
        \ : s:get_signcolumn_width()
  let lnum = nextnonblank(v:foldstart)
  let line = lnum > v:foldend
        \ ? getline(v:foldstart)
        \ : substitute(getline(lnum), '\t', tabstop, 'g')
  let w = winwidth(0) - &foldcolumn - 3 - number_width - signcolumn_width
  let s = (1 + v:foldend - v:foldstart) . ' lines'
  let f = s:foldlevel[:v:foldlevel]
  let e = s:foldspace[:w - strwidth(line . s . f)]
  return join([line, e, s, f], ' ')
endf


" Private --------------------------------------------------------------------
function! s:get_tabstop() abort
  let b:readablefold_tabstop = repeat(' ', &tabstop)
  return b:readablefold_tabstop
endfunction

function! s:get_number_width() abort
  let b:readablefold_number_width = (&number || &relativenumber)
        \ ? len(string(line('$'))) + 2
        \ : 0
  augroup readablefold_local_number_width
    autocmd! * <buffer>
    autocmd InsertLeave <buffer>
          \ silent! unlet! b:readablefold_number_width
    autocmd TextChanged <buffer>
          \ silent! unlet! b:readablefold_number_width
  augroup END
  return b:readablefold_number_width
endfunction

function! s:get_signcolumn_width() abort
  let signcolumn = &signcolumn !=# 'auto'
        \ ? &signcolumn ==# 'yes'
        \ : len(split(execute('sign place buffer=' . bufnr('%')), '\r\?\n')) > 1
  let b:readablefold_signcolumn_width = signcolumn ? 2 : 0
  augroup readablefold_local_signcolumn_width
    autocmd! * <buffer>
    autocmd BufEnter <buffer>
          \ silent! unlet! b:readablefold_signcolumn_width
  augroup END
  return b:readablefold_signcolumn_width
endfunction


" Configure ------------------------------------------------------------------
let g:readablefold#foldlevel_char = get(g:, 'readablefold#foldlevel_char', '|')
let g:readablefold#foldspace_char = get(g:, 'readablefold#foldspace_char', '.')

augroup readablefold
  autocmd! *
  autocmd VimResized *
        \ let s:foldspace = repeat(g:readablefold#foldspace_char, &columns)
  autocmd OptionSet tabstop
        \ silent! unlet! b:readablefold_tabstop
  autocmd OptionSet number,relativenumber
        \ silent! unlet! b:readablefold_number_width
  autocmd OptionSet signcolumn
        \ silent! unlet! b:readablefold_signcolumn_width
augroup END


" Pre-compute ----------------------------------------------------------------
let s:foldlevel = repeat(g:readablefold#foldlevel_char, 10)
let s:foldspace = repeat(g:readablefold#foldspace_char, &columns)

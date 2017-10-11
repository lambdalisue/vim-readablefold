if exists('g:readablefold_loaded')
  finish
endif
let g:readablefold_loaded = 1

if !get(g:, 'readablefold_disabled', 0)
  set foldtext=readablefold#foldtext()
endif

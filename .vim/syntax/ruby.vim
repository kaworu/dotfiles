" tabs are 2 space for ruby
set shiftwidth=2
set tabstop=2

let ruby_operators=1
let g:rubycomplete_buffer_loading=1
let g:rubycomplete_classes_in_global=1

if has("autocmd")
    set omnifunc=rubycomplete#Complete
endif

let python_highlight_builtins=1
let python_highlight_exceptions=1
let python_highlight_numbers=1
let python_highlight_space_errors=1

if has("autocmd")
    set omnifunc=pythoncomplete#Complete
endif

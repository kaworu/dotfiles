" use XHTML and CSS with :TOhtml
let use_xhtml=1
let html_use_css=1
let html_ignore_folding=1
let html_use_encoding="UTF-8"

if has("autocmd")
    set omnifunc=htmlcomplete#CompleteTags
endif

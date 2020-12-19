" tabs are 2 space for JSON
set shiftwidth=2
set tabstop=2

if executable("jq")
    setlocal equalprg=jq
endif

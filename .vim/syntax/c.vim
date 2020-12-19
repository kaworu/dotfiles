" try to honor style(9)
set shiftwidth=8
set tabstop=8
set noexpandtab
set textwidth=80

if has("autocmd")
    set omnifunc=ccomplete#Complete
endif

if executable("clang-format")
    setlocal equalprg=clang-format
endif

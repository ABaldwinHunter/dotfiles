call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'ervandew/supertab'
Plug 'rust-lang/rust.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'slim-template/vim-slim'
call plug#end()

set nocompatible
set bs=2
syntax on
set ruler
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set clipboard=unnamed
set number
" press jk to exit insert mode
inoremap jk <ESC>
inoremap JK <ESC>

" status line
set laststatus=2
"%f = file path
"%l:%c = line and column
"%m file modified flag ([+] when there are unsaved changes)
set statusline=%F\ %l:%c\ %m

let g:ackprg = 'ag --nogroup --nocolor --column'

" autocmd BufWritePre * :%s/\s\+$//e
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)

  " Create a cache file if not yet exists
  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
    call writefile(a:items, cachefile)
  endif
  if !filereadable(cachefile)
    return []
  endif

  " a:mmode is currently ignored. In the future, we should probably do
  " something about that. the matcher behaves like "full-line".
  let cmd = g:path_to_matcher.' --limit '.a:limit.' --manifest '.cachefile.' '
  let cmd = cmd.a:str

  return split(system(cmd), "\n")

endfunction

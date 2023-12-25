set nocompatible
filetype off

set hlsearch
set autoindent
set nocompatible
set fileformats=unix,dos,mac

syntax on
filetype on

set number
set showmatch
set shiftwidth=2
set softtabstop=2
set tabstop=2
set completeopt=menu,longest,preview
set wildignore=*.o,*~,*.pyc

set backspace=indent,eol,start

" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Highlight JSON as JavaScript, useful to avoid loading `json.vim`.
autocmd BufNewFile,BufRead *.json set ft=javascript

" Trim trailing whitespace in JavaScript files.
autocmd BufWritePre *.js normal m`:%s/\s\+$//e ``

" Indentation
set smartindent
set autoindent
set expandtab
set softtabstop=2
set shiftwidth=2
filetype on

map <F4> :cn<CR>
map <F3> :cp<CR>
map <F7> :w<CR> :mak<CR>
map <F8> :mak clean<CR>
map <F9> :w<CR> :mak test<CR>

let c_no_curly_error=1

set matchpairs+=<:>

set visualbell

set rtp+=~/.vim/pack/plugins/opt/YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
map <F12> :YcmCompleter FixIt<CR>

set encoding=utf-8

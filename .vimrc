"------------------------------------------------------------------------------
" Author: Michael Mead
"------------------------------------------------------------------------------
set nocompatible

"------------------------------------------------------------------------------
" Core: Filetype handling and syntax
"------------------------------------------------------------------------------ 
syntax enable
filetype on
filetype plugin on
set nowrap

"------------------------------------------------------------------------------
" Interface: Colorschemes
"------------------------------------------------------------------------------
set t_Co=256
set background=dark

"------------------------------------------------------------------------------
" Format: Line numbering and cursorlines
"------------------------------------------------------------------------------
set number

augroup CursorLine " Show cursorline for current window only
    au!
    au VimEnter,WinEnter,BufEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END 

autocmd InsertEnter,InsertLeave * set cul! " Toggle cursor line (normal/insert)

"------------------------------------------------------------------------------
" Format: Tabs and indentation
"------------------------------------------------------------------------------
set autoindent
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap

"------------------------------------------------------------------------------
" Format: FoldSettings
"------------------------------------------------------------------------------
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1

"------------------------------------------------------------------------------
" Navigation: Moving around, searching, and patterns
"------------------------------------------------------------------------------
set nostartofline
set backspace=indent,eol,start
set smartcase
set ic
set incsearch

"------------------------------------------------------------------------------
" KeyMaps: - major
"------------------------------------------------------------------------------
let mapleader=","
inoremap jk <esc>

"------------------------------------------------------------------------------
" KeyMaps: - Leader maps
"------------------------------------------------------------------------------
map <leader>to :tabnew<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>
map <leader>tc :tabclose<cr>
map <leader>tc :tabclose<cr>

" Close current buffer, keep bits of information
map <leader>bd :bd<cr>

" Close all current buffers, keep bits of information
map <leader>ba :1,000 bd!<cr>

" Close current buffer and wipe information
map <leader>bw :bw<cr>

"------------------------------------------------------------------------------
" KeyMaps: - Windows 
"------------------------------------------------------------------------------
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

if bufwinnr(1)
    map <F2> <C-W>+
    map <F3> <C-W>-
    map <F6> <C-W>>
    map <F7> <C-W><
endif

set splitright

"------------------------------------------------------------------------------
" KeyMaps: inserting parentheses, blocks, quotes, etc.
"------------------------------------------------------------------------------
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i

vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`<a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

"------------------------------------------------------------------------------
" KeyMaps: Insert spaces and lines without leaving insert mode
"------------------------------------------------------------------------------
nnoremap <silent> zj o<esc>k 
nnoremap <silent> zk O<esc>j
nnoremap <silent> zh i<space><esc>l
nnoremap <silent> zl a<space><esc>h

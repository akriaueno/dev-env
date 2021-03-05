if &compatible
  set nocompatible
endif

let s:dein_dir = expand('~/.cache/dein')

let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  let s:toml_dir = expand('~/.config/nvim/dein')

  call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})
  " call dein#load_toml(s:toml_dir . '/dain_lazy.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
syntax enable

" let g:python_host_prog = $HOME . '/nvim/venv-py2/bin/python'
let g:python3_host_prog = $HOME . '/nvim/venv/bin/python'

set ttimeoutlen=10

set encoding=utf-8
set fileencodings=utf-8,sjis,iso-2022-jp,euc-jp

set nobackup
set noswapfile

set autoread
set hidden
set showcmd
set backspace=indent,eol,start

set nonumber
set nocursorline
set nocursorcolumn

set virtualedit=onemore
set smartindent
set visualbell
set showmatch
set laststatus=2
set ruler
set wildmode=list:longest

nnoremap j gj
nnoremap k gk

set list listchars=tab:\▸\-
set expandtab
set tabstop=2
set shiftwidth=2

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch

let g:deoplete#enable_at_startup = 1

if has("autocmd")
  filetype plugin on
  filetype indent on
  autocmd FileType c           setlocal sw=2 sts=2 ts=2 et
  autocmd FileType c++         setlocal sw=2 sts=2 ts=2 et
  autocmd FileType html        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType ruby        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType js          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType r           setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scss        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sass        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript  setlocal sw=4 sts=4 ts=4 et
endif
vnoremap <silent> <C-p> "0p<CR>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-k> <Up>
inoremap <C-j> <Down>

" vim-lsp
au BufWritePre *.ts :LspDocumentFormat

"タブ、空白、改行の可視化
set list
" set listchars=tab:>.,trail:_,eol:↲,extends:>,precedes:<,nbsp:%
set listchars=tab:>.,trail:_,extends:>,precedes:<,nbsp:%

"全角スペースをハイライト表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
  endif

""" 見た目
" テキスト背景色
au ColorScheme * hi Normal ctermbg=none
" 括弧対応
au ColorScheme * hi MatchParen cterm=bold ctermfg=214 ctermbg=black
" スペルチェック
au Colorscheme * hi SpellBad ctermfg=23 cterm=none ctermbg=none
set background=dark
set t_Co=256
" colorscheme nord
colorscheme molokai

"  """ ALE settings
let g:ale_sign_column_always = 1
let g:ale_fix_on_save = 1
let g:ale_linters = {
\   'python': ['flake8'],
\   'typescript': ['eslint'],
\   'json': ['eslint'],
\   'go': ['gometalinter'],
\   'c': ['gcc'],
\}
let g:ale_fixers = {
\   'python': ['black', 'isort'],
\   'typescript': ['prettier'],
\   'json': ['eslint'],
\   'go':['gofmt'],
\   'r': ['styler'],
\}
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" for pyton
let g:ale_python_flake8_executable = g:python3_host_prog
let g:ale_python_flake8_options = '-m flake8 --max-line-length=99 --ignore=E203,W503,W504'
let g:ale_python_isort_executable = g:python3_host_prog
let g:ale_python_isort_options = '-m isort'
let g:ale_python_black_executable = g:python3_host_prog
let g:ale_python_black_options = '-m black'
" for go
let g:ale_go_gometalinter_options = '--fast --enable=staticcheck --enable=gosimple --enable=unused'
" for c
let g:ale_c_gcc_options='-std=c99 -Wall -Wextra'
" for c++
let g:ale_cpp_gcc_options = "-std=c++14"

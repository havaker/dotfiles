set encoding=utf-8

" enable mouse scrolling
set mouse=a

set history=1000
set undolevels=1000

" opening a new file when the current buffer has unsaved changes causes
" files to be hidden instead of closed
" the unsaved changes can still be accessed by typing :ls and then :b[N]
set hidden

" enable syntax highlighting
syntax enable

" keep the cursor in the middle of the screen
" set scrolloff=15

" expand tabs to spaces
set expandtab
" autoindenting
set autoindent
set copyindent
set shiftround
" tab = 4 spaces by default
set tabstop=4
set shiftwidth=4

" don't wrap lines by default
set nowrap
" line wrap toggle
nnoremap <leader>w :set wrap!<CR>
" https://stackoverflow.com/questions/1204149/smart-wrap-in-vim
" enable indentation
set breakindent
" ident by an additional 2 characters on wrapped lines,
" when line >= 40 characters, put 'showbreak' at start of line
set breakindentopt=shift:2,min:40,sbr
" append '>>' to indent
set showbreak=>>
" don't cut words
set linebreak

" ignore case if search pattern is all lowercase, case-sensitive otherwise
set ignorecase " vim require it to be set before smartcase has any effect
set smartcase

" show line numbers
set number relativenumber
" toggle relative line numbers type by <leader>n
nnoremap <leader>n :set relativenumber!<CR>

" highlight current line
set cursorline
" highlight search terms, but clear on esc
set hlsearch
" show search matches during typing
set incsearch
" map <leader>c to clear search pattern and close all location lost or quic fix windows
nnoremap <leader>c :let @/ = ""<CR> :windo lcl\|ccl\|pc<CR>

" change terminal title
set title
" don't use terminal bell
set visualbell
set noerrorbells
set t_vb=

" who needs it?!
set nobackup
set noswapfile

" color 81th column
let &colorcolumn=0
nnoremap <leader>f :call ColorColumnToggle()<CR>
function! ColorColumnToggle()
    if &colorcolumn
        set colorcolumn=0
    else
        set colorcolumn=81
    endif
endfunction

" shortcut for paste mode
nnoremap <leader>p :set paste!<CR>

" show that there are more characters in a long line
set nolist
set listchars=extends:#,precedes:#,tab:▸\ ,eol:¬
nmap <leader>L :set list!<CR>

" delay in entering normal mode after pressing ESC
set ttimeoutlen=10

" w!! saves the file with sudo
cmap w!! w !sudo tee % >/dev/null

" remove trailing whitespace on file save
autocmd BufWritePre * :%s/\s\+$//e

" don't mess up html files
let html_no_rendering=1

" open new panes on the right and below
set splitbelow
set splitright

" %% expands into path to current file
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

" open file in current file's directory
map <leader>ew :e %%
map <leader>et :tabe %%

nnoremap ; :

noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj
noremap  <buffer> <silent> 0 g0
noremap  <buffer> <silent> $ g$

" easier split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" copy ctrl-c
vnoremap <C-c> "+y
map <C-v> "+P

" try to show as much as possible of the last line in the window (rather than
" a column of "@", which is the default behavior)
set display+=lastline

" spellcheck toggle
nmap <leader>s :setlocal spell! spelllang=en_us,pl<CR>

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'flazz/vim-colorschemes', { 'do': ':colorscheme oxeded' }

Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'

Plug 'editorconfig/editorconfig-vim'

Plug 'fatih/vim-go'
Plug 'blankname/vim-fish'
Plug 'uarun/vim-protobuf'
Plug 'gabrielelana/vim-markdown'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

"Plug 'rust-lang/rust.vim'
"Plug 'terryma/vim-expand-region'
"Plug 'jpalardy/vim-slime'
"Plug 'leafgarland/typescript-vim'
"Plug 'sukima/xmledit'
"Plug 'digitaltoad/vim-pug'

call plug#end()
filetype plugin indent on

" LanguageClient useful mappings
nmap <leader>m <Plug>(lcn-menu)
nmap <leader>d <Plug>(lcn-definition)
nmap gd <Plug>(lcn-definition)
nmap gsd :split <CR> <Plug>(lcn-definition)
nmap gvd :vsplit <CR> <Plug>(lcn-definition)
nmap <leader>r <Plug>(lcn-references)
nmap gr <Plug>(lcn-references)
nmap gsr :split <CR> <Plug>(lcn-references)
nmap gvr :vsplit <CR> <Plug>(lcn-references)
nmap <leader>h <Plug>(lcn-highlight)
nmap <leader>i <Plug>(lcn-implementation)
nmap <leader>e <Plug>(lcn-explain-error)
" launch appropriate servers
let g:LanguageClient_serverCommands = {
       \ 'go': ['gopls'],
       \ 'rust': ['rust-analyzer-linux'],
       \ 'python': ['pyls'],
       \ 'cpp': ['ccls'],
       \ 'c': ['ccls'],
       \ }
" run gofmt on save when Go files are in use
"autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()
" run rustfmt on save when Rust files are in use
autocmd BufWritePre *.rs :call LanguageClient#textDocument_formatting_sync()

" deoplete settings
let g:deoplete#enable_at_startup = 1
" be like ycm
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='bubblegum'

" show airline when there is only one tab
set laststatus=2

" NERDTree settings
map <C-n> :NERDTreeToggle<CR>
map <C-f> :NERDTreeFind<CR>
let NERDTreeMapOpenSplit = 's'
let NERDTreeMapOpenVSplit = 'v'
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

" ctrlp settings
let g:ctrlp_working_path_mode = 'r'
nnoremap <leader>p :call CtrlpPathToggle()<CR>
" map <leader>p :call CtrlpPathToggle()<CR>
function! CtrlpPathToggle()
    if g:ctrlp_working_path_mode == 'c'
        let g:ctrlp_working_path_mode = 'r'
    else
        let g:ctrlp_working_path_mode = 'c'
    endif
endfunction
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/third_party/*,*/target/*

" vim-colorschemes settings
colorscheme oxeded

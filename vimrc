set nocompatible

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load builtin matchit.vim unless there's a newer version
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

" allow unsaved background buffers and remember marks/undo for them
set hidden
set ruler " always show cursor position
set number relativenumber
set history=1000
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
set showcmd " display incomplete commands
set backspace=indent,eol,start
set scrolloff=3
set autoread
set nofoldenable

" Open new split panes to right and bottom
set splitbelow
set splitright

" Highlight where 80 characters is
set textwidth=80
set colorcolumn=+1

" use softtabs (2 of course)
set tabstop=2
set shiftwidth=2
set expandtab
set shiftround

" Colors and syntax highlighting
syntax on
set background=light
colorscheme solarized

set wildmode=longest,list

" make tab completion for files/buffers act like bash
set wildmenu

" ignore vendor/bundle directory in bundler projects
set wildignore+=*.png,*.PNG,*.JPG,*.jpg,*.GIF,*.gif,vendor/bundle/**,tmp/**

let mapleader=","

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

augroup vimrcEx
  " clear all autocmds in group
  autocmd!

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax for certain file types
  autocmd BufNewFile,BufRead Guardfile,.Guardfile set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Wrap at 72 characters and spell check git commits
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Switch between last 2 files
nnoremap <leader><leader> <c-^>

" Store temporary files in a central spot
set backupdir=~/.vim/tmp//,~/.tmp//,~/tmp//,/tmp//
set directory=~/.vim/tmp//,~/.tmp//,~/tmp//,/tmp//

" Status line
set statusline=%<%f\ %m%r%w\ %y%=L:\%l\/%L\ C:%c

" Clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>
" insert hashrocket with <c-l>
imap <c-l> <space>=><space>

" Arrow keys are unacceptable
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>

" Smart tab key (borrowed from gary bernhardt)
" inserts tabs at the beginning of lines, otherwise does completion
function! InsertTabWrapper()
    let col = col('.') - 1
        if !col || getline('.')[col - 1] !~ '\k'
            return "\<tab>"
        else
            return "\<c-p>"
        endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

let g:html_indent_tags = 'li\|p'

" Close buffer without closing window/split
nnoremap <silent> <leader>bd :bp\|bd #<cr>
command Bd bp\|bd \#

" Check syntax on open
let g:syntastic_check_on_open=1

" Vim-test mappings
map <Leader>t :TestFile<CR>
map <Leader>s :TestNearest<CR>
map <Leader>l :TestLast<CR>
map <Leader>a :TestSuite<CR>
let test#strategy = "dispatch"

" Dispatch settings
let g:dispatch_compilers = {
      \ 'bundle exec': '',
      \ 'clear;': '',
      \ 'zeus': ''}

" Autocomplete dictionary words if spell check is on
set complete+=kspell

" Local config
if filereadable($HOME . "/.vimrc.local")
  source $HOME/.vimrc.local
endif

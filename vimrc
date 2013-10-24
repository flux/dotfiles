" enable pathogen
call pathogen#infect()

set nocompatible
" allow unsaved background buffers and remember marks/undo for them
set hidden
set ruler " always show cursor position
set number
set history=10000
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
set smartcase
set cursorline " highlight current line
set showcmd " display incomplete commands
set backspace=indent,eol,start
set scrolloff=3

" use softtabs (2 of course)
set tabstop=2
set shiftwidth=2
set expandtab
set shiftround

" Colors and syntax highlighting
syntax on
set background=dark
colorscheme solarized

filetype plugin indent on

set wildmode=longest,list

" make tab completion for files/buffers act like bash
set wildmenu

" ignore vendor/bundle directory in bundler projects
set wildignore+=*.png,*.PNG,*.JPG,*.jpg,*.GIF,*.gif,vendor/bundle/**,tmp/**

let mapleader=","

augroup vimrcEx
  " clear all autocmds in group
  autocmd!

  autocmd FileType text setlocal textwidth=78

  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  " treat Guardfile(s) as ruby
  autocmd BufNewFile,BufRead Guardfile,.Guardfile set filetype=ruby
augroup END

" autoflush command-t
"augroup CommandTExtension
"  autocmd!
"  autocmd FocusGained * CommandTFlush
"  autocmd BufWritePost * CommandTFlush
"augroup END

" Use leader-t to invoke ctrlp
nnoremap <leader>t :CtrlP<CR>

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Switch between last 2 files
nnoremap <leader><leader> <c-^>

" Store temporary files in a central spot
set backupdir=~/.vim-tmp//,~/.tmp//,~/tmp//,/tmp
set directory=~/.vim-tmp//,~/.tmp//,~/tmp//,/tmp

" status line
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" Clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>
" insert hashrocket with <c-l>
imap <c-l> <space>=><space>

" Arrow keys are unacceptable
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>

" rename current file (taken from Gary Bernhardt)
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

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

" remove git branch from vim powerline
call Pl#Theme#RemoveSegment('fugitive:branch')

" Local config
if filereadable($HOME . "/.vimrc.local")
  source $HOME/.vimrc.local
endif

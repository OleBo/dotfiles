" Drop total compatibility with ancient vi.
set nocompatible


" Figure out our config directory.
let config_dir = has("nvim") ? '~/.config/nvim' : '~/.vim'
let dein_repo = 'github.com/Shougo/dein.vim'
let dein_url = 'https://' . dein_repo . '.git'
let plugins_dir = config_dir . '/dein'
let dein_dir = plugins_dir . '/repos/' . dein_repo


" Auto-install package manager. Sources:
" https://github.com/Shougo/dein.vim#quick-start
" https://github.com/stuarthicks/dotfiles/blob/master/neovim/.config/nvim/init.vim
if empty(glob(dein_dir))
    exec 'silent !mkdir -p ' . dein_dir
    exec '!git clone ' . dein_url . ' ' . dein_dir
endif
exec 'set runtimepath^=' . dein_dir

call dein#begin(expand(plugins_dir))

" Package manager
call dein#add('Shougo/dein.vim')

" Color scheme
call dein#add('crusoexia/vim-monokai')

" GUI  https://gist.github.com/xvzftube/5380163d8fc9090796eb6fcc61fe022d
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
call dein#add('Yggdroot/indentLine')
call dein#add('SirVer/ultisnips')
call dein#add('honza/vim-snippets')
call dein#add('lervag/vimtex')
call dein#add('airblade/vim-gitgutter')    " shows git changes in gutter
call dein#add('ctrlpvim/ctrlp.vim')        " full path fuzzy file finder
call dein#add('tpope/vim-fugitive')        " allows git commands in vim session
call dein#add('tpope/vim-rhubarb')         " GitHub extension for fugitive.vim
call dein#add('easymotion/vim-easymotion') " go to any word '\\w', '\\e', '\\b'
call dein#add('KKPMW/vim-sendtowindow')    " send commands to REPL '\k' - top
call dein#add('yuttie/comfortable-motion.vim') " scrolling 'C-d', 'C-u'
call dein#add('ncm2/ncm2')                 " completition-[dep]:
call dein#add('roxma/nvim-yarp')           " remote plugin framawork for ncm2
call dein#add('ncm2/ncm2-bufword')         " complete words in buffer
call dein#add('ncm2/ncm2-path')            " complete paths
call dein#add('ncm2/ncm2-jedi')                 " python completion
autocmd BufEnter * call ncm2#enable_for_buffer() " enable ncm2 for all buffers
set completeopt=noinsert,menuone,noselect        " see :help Ncm2PopupOpen

call dein#add('fisadev/vim-isort') " python sort import [dep] pip install isort
" :Isort

call dein#add('iamcco/markdown-preview.nvim', {'on_ft': ['md','markdown', 'pandoc.markdown', 'rmd'], 'build': 'sh -c ' })
let g:mkdp_auto_start = 1 " call :MarkdownPreview
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip =''
let g:mkdp_browser = ''
" example
nmap <C-s> <Plug>MarkdownPreview
nmap <M-s> <Plug>MarkdownPreviewStop
nmap <C-p> <Plug>MarkdownPreviewToggle

call dein#add('alfredodeza/coveragepy.vim')
call dein#add('ervandew/supertab')
call dein#add('ryanoasis/vim-devicons')

" Syntax
call dein#add('sheerun/vim-polyglot')
call dein#add('hail2u/vim-css3-syntax')
call dein#add('vim-scripts/po.vim--gray')
call dein#add('vim-scripts/plist.vim', {'on_ft': 'plist'})
call dein#add('hunner/vim-plist', {'on_ft': 'plist'})

" Linters
call dein#add('w0rp/ale') " using flake8
" management of tags files
" - It will (re)generate tag files as you work while staying out of your way.
call dein#add('ludovicchabant/vim-gutentags')
" Edition
call dein#add('Chiel92/vim-autoformat')
call dein#add('Shougo/deoplete.nvim') " autocomplete framework
call dein#add('Raimondi/delimitMate')
call dein#add('mg979/vim-visual-multi')
call dein#add('haya14busa/incsearch.vim')
call dein#add('junegunn/vim-easy-align')
call dein#add('tpope/vim-surround')
call dein#add('goerz/jupytext.vim')
" editing Jupyter notebook (ipynb) files through jupytext."

let g:jupytext_enable = 1 "deactivate this plugin by setting this to 0
let g:jupytext_command = '$HOME/.pyenv/versions/3.9.2/bin/jupytext'
let g:jupytext_fmt = 'py' "format to which to convert the ipynb data (md,py,R)
let g:jupytext_to_ipynb_opts = '--to=ipynb --update'
let g:jupytext_print_debug_msgs = 1 "If set to 1, print debug messages

call dein#add('tpope/vim-repeat')
" dim paragraph above and below the active paragraph
call dein#add('junegunn/limelight.vim')
" distraction free writing by removing UI elements and centering everything
call dein#add('junegunn/goyo.vim')

if has('nvim') == 0
    call dein#add('tpope/vim-sensible')
endif

call dein#end()

if dein#check_install()
    call dein#install()
endif


filetype plugin indent on      " Indent and plugins by filetype

" Map the leader key to SPACE
let mapleader = "\<Space>"
let maplocalleader=' '

scriptencoding utf-8
set encoding=utf-8              " setup the encoding to UTF-8
set ls=2                        " status line always visible

" Leader-based shortcuts {{{
" Source: https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
" Type <Space>o to open a new file
nnoremap <Leader>o :CtrlP<CR> " TODO: CtrlP is not a command
" Type <Space>w to save file
nnoremap <Leader>w :w<CR>
" edit your configuration file
nnoremap <Leader>v :e $MYVIMRC<cr>
" Reloads configuration file after saving but keep cursor position
if !exists('*ReloadVimrc')
    fun! ReloadVimrc()
        let save_cursor = getcurpos()
        source $MYVIMRC
        call setpos('.', save_cursor)
    endfun
endif
autocmd! BufWritePost $MYVIMRC call ReloadVimrc()
" Copy & paste to system clipboard with <Space>p and <Space>y
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
" Enter visual line mode with <Space><Space>
nmap <Leader><Leader> V


" Copy & paste
if has ('x') && has ('gui') " On Linux use + register for copy-paste
    set clipboard=unnamedplus
elseif has ('gui')          " On mac and Windows, use * register for copy-paste
    set clipboard=unnamed
endif
" Enable 'bracketed paste mode'. See: https://stackoverflow.com/a/7053522/31493
if &term =~ "xterm.*"
    let &t_ti = &t_ti . "\e[?2004h"
    let &t_te = "\e[?2004l" . &t_te
    function XTermPasteBegin(ret)
        set pastetoggle=<Esc>[201~
        set paste
        return a:ret
    endfunction
    map <expr> <Esc>[200~ XTermPasteBegin("i")
    imap <expr> <Esc>[200~ XTermPasteBegin("")
    cmap <Esc>[200~ <nop>
    cmap <Esc>[201~ <nop>
endif

" window splits
set splitbelow splitright
"remap split navigation ti just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" make adjusting splits a bit more friendly
"noremap <silent> <C-Left> :vertical resize +3<CR>
"noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <ALT-Up> :resize -3<CR>
noremap <silent> <ALT-Down> :resize +3<CR>
" Change 2 split windows from vertical to horiz. or horiz. to vertical
"map <Leader>th <C-w>t<C-w>H
"map <Leader>tk <C-w>t<C-w>K
" Start terminals for Python session '\tp'
map <Leader>tp :new term://zsh<CR>ipython<CR><C-\><C-n><C-w>k

" GUI
set number relativenumber   " enable absolute and relative line numbers
augroup numbertoggle        " entering insert mode, relative line numbers are turned off
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
set mouse=a
set mousehide
set wrap
set cursorline
set ttyfast
set title
set showcmd
set hidden
set ruler
set lazyredraw
set autoread
set ttimeoutlen=0
" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500
" type 'gf' to go to file, 'gd' to go to local definition, 'gD' to go to global definition,
" 'gx'to open url under the cursor, Ctrl-6 to jump back; test www.complexlab.org
set path+=**
" A small workaround until https://github.com/vim/vim/issues/4738 is fixed
if has('macunix')
    function! OpenURLUnderCursor()
        let s:uri = matchstr(getline('.'), '[a-z]*:\/\/[^ >,;()]*')
        let s:uri = shellescape(s:uri, 1)
        if s:uri != ''
            silent exec "!open '".s:uri."'"
            :redraw!
        endif
    endfunction
    nnoremap gx :call OpenURLUnderCursor()<CR>
endif

" Editing
set expandtab                  " spaces instead of tabs
set tabstop=4                  " a tab = four spaces
set shiftwidth=4               " number of spaces for auto-indent
set softtabstop=4              " a soft-tab of four spaces
set backspace=indent,eol,start
set autoindent                 " set on the auto-indent
set foldmethod=indent          " automatically fold by indent level
set nofoldenable               " ... but have folds open by default"
set virtualedit=all
set textwidth=79
set colorcolumn=80
" highlight tabs and trailing spaces
" source: https://wincent.com/blog/making-vim-highlight-suspicious-characters
set listchars=nbsp:¬,eol:¶,tab:→\ ,extends:»,precedes:«,trail:•
" Leave Ex Mode, For Good
" source: http://www.bestofvim.com/tip/leave-ex-mode-good/
nnoremap Q <nop>


" Searching
set incsearch      " incremental searching
set showmatch      " show pairs match
set hlsearch       " highlight search results
set smartcase      " smart case ignore
set ignorecase     " ignore case letters


" History and permanent undo levels
set history=1000
set undofile
set undoreload=1000

" tell vim to look for the ctags index file in the source directory
set tags=tags

" Color scheme.
syntax enable           " Enables syntax highlighing
colorscheme monokai


" Font
" List available fonts with: fc-list | cut -d ':' -f 2 | sort | uniq
set guifont=SauceCodePro\ Nerd\ Font:h11


" Make a dir if no exists
function! MakeDirIfNoExists(path)
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path), "p")
    endif
endfunction


" Backups
set backup
set noswapfile
set backupdir=~/.config/nvim/tmp/backup/
set undodir=~/.config/nvim/tmp/undo/
set directory=~/.config/nvim/tmp/swap/
set viminfo+=n~/.config/nvim/tmp/viminfo
" Make this dirs if no exists previously
silent! call MakeDirIfNoExists(&undodir)
silent! call MakeDirIfNoExists(&backupdir)
silent! call MakeDirIfNoExists(&directory)


" Delete trailing whitespaces
autocmd BufWritePre,FileWritePost * :%s/\s\+$//e
" Replace all non-breakable spaces by simple spaces
" Source: http://nathan.vertile.com/find-and-replace-non-breaking-spaces-in-vim/
autocmd BufWritePre,FileWritePost * silent! :%s/\%xa0/ /g
" Remove Byte Order Mark at the beginning
autocmd BufWritePre,FileWritePost * setlocal nobomb


" Execution permissions by default to shebang (#!) files
augroup shebang_chmod
    autocmd!
    autocmd BufNewFile  * let b:brand_new_file = 1
    autocmd BufWritePost * unlet! b:brand_new_file
    autocmd BufWritePre *
                \ if exists('b:brand_new_file') |
                \   if getline(1) =~ '^#!' |
                \     let b:chmod_post = '+x' |
                \   endif |
                \ endif
    autocmd BufWritePost,FileWritePost *
                \ if exists('b:chmod_post') && executable('chmod') |
                \   silent! execute '!chmod '.b:chmod_post.' "<afile>"' |
                \   unlet b:chmod_post |
                \ endif
augroup END


" Airline
set noshowmode
let g:airline_theme = 'molokai'
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#buffer_min_count = 1

" To make vimtex work with deoplete
call deoplete#custom#var('omni', 'input_patterns', {
            \ 'tex': g:vimtex#re#deoplete
            \})

" indentLine
let g:indentLine_char = '┊'
let g:indentLine_color_term = 239


" ALE config for linting.
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 1
let g:ale_sign_column_always = 1
let g:ale_echo_msg_format = '[%linter%] %s'


" Git gutter
let g:gitgutter_max_signs = 10000
" Use fontawesome icons as signs
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'
" setting the background color of the sign column to your general background color
let g:gitgutter_override_sign_column_highlight = 1
highlight SignColumn guibg=bg
highlight SignColumn ctermbg=bg

" delimitMate
let delimitMate_expand_space = 1        " expansion of <Space>
let delimitMate_expand_cr = 1           " expansion of <CR>

" EasyAllign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Netrw (NERDtree like setup)
let g:netrw_banner = 0          " Removing the banner
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4    " open in previous window
let g:netrw_altv = 1
let g:netrw_winsize = 25

" JSON
" Disable concealing mode altogether.
let g:vim_json_syntax_conceal = 0


" Markdown
" Disable element concealing.
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/local/opt/python/libexec/bin/python'

let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"
let $NVIM_PYTHON_LOG_LEVEL="DEBUG"

" Plist
au BufRead,BufNewFile *.plist set filetype=plist

" Autoformat upon saving file
au BufWrite * :Autoformat
let g:autoformat_verbosemode=2

" tex:   write the server address to temp file and read the server address
" from that file when we run the nvr command
" https://jdhao.github.io/2021/02/20/inverse_search_setup_neovim_vimtex/
function! SetServerName()
    if has('win32')
        let nvim_server_file = $TEMP . "/curnvimserver.txt"
    else
        let nvim_server_file = "/tmp/curnvimserver.txt"
    endif
    let cmd = printf("echo %s > %s", v:servername, nvim_server_file)
    call system(cmd)
endfunction

augroup vimtex_common
    autocmd!
    autocmd FileType tex call SetServerName()
augroup END

let g:vimtex_view_method = "skim"
" https://jdhao.github.io/2019/03/26/nvim_latex_write_preview/
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

augroup vimtex_mac
    autocmd!
    autocmd User VimtexEventCompileSuccess call UpdateSkim()
augroup END

function! UpdateSkim() abort
    let l:out = b:vimtex.out()
    let l:src_file_path = expand('%:p')
    let l:cmd = [g:vimtex_view_general_viewer, '-r']

    if !empty(system('pgrep Skim'))
        call extend(l:cmd, ['-g'])
    endif

    call jobstart(l:cmd + [line('.'), l:out, l:src_file_path])
endfunction

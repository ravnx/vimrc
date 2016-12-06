" .vimrc
" Michael Palmer
" Last update: Tue Dec 06 15:04:08 CST 2016

"Enable Syntax Hilighting if vim version supports it
if has("syntax")
    syntax on
endif

" Enable a nice big viminfo file
set viminfo='500,f1,:500,/500
set history=250

set nocompatible    " Don't be vi'ish, be vimish
set backspace=indent,eol,start  " Backspace can delete all sorts of stuff

" By default, go for an indent of 4
set shiftwidth=4

" Do clever indent things. Don't make a # force column zero.
set autoindent
set smartindent
inoremap # X<C-H>#

" Turn off Indenting, (i hate typing :set paste)
"set noautoindent
"set nosmartindent
"inoremap # X<BS>#

" Show tabs and trailing whitespace visually
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        set list listchars=tab:Â»Â·,trail:Â·,extends:â€¦,nbsp:â€—
    else
        set list listchars=tab:Â»Â·,trail:Â·,extends:â€¦
    endif
else
    if v:version >= 700
        set list listchars=tab:>-,trail:.,extends:>,nbsp:_
    else
        set list listchars=tab:>-,trail:.,extends:>
    endif
endif

set tabstop=4       " Tab out 4 characters
set nowrap          " Dont wrap text, what are we MS Word?
set winaltkeys=no   " Ignore win keys

" Selective case insensitivity
if has("autocmd")
    autocmd BufEnter *
                \ if &filetype == "cpp" |
                \     set noignorecase noinfercase |
                \ else |
                \     set ignorecase infercase |
                \ endif
else
    set ignorecase
    set infercase
endif

" Searching Stuff
set showfulltag     " Show full tag when doing search completion
set hlsearch        " Higlight found search info
set incsearch       " Do incremental searching
set showmatch       " Hilight matching parens


" No annoying error noises
set noerrorbells
set visualbell t_vb=
if has("autocmd")
    autocmd GUIEnter * set visualbell t_vb=
endif

" Show a few extra lines when scrolling
set scrolloff=3
set sidescrolloff=2

" Use the cool tab complete menu
set wildmenu
set wildignore+=*.o,*~,.lo
set suffixes+=.in,.a

" No icky toolbar, menu or scrollbars in the GUI
if has('gui')
    set guioptions-=m
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
end
color elflord

" folding stuff
if has("folding")
    set expandtab
    set foldmethod=marker
    hi Folded ctermfg=darkgrey ctermbg=NONE
    hi FoldColumn ctermfg=darkgrey ctermbg=NONE
endif

" Syntax when printing
set popt+=syntax:y

" Nice statusbar
set laststatus=1
set statusline=%=%2*0x%-8B\%-14.(%l,%c%V%)\ %<%P

set showcmd         " show us the command we're typing
set showmode        " show us the editing mode
set magic           " I dont remember what this is for

" Filetype Settings
if has ("eval")
    filetype on
    filetype indent on
    filetype plugin indent on
endif

" Nice window title
if has('title') && (has('gui_running') || &title)
    set titlestring=
    set titlestring+=%f\                     " file name
    set titlestring+=%h%m%r%w                " flags
    set titlestring+=\ -\ %{v:progname}      " program name
endif

" Perl Settings
let perl_want_scope_in_variables=1
let perl_extended_vars=1
let perl_include_pod=1
let perl_fold=1
"let perl_fold_blocks=1

set dictionary=/usr/share/dict/words    " Dictionary Completion
set ruler
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\(%5L\)\ %P%)
set key=

"iab <buffer> if if () {<cr>}<Esc>O<Esc>O<BS><Esc>F)i
map <F7> :!perl -c %<CR>
map <F6> :!enscript -G %<CR>

vnoremap <buffer> `( <C-C>`>a`9<Esc>`<i)<Esc>
vnoremap <buffer> `" <C-C>`>a`'<Esc>`<i`'<Esc>
hi Normal guibg=black guifg=grey

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup sh
    "<F5>:  Comment/uncomment current line
        function! ShellCommentUncomment()
            if getline('.') =~ '^#'
                execute("normal |")
                execute("normal x")
                execute(line('.')+1)
            else
                execute("normal |")
                execute("normal i#")
                execute(line('.')+1)
            endif
        endfunction " ShellCommentUncomment()
  augroup END

  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost * if line("'\"") | exe "'\"" | endif
 
 augroup gzip
  " Remove all gzip autocommands
  "au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPost,FileReadPost	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . expand("%:r")

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
  autocmd FileType mail :nmap <F8> :w<CR>:!aspell -e -c %<CR>:e<CR>
 augroup END

" Mason Stuff
augroup Masonfiletype
  au!
  au BufRead,BufNewFile *.mas       set ft=mason
  au BufRead,BufNewFile *.comp      set ft=mason
  au BufRead,BufNewFile *.html      set ft=mason
  au BufRead,BufNewFile syshandler  set ft=mason
  au BufRead,BufNewFile autohandler set ft=mason
  au BufRead,BufNewFile *.autohandler set ft=mason
  au BufRead,BufNewFile viewhandler set ft=mason
  au BufRead,BufNewFile dhandler    set ft=mason
augroup END

  augroup content
    autocmd!

    " Perl
    autocmd BufNewFile *.pl 0put ='use strict;' |
                      \ 0put ='#!/usr/bin/perl -w' |
                      \ norm G

    " Ruby
    autocmd BufNewFile *.rb 0put ='#!/usr/bin/ruby' | set sw=4 sts=4 et tw=80 |
                        \ norm G

    " C++
    "autocmd BufNewFile *.cc 0put ='/* vim: set sw=4 sts=4 et foldmethod=syntax : */' |
    "                    \ 1put ='' | 2put ='' | call setline(3, '#include "' .
    "                    \ substitute(expand("%:t"), ".cc$", ".hh", "") . '"') |
    "                    \ set sw=4 sts=4 et tw=80 | norm G

    " set up syntax highlighting for my e-mail
    au BufRead,BufNewFile .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,/tmp/mutt* :set ft=mail

  augroup END

    " Update .*rc header
    fun! <SID>UpdateRcHeader()
        let l:c=col(".")
        let l:l=line(".")
        1,10s-\(Last update:\).*-\="Last update: ".strftime("%a %b %d %T %Z %Y")-e
        call cursor(l:l, l:c)
    endfun

    " Update header in .vimrc and .bashrc before saving
    autocmd BufWritePre *vimrc  :call <SID>UpdateRcHeader()
    autocmd BufWritePre *bashrc :call <SID>UpdateRcHeader()

    " Always do a full syntax refresh
    autocmd BufEnter * syntax sync fromstart

    " Detect procmailrc
    autocmd BufRead procmailrc :setfiletype procmail

endif

" Mappings ------------------------------------------------>
iab YDATE <C-R>=strftime("%a %b %d %T %Z %Y")<CR>
iab uDD use Data::Dumper;
iab #b /* --------------------------------------------------
iab #e   --------------------------------------------------*/
iab TmP <!-- TMPL_VAR NAME="" -->
iab bang! #!/usr/bin/perl -w

" Add Comments without indenting them.
function! CommentBlock()
    let @z =    "# ---------------------------------------------------------------------- #\n"
    let @z = @z."#                                                                        #\n"
    let @z = @z."# ---------------------------------------------------------------------- #"
    put z
endfunction
iabbr <silent> COMMENT <Esc>:call CommentBlock()<CR><UP><RIGHT>

" Clear lines
noremap <Leader>clr :s/^.*$//<CR>:nohls<CR>
" Pull the following line to the cursor position
noremap <Leader>J :s/\%#\(.*\)\n\(.*\)/\2\1<CR>
" Delete blank lines
noremap <Leader>dbl :g/^$/d<CR>:nohls<CR>
" Enclose each selected line with markers
noremap <Leader>enc :<C-w>execute
            \ substitute(":'<,'>s/^.*/#&#/ \| :nohls", "#", input(">"), "g")<CR>
" Edit something in the current directory
noremap <Leader>ed :e <C-r>=expand("%:p:h")<CR>/<C-d>

" Insert a single char
noremap <Leader>i i<Space><Esc>r
" Split the line
nmap <Leader>n \i<CR>

" map Write to write
nmap :W :w

" remove trailing spaces with F9 key
nmap <f9> :%s/\s\+$//<CR>
vmap <f9>  :s/\s\+$//<CR>

" Run PerlTidy
nmap <f12> :%!perltidy -q

" Comment and uncomment lines
map  <F5> :let @_=ShellCommentUncomment()<CR>
imap <F5> <Esc>:let @_=ShellCommentUncomment()<CR>


" some extra commands for HTML editing
nmap ,h1 _i<h1><ESC>A</h1><ESC>
nmap ,h2 _i<h2><ESC>A</h2><ESC>
nmap ,h3 _i<h3><ESC>A</h3><ESC>
nmap ,h4 _i<h4><ESC>A</h4><ESC>
nmap ,h5 _i<h5><ESC>A</h5><ESC>
nmap ,h6 _i<h6><ESC>A</h6><ESC>
nmap ,hb wbi<b><ESC>ea</b><ESC>bb
nmap ,he wbi<em><ESC>ea</em><ESC>bb
nmap ,hi wbi<i><ESC>ea</i><ESC>bb
nmap ,hu wbi<u><ESC>ea</u><ESC>bb
nmap ,hs wbi<strong><ESC>ea</strong><ESC>bb
nmap ,ht wbi<tt><ESC>ea</tt><ESC>bb
" Toggle Paste on/off
nnoremap \tp :set invpaste paste?<CR>
nmap <F3> \tp
imap <F3> <C-O>\tp
set pastetoggle=<F3>
       " map <F3> \tp<CR>i
       "imap <F3> <Esc>\tp<CR>a
       " noremap \tp :set invpaste paste

" Toggle wrap
" This defines \tf ("toggle format") and <S-F3> to toggle whether lines should
" automatically be wrapped as they are typed: 
nnoremap \tf :if &fo =~ 't' <Bar> set fo-=t <Bar> else <Bar> set fo+=t <Bar>
         \ endif <Bar> set fo?<CR>
nmap <S-F3> \tf
imap <S-F3> <C-O>\tf


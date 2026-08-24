let SessionLoad = 1
let s:cpo_save=&cpo
set cpo&vim
inoremap <silent> <M-k> <Cmd>m .-2==gi
inoremap <silent> <M-j> <Cmd>m .+1==gi
cnoremap <expr> <BS> v:lua.MiniPairs.bs()
inoremap <silent> <expr> <BS> v:lua.MiniPairs.bs()
inoremap <silent> <C-S> <Cmd>w
inoremap <C-W> u
inoremap <C-U> u
nnoremap <silent>  h
nnoremap <silent> <NL> j
nnoremap <silent>  k
nnoremap <silent>  l
nnoremap <silent>  <Cmd>w
xnoremap <silent>  <Cmd>w
snoremap <silent>  <Cmd>w
nmap  d
nnoremap  cm <Cmd>Mason
nnoremap  xT <Cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}
nnoremap  xt <Cmd>Trouble todo toggle
nnoremap  sn <Nop>
nnoremap  bp <Cmd>BufferLineTogglePin
nnoremap  bl <Cmd>BufferLineCloseLeft
nnoremap  br <Cmd>BufferLineCloseRight
nnoremap  bP <Cmd>BufferLineGroupClose ungrouped
nnoremap  as <Cmd>AvanteStop
nnoremap  ar <Cmd>AvanteRefresh
nnoremap  ap <Cmd>AvanteSwitchProvider
nnoremap  an <Cmd>AvanteChatNew
nnoremap  am <Cmd>AvanteModels
nnoremap  ah <Cmd>AvanteHistory
nnoremap  af <Cmd>AvanteFocus
nnoremap  ae <Cmd>AvanteEdit
nnoremap  ac <Cmd>AvanteChat
nnoremap  aa <Cmd>AvanteAsk
nnoremap  at <Cmd>AvanteToggle
nnoremap <silent>  	[ <Cmd>tabprevious
nnoremap <silent>  	d <Cmd>tabclose
nnoremap <silent>  	] <Cmd>tabnext
nnoremap <silent>  		 <Cmd>tabnew
nnoremap <silent>  	f <Cmd>tabfirst
nnoremap <silent>  	o <Cmd>tabonly
nnoremap <silent>  	l <Cmd>tablast
nnoremap <silent>  wd c
nnoremap <silent>  | v
nnoremap <silent>  - s
nnoremap <silent>  qq <Cmd>qa
nnoremap <silent>  fn <Cmd>enew
nnoremap <silent>  l <Cmd>Lazy
nnoremap <silent>  K <Cmd>norm! K
nnoremap <silent>  ur <Cmd>nohlsearch|diffupdate|normal! 
nnoremap <silent>  bD <Cmd>:bd
nnoremap <silent>  ` <Cmd>e #
nnoremap <silent>  bb <Cmd>e #
nmap  E  fE
nmap  e  fe
nnoremap  xX <Cmd>Trouble diagnostics toggle filter.buf=0
nnoremap  xx <Cmd>Trouble diagnostics toggle
nnoremap  xQ <Cmd>Trouble qflist toggle
nnoremap  xL <Cmd>Trouble loclist toggle
nnoremap  cS <Cmd>Trouble lsp toggle
nnoremap  cs <Cmd>Trouble symbols toggle
omap <silent> % <Plug>(MatchitOperationForward)
xmap <silent> % <Plug>(MatchitVisualForward)
nmap <silent> % <Plug>(MatchitNormalForward)
nnoremap & :&&
xnoremap <silent> < <gv
xnoremap <silent> > >gv
xnoremap <silent> <expr> @ mode() ==# 'V' ? ':normal! @'.getcharstr().'' : '@'
nnoremap H <Cmd>BufferLineCyclePrev
nnoremap L <Cmd>BufferLineCycleNext
onoremap <silent> <expr> N 'nN'[v:searchforward]
xnoremap <silent> <expr> N 'nN'[v:searchforward]
nnoremap <silent> <expr> N 'nN'[v:searchforward].'zv'
xnoremap <silent> <expr> Q mode() ==# 'V' ? ':normal! @=reg_recorded()' : 'Q'
nnoremap Y y$
nnoremap [b <Cmd>BufferLineCyclePrev
nnoremap [B <Cmd>BufferLineMovePrev
omap <silent> [% <Plug>(MatchitOperationMultiBackward)
xmap <silent> [% <Plug>(MatchitVisualMultiBackward)
nmap <silent> [% <Plug>(MatchitNormalMultiBackward)
nnoremap ]B <Cmd>BufferLineMoveNext
nnoremap ]b <Cmd>BufferLineCycleNext
omap <silent> ]% <Plug>(MatchitOperationMultiForward)
xmap <silent> ]% <Plug>(MatchitVisualMultiForward)
nmap <silent> ]% <Plug>(MatchitNormalMultiForward)
xmap a% <Plug>(MatchitVisualTextObject)
nnoremap <silent> gcO OVcx<Cmd>normal gccfxa<BS>
nnoremap <silent> gco oVcx<Cmd>normal gccfxa<BS>
omap <silent> g% <Plug>(MatchitOperationBackward)
xmap <silent> g% <Plug>(MatchitVisualBackward)
nmap <silent> g% <Plug>(MatchitNormalBackward)
xnoremap <silent> <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <silent> <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <silent> <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <silent> <expr> k v:count == 0 ? 'gk' : 'k'
onoremap <silent> <expr> n 'Nn'[v:searchforward]
xnoremap <silent> <expr> n 'Nn'[v:searchforward]
nnoremap <silent> <expr> n 'Nn'[v:searchforward].'zv'
nnoremap <silent> <C-S> <Cmd>w
xnoremap <silent> <C-S> <Cmd>w
vnoremap <silent> <M-k> :execute "'<,'>move '<-" . (v:count1 + 1)gv=gv
vnoremap <silent> <M-j> :execute "'<,'>move '>+" . v:count1gv=gv
nnoremap <silent> <M-k> <Cmd>execute 'move .-' . (v:count1 + 1)==
nnoremap <silent> <M-j> <Cmd>execute 'move .+' . v:count1==
nnoremap <silent> <C-Right> <Cmd>vertical resize +2
nnoremap <silent> <C-Left> <Cmd>vertical resize -2
nnoremap <silent> <C-Down> <Cmd>resize -2
nnoremap <silent> <C-Up> <Cmd>resize +2
nnoremap <silent> <C-K> k
nnoremap <silent> <C-J> j
nnoremap <silent> <C-H> h
xnoremap <silent> <expr> <Up> v:count == 0 ? 'gk' : 'k'
nnoremap <silent> <expr> <Up> v:count == 0 ? 'gk' : 'k'
xnoremap <silent> <expr> <Down> v:count == 0 ? 'gj' : 'j'
nnoremap <silent> <expr> <Down> v:count == 0 ? 'gj' : 'j'
nnoremap <Plug>PlenaryTestFile :lua require('plenary.test_harness').test_file(vim.fn.expand("%:p"))
xmap <silent> <Plug>(MatchitVisualTextObject) <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMultiForward)
onoremap <silent> <Plug>(MatchitOperationMultiForward) :call matchit#MultiMatch("W",  "o")
onoremap <silent> <Plug>(MatchitOperationMultiBackward) :call matchit#MultiMatch("bW", "o")
xnoremap <silent> <Plug>(MatchitVisualMultiForward) :call matchit#MultiMatch("W",  "n")m'gv``
xnoremap <silent> <Plug>(MatchitVisualMultiBackward) :call matchit#MultiMatch("bW", "n")m'gv``
nnoremap <silent> <Plug>(MatchitNormalMultiForward) :call matchit#MultiMatch("W",  "n")
nnoremap <silent> <Plug>(MatchitNormalMultiBackward) :call matchit#MultiMatch("bW", "n")
onoremap <silent> <Plug>(MatchitOperationBackward) :call matchit#Match_wrapper('',0,'o')
onoremap <silent> <Plug>(MatchitOperationForward) :call matchit#Match_wrapper('',1,'o')
xnoremap <silent> <Plug>(MatchitVisualBackward) :call matchit#Match_wrapper('',0,'v')m'gv``
xnoremap <silent> <Plug>(MatchitVisualForward) :call matchit#Match_wrapper('',1,'v'):if col("''") != col("$") | exe ":normal! m'" | endifgv``
nnoremap <silent> <Plug>(MatchitNormalBackward) :call matchit#Match_wrapper('',0,'n')
nnoremap <silent> <Plug>(MatchitNormalForward) :call matchit#Match_wrapper('',1,'n')
nmap <C-W><C-D> d
snoremap <silent> <C-S> <Cmd>w
nnoremap <silent> <C-L> l
inoremap <silent> <expr>  v:lua.MiniPairs.cr()
inoremap <silent>  <Cmd>w
inoremap  u
inoremap  u
cnoremap <expr> " v:lua.MiniPairs.closeopen('""', "^[^\\]")
inoremap <expr> " v:lua.MiniPairs.closeopen('""', "^[^\\]")
cnoremap <expr> ' v:lua.MiniPairs.closeopen("''", "^[^%a\\]")
inoremap <expr> ' v:lua.MiniPairs.closeopen("''", "^[^%a\\]")
cnoremap <expr> ( v:lua.MiniPairs.open("()", "^[^\\]")
inoremap <expr> ( v:lua.MiniPairs.open("()", "^[^\\]")
cnoremap <expr> ) v:lua.MiniPairs.close("()", "^[^\\]")
inoremap <expr> ) v:lua.MiniPairs.close("()", "^[^\\]")
inoremap <silent> , ,u
inoremap <silent> . .u
inoremap <silent> ; ;u
cnoremap <expr> [ v:lua.MiniPairs.open("[]", "^[^\\]")
inoremap <expr> [ v:lua.MiniPairs.open("[]", "^[^\\]")
cnoremap <expr> ] v:lua.MiniPairs.close("[]", "^[^\\]")
inoremap <expr> ] v:lua.MiniPairs.close("[]", "^[^\\]")
cnoremap <expr> ` v:lua.MiniPairs.closeopen("``", "^[^\\]")
inoremap <expr> ` v:lua.MiniPairs.closeopen("``", "^[^\\]")
cnoremap <expr> { v:lua.MiniPairs.open("{}", "^[^\\]")
inoremap <expr> { v:lua.MiniPairs.open("{}", "^[^\\]")
cnoremap <expr> } v:lua.MiniPairs.close("{}", "^[^\\]")
inoremap <expr> } v:lua.MiniPairs.close("{}", "^[^\\]")
let &cpo=s:cpo_save
unlet s:cpo_save
set autowrite
set clipboard=unnamedplus
set cmdheight=0
set completeopt=menu,menuone,noselect
set confirm
set expandtab
set fillchars=diff:â•±,eob:\ ,fold:\ ,foldclose:ï‘ ,foldopen:ï‘¼,foldsep:\ 
set formatexpr=v:lua.LazyVim.format.formatexpr()
set formatoptions=jcroqlnt
set grepformat=%f:%l:%c:%m
set grepprg=rg\ --vimgrep
set ignorecase
set jumpoptions=view
set laststatus=3
set noloadplugins
set mouse=a
set packpath=/usr/share/nvim/runtime
set pumblend=10
set pumheight=10
set noruler
set runtimepath=~/.config/nvim,~/.local/share/nvim/site,~/.local/share/nvim/lazy/lazy.nvim,~/.local/share/nvim/lazy/friendly-snippets,~/.local/share/nvim/lazy/blink.cmp,~/.local/share/nvim/lazy/nvim-ts-autotag,~/.local/share/nvim/lazy/nvim-lint,~/.local/share/nvim/lazy/mason-lspconfig.nvim,~/.local/share/nvim/lazy/mason.nvim,~/.local/share/nvim/lazy/nvim-lspconfig,~/.local/share/nvim/lazy/todo-comments.nvim,~/.local/share/nvim/lazy/gitsigns.nvim,~/.local/share/nvim/lazy/persistence.nvim,~/.local/share/nvim/lazy/nvim-treesitter-textobjects,~/.local/share/nvim/lazy/noice.nvim,~/.local/share/nvim/lazy/nvim-treesitter,~/.local/share/nvim/lazy/lualine.nvim,~/.local/share/nvim/lazy/flash.nvim,~/.local/share/nvim/lazy/which-key.nvim,~/.local/share/nvim/lazy/ts-comments.nvim,~/.local/share/nvim/lazy/mini.ai,~/.local/share/nvim/lazy/mini.pairs,~/.local/share/nvim/lazy/bufferline.nvim,~/.local/share/nvim/lazy/mini.icons,~/.local/share/nvim/lazy/trouble.nvim,~/.local/share/nvim/lazy/nui.nvim,~/.local/share/nvim/lazy/plenary.nvim,~/.local/share/nvim/lazy/snacks.nvim,~/.local/share/nvim/lazy/tokyonight.nvim,~/.local/share/nvim/lazy/LazyVim,/usr/share/nvim/runtime,/usr/share/nvim/runtime/pack/dist/opt/netrw,/usr/share/nvim/runtime/pack/dist/opt/matchit,/usr/lib64/nvim,~/.local/state/nvim/lazy/readme,~/.local/share/nvim/lazy/mason-lspconfig.nvim/after
set scrolloff=4
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,terminal,options
set shiftround
set shiftwidth=2
set shortmess=TOICltcFWo
set noshowmode
set showtabline=0
set sidescrolloff=8
set smartcase
set smartindent
set splitbelow
set splitkeep=screen
set splitright
set statusline=%#lualine_transparent#
set tabline=%!v:lua.nvim_bufferline()
set tabstop=2
set termguicolors
set timeoutlen=300
set undofile
set undolevels=10000
set updatetime=200
set virtualedit=block
set wildmode=longest:full,full
set window=30
set winminwidth=5
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
doautoall SessionLoadPre
silent only
silent tabonly
cd ~
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess+=aoO
badd +30 term://~//12596:/usr/bin/fish
argglobal
%argdel
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
if bufexists(fnamemodify("term://~//12596:/usr/bin/fish", ":p")) | buffer term://~//12596:/usr/bin/fish | else | edit term://~//12596:/usr/bin/fish | endif
if &buftype ==# 'terminal'
  silent file term://~//12596:/usr/bin/fish
endif
setlocal keymap=
setlocal noarabic
setlocal autoindent
setlocal nobinary
setlocal nobreakindent
setlocal breakindentopt=
setlocal bufhidden=
setlocal buflisted
setlocal buftype=terminal
setlocal busy=0
setlocal nocindent
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal cinoptions=
setlocal cinscopedecls=public,protected,private
setlocal cinwords=if,else,while,do,for,switch
setlocal colorcolumn=
setlocal comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,fb:â€¢
setlocal commentstring=
setlocal complete=.,w,b,u,t
setlocal completefunc=
setlocal completeslash=
setlocal concealcursor=
set conceallevel=2
setlocal conceallevel=2
setlocal nocopyindent
setlocal nocursorbind
setlocal nocursorcolumn
set cursorline
setlocal cursorline
setlocal cursorlineopt=both
setlocal nodiff
setlocal eventignorewin=
setlocal expandtab
if &filetype != ''
setlocal filetype=
endif
setlocal fixendofline
setlocal foldcolumn=0
setlocal foldenable
setlocal foldexpr=0
setlocal foldignore=#
set foldlevel=99
setlocal foldlevel=99
setlocal foldmarker={{{,}}}
set foldmethod=indent
setlocal foldmethod=indent
setlocal foldminlines=1
setlocal foldnestmax=20
set foldtext=
setlocal foldtext=
setlocal formatexpr=v:lua.LazyVim.format.formatexpr()
setlocal formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*
setlocal formatoptions=jcroqlnt
setlocal iminsert=0
setlocal imsearch=-1
setlocal includeexpr=
setlocal indentexpr=
setlocal indentkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal noinfercase
setlocal iskeyword=@,48-57,_,192-255
setlocal lhistory=10
set linebreak
setlocal linebreak
setlocal nolisp
setlocal lispoptions=
set list
setlocal nolist
setlocal matchpairs=(:),{:},[:]
setlocal modeline
setlocal nomodifiable
setlocal nrformats=bin,hex
set number
setlocal nonumber
setlocal numberwidth=4
setlocal omnifunc=
setlocal nopreserveindent
setlocal nopreviewwindow
setlocal quoteescape=\\
setlocal noreadonly
set relativenumber
setlocal norelativenumber
setlocal norightleft
setlocal rightleftcmd=search
setlocal scrollback=10000
setlocal noscrollbind
setlocal shiftwidth=2
set signcolumn=yes
setlocal signcolumn=no
setlocal smartindent
set smoothscroll
setlocal smoothscroll
setlocal softtabstop=0
setlocal nospell
setlocal spellcapcheck=[.?!]\\_[\\])'\"\\t\ ]\\+
setlocal spellfile=
setlocal spelllang=en
setlocal spelloptions=
set statuscolumn=%!v:lua.LazyVim.statuscolumn()
setlocal statuscolumn=%!v:lua.LazyVim.statuscolumn()
setlocal statusline=%#lualine_a_command#\ COMMAND\ %#lualine_transitional_lualine_a_command_to_lualine_c_normal#î‚°%<%#lualine_c_normal#\ term:/â€¦/bin/%#lualine_c_16_LV_Bold_command#fish%#lualine_c_normal#\ %#lualine_c_normal#%=%#lualine_x_8_command#\ :\ %#lualine_c_normal#î‚³%#lualine_x_11_command#\ ï’‡\ 25\ %#lualine_transitional_lualine_b_command_to_lualine_x_11_command#î‚²%#lualine_b_command#\ Bot\ %#lualine_b_command#\ 30:21\ %#lualine_transitional_lualine_a_command_to_lualine_b_command#î‚²%#lualine_a_command#\ ïº\ 13:42\ 
setlocal suffixesadd=
setlocal noswapfile
setlocal synmaxcol=3000
if &syntax != ''
setlocal syntax=
endif
setlocal tabstop=2
setlocal tagfunc=
setlocal textwidth=0
setlocal undofile
setlocal undolevels=-1
setlocal varsofttabstop=
setlocal vartabstop=
setlocal winblend=0
setlocal nowinfixbuf
setlocal nowinfixheight
setlocal nowinfixwidth
setlocal winhighlight=StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC
set nowrap
setlocal nowrap
setlocal wrapmargin=0
let s:l = 30 - ((29 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 30
normal! 021|
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
set shortmess=TOICltcFWo
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :

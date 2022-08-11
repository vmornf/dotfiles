" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" StatusLine
autocmd BufReadPost,BufRead,BufNewFile,BufWritePost *.* :call GetStatusLine()
autocmd BufReadPost,BufRead,BufNewFile,BufWritePost *.wiki,*.txt :call GetStatusLineText()

" Toogle statusbar
nnoremap <leader>b :call ToggleHiddenAll()<CR>


" Remap for rename current word
nmap <F2> <Plug>(coc-rename)
" Remap for format selected region
xmap <leader>cf <Plug>(coc-format-selected)
nmap <leader>cf <Plug>(coc-format-selected)
xmap <leader>cg mcggVG<Plug>(coc-format-selected)'c
nmap <leader>cg mcggVG<Plug>(coc-format-selected)'c
" Show all diagnostics using CocList
nnoremap <silent> <leader>cd  :<C-u>CocList diagnostics<cr>
" Prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Function for toggling the bottom statusbar:
let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction

set statusline=
set statusline=
set laststatus=2
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set statusline+=%#Difftext#
set statusline+=\ %M "track if changes has been made to file
set statusline+=\ %y "show filetype
set statusline+=\ %r "ReadOnly flag
set statusline+=\ %F "show full path to file
set statusline+=%= "right side settings
set statusline+=%#DiffChange#
set statusline+=\ %{wordcount().words}\ words\ \| "display wordcount
set statusline+=\ %c:%l/%L\  "display column and line pos

" Start vim without statusbar
let s:hidden_all = 1
set noshowmode
set noruler
set laststatus=0
set noshowcmd

" Function for showing status line for text documents
function! GetStatusLineText()
    if s:hidden_all == 0
		set statusline=
		set statusline=
		set laststatus=2
		set statusline+=%#warningmsg#
		set statusline+=%{SyntasticStatuslineFlag()}
		set statusline+=%*
		set statusline+=%#Difftext#
		set statusline+=\ %M "track if changes has been made to file
		set statusline+=\ %y "show filetype
		set statusline+=\ %r "ReadOnly flag
		set statusline+=\ %F "show full path to file
		set statusline+=%= "right side settings
		set statusline+=%#DiffChange#
		set statusline+=\ %{wordcount().words}\ words\ \| "display wordcount
		set statusline+=\ %c:%l/%L\  "display column and line pos
	endif
endfunction

" Function for showing status line for other files
function! GetStatusLine()
    if s:hidden_all == 0
		set statusline=
		set statusline=
		set laststatus=2
		set statusline+=%#warningmsg#
		set statusline+=%{SyntasticStatuslineFlag()}
		set statusline+=%*
		set statusline+=%#Difftext#
		set statusline+=\ %M "track if changes has been made to file
		set statusline+=\ %y "show filetype
		set statusline+=\ %r "ReadOnly flag
		set statusline+=\ %F "show full path to file
		set statusline+=%= "right side settings
		set statusline+=%#DiffChange#
		set statusline+=\ %c:%l/%L\  "display column and line pos
	endif
endfunction

" If on laptop (set specific settings for my laptop which runs arch linux)
if !empty(glob("~/isLinux"))
	" Function for compiling code
	func! CompileRun()
		exec "w"
		if &filetype == 'c'
			exec "!gcc % && ./a.out"
		elseif &filetype == 'cpp'
			exec "!g++ -pthread % -o %<"
			exec "!./%:r"
		elseif &filetype == 'java'
			"exec "!java -cp %:p:h %:t:r"
			exec "!java %"
		elseif &filetype == 'sh'
			exec "!time bash %"
		elseif &filetype == 'python'
			exec "!python3 %"
		elseif &filetype == 'html'
			exec "!firefox % &"
		elseif &filetype == 'javascript'
			exec "!node %"
		elseif &filetype == 'jsx'
			exec "!node %"
		elseif &filetype == 'typescript'
			exec "!node %"
		elseif &filetype == 'go'
			exec "!go build %<"
			exec "!time go run %"
		elseif &filetype == 'mkd'
			exec "!~/.vim/markdown.pl % > %.html &"
			exec "!firefox %.html &"
		elseif &filetype == 'cs'
			exec "!mcs % && mono ./%:t:r.exe"
		endif
	endfunc
else
	let g:python3_host_prog='~\anaconda3\envs\pynvim\python.exe'
	" set guifont=Consolas:h10
	" :winpos -8 -1
	set lines=48
	set columns=210
	set lines=999" cumns=999 "set fullscreen
	set tw=235
	imap <C-v> <C-r>"+p
	noremap <M-m> :tabe $myvimrc<cr>
	nnoremap <M-n> :FZF c:/<cr>
	" Copy everything from file into clipboard
	inoremap <C-a> <Esc>gg"*yG
	" Copy selection to clipboard
	noremap <C-c> "*y
	colorscheme hybrid
	"colorscheme gruvbox

	func! CompileRun()
		exec "w"
		if &filetype == 'c'
			exec "!gcc % -o %<"
			exec "!%:r.exe"
			"exec "!time ./%<"
		elseif &filetype == 'cpp'
			"exec "!g++ % -o %< -lbgi -lgdi32 -lcomdlg32 -luuid -loleaut32 -lole32"
			exec "!g++ % -o %<"
			exec "!%:r.exe"
			"exec "!time ./%<"
		elseif &filetype == 'java'
			exec "!javac %"
			exec "!java -cp %:p:h %:t:r"
		elseif &filetype == 'sh'
			exec "!time bash %"
		elseif &filetype == 'python'
			exec "!python %"
		elseif &filetype == 'html'
			exec "!firefox % &"
		elseif &filetype == 'javascript'
			exec "!node %"
		elseif &filetype == 'jsx'
			exec "!node %"
		elseif &filetype == 'typescript'
			exec "!node %"
		elseif &filetype == 'go'
			exec "!go build %<"
			exec "!time go run %"
		elseif &filetype == 'mkd'
			exec "!~/.vim/markdown.pl % > %.html &"
			exec "!firefox %.html &"
		elseif &filetype == 'cs'
			exec "!csc %"
			exec "!%:r.exe"
		endif
	endfunc
endif

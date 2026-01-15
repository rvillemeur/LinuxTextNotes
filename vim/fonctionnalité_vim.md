# grande fonction de VIM

## 1. Édition de texte
###1.1 Mode Normal
#### 1.1.1 Déplacement (motion)
#### 1.1.2 Global motion
### 1.2 Mode insert
#### 1.2.1 Mode Ctrl-X pour completion de texte
#### 1.2.2 caractères speciaux en mode insert (literal, digraph, etc.)
### 1.3 Mode Visuel
:star		:*		use the last Visual area, like :'<,'>
### 1.4 Mode Commande
:		:		nothing
:range	:{range}	go to last line in {range}
:!		:!		filter lines or execute an external command
:!!		:!!		repeat last ":!" command
:#		:#		same as ":number"
:&		:&		repeat last ":substitute"
:<		:<		shift lines one 'shiftwidth' left
:=		:=		print the last line number
:>		:>		shift lines one 'shiftwidth' right
:Print	:P[rint]	print lines
:X		:X		ask for encryption key
:append	:a[ppend]	append text
:change	:c[hange]	replace a line or series of lines
:cd		:cd		change directory
:center	:ce[nter]	format lines at the center
:changes	:changes	print the change list
:chdir	:chd[ir]	change directory
:copy		:co[py]		copy lines
:ascii	:as[cii]	print ascii value of character under the cursor
:delete	:d[elete]	delete lines

#### 1.4.1 search pattern

#### 1.4.1. range pattern
### 1.5 Mode de remplacement de text
### 1.6 Mode Binaire
## 2. Modification de texte via le mode Ex:
## 3. Colorisation syntaxique.
:colorscheme	:colo[rscheme]	load a specific color scheme

## 4. Mapping de commande
:cmap		:cm[ap]		like ":map" but for Command-line mode
:cmapclear	:cmapc[lear]	clear all mappings for Command-line mode
:cnoremap	:cno[remap]	like ":noremap" but for Command-line mode
:cunmap	:cu[nmap]	like ":unmap" but for Command-line mode

##5. Option de commande
##6. Onglet multiple (Tab management)
##7. Gestion des fenêtres (window).
:aboveleft	:abo[veleft]	make split window appear left or above
:all		:al[l]		open a window for each file in the argument list
:belowright	:bel[owright]	make split window appear right or below
:botright	:bo[tright]	make split window appear at bottom or far right
:close	:clo[se]	close current window'
:sbuffer	:sb[uffer]	split window and go to specific file in the buffer list
:sbNext	:sbN[ext]	split window and go to previous file in the buffer list
:sball	:sba[ll]	open a window for each file in the buffer list
:sbfirst	:sbf[irst]	split window and go to first file in the buffer list
:sblast	:sbl[ast]	split window and go to last file in buffer list
:sbmodified	:sbm[odified]	split window and go to modified file in the buffer list
:sbnext	:sbn[ext]	split window and go to next file in the buffer list
:sbprevious	:sbp[revious]	split window and go to previous file in the buffer list
:sbrewind	:sbr[ewind]	split window and go to first file in the buffer list
:sprevious	:spr[evious]	split window and go to previous file in the argument list
:srewind	:sre[wind]	split window and go to first file in the argument list
:drop		:dr[op]		jump to window editing file or edit file in current window
:horizontal	:hor[izontal]	following window command work horizontally
:isplit	:isp[lit]	split window and jump to definition of identifier
:leftabove	:lefta[bove]	make split window appear left or above
:loadview	:lo[adview]	load view for current window from a file

###7.1 Modeline

###7.2 Quickfix & Error window
:cNext	:cN[ext]	go to previous error
:cNfile	:cNf[ile]	go to last error in previous file
:cabove	:cabo[ve]	go to error above current line
:caddbuffer	:cad[dbuffer]	add errors from buffer
:caddexpr	:cadde[xpr]	add errors from expr
:caddfile	:caddf[ile]	add error message to current quickfix list
:cafter	:caf[ter]	go to error after current cursor
:cbefore	:cbef[ore]	go to error before current cursor
:cbelow	:cbel[ow]	go to error below current line
:cbottom	:cbo[ttom]	scroll to the bottom of the quickfix window
:cbuffer	:cb[uffer]	parse error messages and jump to first error
:cc		:cc		go to specific error
:cclose	:ccl[ose]	close quickfix window
:cdo		:cdo		execute command in each valid error list entry
:cfdo		:cfd[o]		execute command in each file in error list
:cexpr	:cex[pr]	read errors from expr and jump to first
:cfile	:cf[ile]	read file with error messages and jump to first
:cfirst	:cfir[st]	go to the specified error, default first one
:cgetbuffer	:cgetb[uffer]	get errors from buffer
:cgetexpr	:cgete[xpr]	get errors from expr
:cgetfile	:cg[etfile]	read file with error messages
:chistory	:chi[story]	list the error lists
:clast	:cla[st]	go to the specified error, default last one
:clearjumps	:cle[arjumps]	clear the jump list
:clist	:cl[ist]	list all errors
:cnext	:cn[ext]	go to next error
:cnewer	:cnew[er]	go to newer error list
:cnfile	:cnf[ile]	go to first error in next file
:colder	:col[der]	go to older error list
:copen	:cope[n]	open quickfix window
:cprevious	:cp[revious]	go to previous error
:cpfile	:cpf[ile]	go to last error in previous file
:crewind	:cr[ewind]	go to the specified error, default first one
:cwindow	:cw[indow]	open or close quickfix window

### location window
:lbottom	:lbo[ttom]	scroll to the bottom of the location window
:llist	:lli[st]	list all locations
:lhistory	:lhi[story]	list the location lists
:ll		:ll		go to specific location
:llast	:lla[st]	go to the specified location, default last one
:lnext	:lne[xt]	go to next location
:lnewer	:lnew[er]	go to newer location list
:lnfile	:lnf[ile]	go to first location in next file
:lhelpgrep	:lh[elpgrep]	like ":helpgrep" but uses location list
:lNext	:lN[ext]	go to previous entry in location list
:labove	:lab[ove]	go to location above current line
:laddfile	:laddf[ile]	add locations to current location list
:lafter	:laf[ter]	go to location after current cursor
:lbefore	:lbef[ore]	go to location before current cursor
:lbelow	:lbel[ow]	go to location below current line
:lcscope	:lcs[cope]	like ":cscope" but uses location list
:ldo		:ld[o]		execute command in valid location list entries
:lfdo		:lfd[o]		execute command in each file in location list
:lbuffer	:lb[uffer]	parse locations and jump to first location
:laddexpr	:lad[dexpr]	add locations from expr
:laddbuffer	:laddb[uffer]	add locations from buffer
:lexpr	:lex[pr]	read locations from expr and jump to first
:lfile	:lf[ile]	read file with locations and jump to first
:lfirst	:lfir[st]	go to the specified location, default first one
:lgetbuffer	:lgetb[uffer]	get locations from buffer
:lgetexpr	:lgete[xpr]	get locations from expr
:lgetfile	:lg[etfile]	read file with locations
:lolder	:lol[der]	go to older location list
:lopen	:lope[n]	open location window
:lprevious	:lp[revious]	go to previous location
:lpfile	:lpf[ile]	go to last location in previous file
:lrewind	:lr[ewind]	go to the specified location, default first one
:ltag		:lt[ag]		jump to tag and add matching tags to the location list
:lwindow	:lw[indow]	open or close location window
:lclose	:lcl[ose]	close location window

###7.3 commande line 
##8. Édition de fichiers et de buffers multiples.
:args		:ar[gs]		print the argument list
:argadd	:arga[dd]	add items to the argument list
:argdedupe	:argded[upe]	remove duplicates from the argument list
:argdelete	:argd[elete]	delete items from the argument list
:argedit	:arge[dit]	add item to the argument list and edit it
:argdo	:argdo		do a command on all items in the argument list
:argglobal	:argg[lobal]	define the global argument list
:arglocal	:argl[ocal]	define a local argument list
:argument	:argu[ment]	go to specific file in the argument list
:Next		:N[ext]		go to previous file in the argument list
:buffer	:b[uffer]	go to specific buffer in the buffer list
:bNext	:bN[ext]	go to previous buffer in the buffer list
:ball		:ba[ll]		open a window for each buffer in the buffer list
:badd		:bad[d]		add buffer to the buffer list
:balt		:balt		like ":badd" but also set the alternate file
:bdelete	:bd[elete]	remove a buffer from the buffer list
:blast	:bl[ast]	go to last buffer in the buffer list
:bmodified	:bm[odified]	go to next buffer in the buffer list that has been modified
:bnext	:bn[ext]	go to next buffer in the buffer list
:bfirst	:bf[irst]	go to first buffer in the buffer list
:bprevious	:bp[revious]	go to previous buffer in the buffer list
:brewind	:br[ewind]	go to first buffer in the buffer list
:bufdo	:bufdo		execute command in each listed buffer
:buffers	:buffers	list all files in the buffer list
:bunload	:bun[load]	unload a specific buffer
:bwipeout	:bw[ipeout]	really delete a buffer
:checkpath	:che[ckpath]	list included files
:checktime	:checkt[ime]	check timestamp of loaded buffers
:browse	:bro[wse]	use file selection dialog

##9. Folding
:fold		:fo[ld]		create a fold
:foldclose	:foldc[lose]	close folds
:folddoopen	:foldd[oopen]	execute command on lines not in a closed fold
:folddoclosed	:folddoc[losed]	execute command on lines in a closed fold
:foldopen	:foldo[pen]	open folds

##10. scripting
:break	:brea[k]	break out of while loop
:breakadd	:breaka[dd]	add a debugger breakpoint
:breakdel	:breakd[el]	delete a debugger breakpoint
:breaklist	:breakl[ist]	list debugger breakpoints
:call		:cal[l]		call a function
:catch	:cat[ch]	part of a :try command
:class	:class		start of a class specification
:continue	:con[tinue]	go back to :while
:confirm	:conf[irm]	prompt user when confirmation required
:const	:cons[t]	create a variable as a constant
:debug	:deb[ug]	run a command in debugging mode
:debuggreedy	:debugg[reedy]	read debug mode commands from normal input
:def		:def		define a Vim9 user function
:defcompile	:defc[ompile]	compile Vim9 user functions in current script
:defer	:defer		call function when current function is done
:delfunction	:delf[unction]	delete a user function
:disassemble	:disa[ssemble]	disassemble Vim9 user function
:djump	:dj[ump]	jump to #define
:else		:el[se]		part of an :if command
:elseif	:elsei[f]	part of an :if command
:endclass	:endclass	end of a class specification
:enddef	:enddef		end of a user function started with :def
:endif	:en[dif]	end previous :if
:endfor	:endfo[r]	end previous :for
:endfunction	:endf[unction]	end of a user function started with :function
:endtry	:endt[ry]	end previous :try
:endwhile	:endw[hile]	end previous :while
:echo		:ec[ho]		echoes the result of expressions
:echoconsole	:echoc[onsole]	like :echomsg but write to stdout
:echoerr	:echoe[rr]	like :echo, show like an error and use history
:echohl	:echoh[l]	set highlighting for echo commands
:echomsg	:echom[sg]	same as :echo, put message in history
:echon	:echon		same as :echo, but without <EOL>
:echowindow	:echow[indow]	same as :echomsg, but use a popup window
:final	:final		declare an immutable variable in Vim9
:finally	:fina[lly]	part of a :try command
:finish	:fini[sh]	quit sourcing a Vim script
:for		:for		for loop
:function	:fu[nction]	define a user function
:eval		:ev[al]		evaluate an expression and discard the result
:execute	:exe[cute]	execute result of expressions
:exit		:exi[t]		same as ":xit"
:export	:exp[ort]	Vim9: export an item from a script
:scriptnames	:scr[iptnames]	list names of all sourced Vim scripts
:scriptencoding :scripte[ncoding]  encoding used in sourced Vim script
:scriptversion  :scriptv[ersion]   version of Vim script used

### python sripting
:py3		:py3		execute Python 3 command
:python3	:python3	same as :py3
:py3do	:py3d[o]	execute Python 3 command for each line
:py3file	:py3f[ile]	execute Python 3 script file
:python	:py[thon]	execute Python command
:pydo		:pyd[o]		execute Python command for each line
:pyfile	:pyf[ile]	execute Python script file
:pyx		:pyx		execute python_x command
:pythonx	:pythonx	same as :pyx
:pyxdo	:pyxd[o]	execute python_x command for each line
:pyxfile	:pyxf[ile]	execute python_x script file

### lua scriptiong
:lua		:lua		execute Lua command
:luado	:luad[o]	execute Lua command for each line
:luafile	:luaf[ile]	execute Lua script file

### perl scripting
:perldo	:perld[o]	execute Perl command for each line
:perl		:pe[rl]		execute Perl command

### ruby scripting
:ruby		:rub[y]		execute Ruby command
:rubydo	:rubyd[o]	execute Ruby command for each line
:rubyfile	:rubyf[ile]	execute Ruby script file

##11. autocmd
:autocmd	:au[tocmd]	enter or show autocommands
:augroup	:aug[roup]	select the autocommand group to use
:doautocmd	:do[autocmd]	apply autocommands to current buffer
:doautoall	:doautoa[ll]	apply autocommands for all loaded buffers
:noautocmd	:noa[utocmd]	following commands don't trigger autocommands

##12. terminal
##13. Marquage de texte (Mark)
##14. Abbréviations
:abbreviate	:ab[breviate]	enter abbreviation
:abclear	:abc[lear]	remove all abbreviations
:cabbrev	:ca[bbrev]	like ":abbreviate" but for Command-line mode
:cabclear	:cabc[lear]	clear all abbreviations for Command-line mode
:cnoreabbrev	:cnorea[bbrev]	like ":noreabbrev" but for Command-line mode
:cunabbrev	:cuna[bbrev]	like ":unabbrev" but for Command-line mode
:iabbrev	:ia[bbrev]	like ":abbrev" but for Insert mode
:inoreabbrev	:inorea[bbrev]	like ":noreabbrev" but for Insert mode
:iunabbrev	:iuna[bbrev]	like ":unabbrev" but for Insert mode
:noreabbrev	:norea[bbrev]	enter an abbreviation that will not be
:unabbreviate	:una[bbreviate]	remove abbreviation

##15. Tag integration
##16. Misk
:@		:@		execute contents of a register
:@@		:@@		repeat the previous ":@"
:behave	:be[have]	set mouse and selection behavior

##17. Menu
:amenu	:am[enu]	enter new menu item for all modes
:anoremenu	:an[oremenu]	enter a new menu for all modes that will not
:aunmenu	:aun[menu]	remove menu for all modes
:cmenu	:cme[nu]	add menu for Command-line mode
:cnoremenu	:cnoreme[nu]	like ":noremenu" but for Command-line mode
:cunmenu	:cunme[nu]	remove menu for Command-line mode


##18. integration avec les outils de programmation
:compiler	:comp[iler]	do settings for a specific compiler
:cscope	:cs[cope]	execute cscope command
:cstag	:cst[ag]	use cscope to jump to a tag
:lmake	:lmak[e]	execute external command 'makeprg' and parse error messages

##19. Marks
:delmarks	:delm[arks]	delete marks


##20. Command
:command	:com[mand]	create user-defined command
:comclear	:comc[lear]	clear all user-defined commands
:delcommand	:delc[ommand]	delete user-defined command

##21. diff
:diffupdate	:dif[fupdate]	update 'diff' buffers
:diffget	:diffg[et]	remove differences in current buffer
:diffoff	:diffo[ff]	switch off diff mode
:diffpatch	:diffp[atch]	apply a patch and show differences
:diffput	:diffpu[t]	remove differences in other buffer
:diffsplit	:diffs[plit]	show differences with another file
:diffthis	:diffthis	make current window a diff window

##22. registers
:display	:di[splay]	display registers
:put		:pu[t]		insert contents of register in the text
:redir	:redi[r]	redirect messages to a file or register
:registers	:reg[isters]	display the contents of registers
:yank		:y[ank]		yank lines into a register

##23. spell checking
:mkspell	:mksp[ell]	produce .spl spell file
:spelldump	:spelld[ump]	split window and fill with all correct words
:spellgood	:spe[llgood]	add good word for spelling
:spellinfo	:spelli[nfo]	show info about loaded spell files
:spellrare	:spellra[re]	add rare word for spelling
:spellrepall	:spellr[epall]	replace all bad words like last z=
:spellundo	:spellu[ndo]	remove good or bad word
:spellwrong	:spellw[rong]	add spelling mistake

##24. internal help system
:help		:h[elp]		open a help window
:helpclose	:helpc[lose]	close one help window
:helpfind	:helpf[ind]	dialog to open a help window
:helpgrep	:helpg[rep]	like ":grep" but searches help files
:helptags	:helpt[ags]	generate help tags for a directory


## not sorted yet
:cquit	:cq[uit]	quit Vim with an error code

:digraphs	:dig[raphs]	show or enter digraphs
:dl		:dl		short for :delete with the 'l' flag
:dlist	:dli[st]	list #defines
:dp		:d[elete]p	short for :delete with the 'p' flag
:dsearch	:ds[earch]	list one #define
:dsplit	:dsp[lit]	split window and jump to #define
:edit		:e[dit]		edit a file
:earlier	:ea[rlier]	go to older change, undo
:emenu	:em[enu]	execute a menu by name
:enew		:ene[w]		edit a new, unnamed buffer
:ex		:ex		same as ":edit"
:exusage	:exu[sage]	overview of Ex commands
:file		:f[ile]		show or set the current file name
:files	:files		list all files in the buffer list
:filetype	:filet[ype]	switch file type detection on/off
:filter	:filt[er]	filter output of following command
:find		:fin[d]		find file in 'path' and edit it
:first	:fir[st]	go to the first file in the argument list
:fixdel	:fix[del]	set key code of <Del>
:global	:g[lobal]	execute commands for matching lines
:goto		:go[to]		go to byte in the buffer
:grep		:gr[ep]		run 'grepprg' and jump to first match
:grepadd	:grepa[dd]	like :grep, but append to current list
:gui		:gu[i]		start the GUI
:gvim		:gv[im]		start the GUI
:hardcopy	:ha[rdcopy]	send text to the printer
:highlight	:hi[ghlight]	specify highlighting methods
:hide		:hid[e]		hide current buffer for a command
:history	:his[tory]	print a history list
:insert	:i[nsert]	insert text
:iabclear	:iabc[lear]	like ":abclear" but for Insert mode
:if		:if		execute commands when condition met
:ijump	:ij[ump]	jump to definition of identifier
:ilist	:il[ist]	list lines where identifier matches
:imap		:im[ap]		like ":map" but for Insert mode
:imapclear	:imapc[lear]	like ":mapclear" but for Insert mode
:imenu	:ime[nu]	add menu for Insert mode
:import	:imp[ort]	Vim9: import an item from another script
:inoremap	:ino[remap]	like ":noremap" but for Insert mode
:inoremenu	:inoreme[nu]	like ":noremenu" but for Insert mode
:intro	:int[ro]	print the introductory message
:isearch	:is[earch]	list one line where identifier matches
:iunmap	:iu[nmap]	like ":unmap" but for Insert mode
:iunmenu	:iunme[nu]	remove menu for Insert mode
:join		:j[oin]		join lines
:jumps	:ju[mps]	print the jump list
:k		:k		set a mark
:keepalt	:keepa[lt]	following command keeps the alternate file
:keepmarks	:kee[pmarks]	following command keeps marks where they are
:keepjumps	:keepj[umps]	following command keeps jumplist and marks
:keeppatterns	:keepp[atterns]	following command keeps search pattern history
:lNfile	:lNf[ile]	go to last entry in previous file
:list		:l[ist]		print lines
:last		:la[st]		go to the last file in the argument list
:language	:lan[guage]	set the language (locale)
:later	:lat[er]	go to newer change, redo
:lcd		:lc[d]		change directory locally
:lchdir	:lch[dir]	change directory locally
:left		:le[ft]		left align lines
:legacy	:leg[acy]	make following command use legacy script syntax
:let		:let		assign a value to a variable or option
:lgrep	:lgr[ep]	run 'grepprg' and jump to first match
:lgrepadd	:lgrepa[dd]	like :grep, but append to current list
:lmap		:lm[ap]		like ":map!" but includes Lang-Arg mode
:lmapclear	:lmapc[lear]	like ":mapclear!" but includes Lang-Arg mode
:lnoremap	:ln[oremap]	like ":noremap!" but includes Lang-Arg mode
:loadkeymap	:loadk[eymap]	load the following keymaps until EOF
:lockmarks	:loc[kmarks]	following command keeps marks where they are
:lockvar	:lockv[ar]	lock variables
:ls		:ls		list all buffers
:lunmap	:lu[nmap]	like ":unmap!" but includes Lang-Arg mode
:lvimgrep	:lv[imgrep]	search for pattern in files
:lvimgrepadd	:lvimgrepa[dd]	like :vimgrep, but append to current list
:move		:m[ove]		move lines
:mark		:ma[rk]		set a mark
:make		:mak[e]		execute external command 'makeprg' and parse
				error messages
:map		:map		show or enter a mapping
:mapclear	:mapc[lear]	clear all mappings for Normal and Visual mode
:marks	:marks		list all marks
:match	:mat[ch]	define a match to highlight
:menu		:me[nu]		enter a new menu item
:menutranslate  :menut[ranslate] add a menu translation item
:messages	:mes[sages]	view previously displayed messages
:mkexrc	:mk[exrc]	write current mappings and settings to a file
:mksession	:mks[ession]	write session info to a file
:mkvimrc	:mkv[imrc]	write current mappings and settings to a file
:mkview	:mkvie[w]	write view of current window to a file
:mode		:mod[e]		show or change the screen mode
:mzscheme	:mz[scheme]	execute MzScheme command
:mzfile	:mzf[ile]	execute MzScheme script file
:nbclose	:nbc[lose]	close the current Netbeans session
:nbkey	:nb[key]	pass a key to Netbeans
:nbstart	:nbs[art]	start a new Netbeans session
:next		:n[ext]		go to next file in the argument list
:new		:new		create a new empty window
:nmap		:nm[ap]		like ":map" but for Normal mode
:nmapclear	:nmapc[lear]	clear all mappings for Normal mode
:nmenu	:nme[nu]	add menu for Normal mode
:nnoremap	:nn[oremap]	like ":noremap" but for Normal mode
:nnoremenu	:nnoreme[nu]	like ":noremenu" but for Normal mode
:noremap	:no[remap]	enter a mapping that will not be remapped
:nohlsearch	:noh[lsearch]	suspend 'hlsearch' highlighting remapped
:noremenu	:noreme[nu]	enter a menu that will not be remapped
:normal	:norm[al]	execute Normal mode commands
:noswapfile	:nos[wapfile]	following commands don't create a swap file
:number	:nu[mber]	print lines with line number
:nunmap	:nun[map]	like ":unmap" but for Normal mode
:nunmenu	:nunme[nu]	remove menu for Normal mode
:oldfiles	:ol[dfiles]	list files that have marks in the viminfo file
:open		:o[pen]		start open mode (not implemented)
:omap		:om[ap]		like ":map" but for Operator-pending mode
:omapclear	:omapc[lear]	remove all mappings for Operator-pending mode
:omenu	:ome[nu]	add menu for Operator-pending mode
:only		:on[ly]		close all windows except the current one
:onoremap	:ono[remap]	like ":noremap" but for Operator-pending mode
:onoremenu	:onoreme[nu]	like ":noremenu" but for Operator-pending mode
:options	:opt[ions]	open the options-window
:ounmap	:ou[nmap]	like ":unmap" but for Operator-pending mode
:ounmenu	:ounme[nu]	remove menu for Operator-pending mode
:ownsyntax	:ow[nsyntax]	set new local syntax highlight for this window
:packadd	:pa[ckadd]	add a plugin from 'packpath'
:packloadall	:packl[oadall]	load all packages under 'packpath'
:pclose	:pc[lose]	close preview window
:pedit	:ped[it]	edit file in the preview window
:print	:p[rint]	print lines
:profdel	:profd[el]	stop profiling a function or script
:profile	:prof[ile]	profiling functions and scripts
:promptfind	:pro[mptfind]	open GUI dialog for searching
:promptrepl	:promptr[epl]	open GUI dialog for search/replace
:pop		:po[p]		jump to older entry in tag stack
:popup	:popu[p]	popup a menu by name
:ppop		:pp[op]		":pop" in preview window
:preserve	:pre[serve]	write all text to swap file
:previous	:prev[ious]	go to previous file in argument list
:psearch	:ps[earch]	like ":ijump" but shows match in preview window
:ptag		:pt[ag]		show tag in preview window
:ptNext	:ptN[ext]	:tNext in preview window
:ptfirst	:ptf[irst]	:trewind in preview window
:ptjump	:ptj[ump]	:tjump and show tag in preview window
:ptlast	:ptl[ast]	:tlast in preview window
:ptnext	:ptn[ext]	:tnext in preview window
:ptprevious	:ptp[revious]	:tprevious in preview window
:ptrewind	:ptr[ewind]	:trewind in preview window
:ptselect	:pts[elect]	:tselect and show tag in preview window
:public	:public		prefix for a class or object member
:pwd		:pw[d]		print current directory
:quit		:q[uit]		quit current window (when one window quit Vim)
:quitall	:quita[ll]	quit Vim
:qall		:qa[ll]		quit Vim
:read		:r[ead]		read file into the text
:recover	:rec[over]	recover a file from a swap file
:redo		:red[o]		redo one undone change
:redraw	:redr[aw]	  force a redraw of the display
:redrawstatus	:redraws[tatus]	  force a redraw of the status line(s)
:redrawtabline  :redrawt[abline]  force a redraw of the tabline
:resize	:res[ize]	change current window height
:retab	:ret[ab]	change tab size
:return	:retu[rn]	return from a user function
:rewind	:rew[ind]	go to the first file in the argument list
:right	:ri[ght]	right align text
:rightbelow	:rightb[elow]	make split window appear right or below
:rundo	:rund[o]	read undo information from a file
:runtime	:ru[ntime]	source vim scripts in 'runtimepath'
:rviminfo	:rv[iminfo]	read from viminfo file
:substitute	:s[ubstitute]	find and replace text
:sNext	:sN[ext]	split window and go to previous file in argument list
:sandbox	:san[dbox]	execute a command in the sandbox
:sargument	:sa[rgument]	split window and go to specific file in argument list
:sall		:sal[l]		open a window for each file in argument list
:saveas	:sav[eas]	save file under another name.
:scscope	:scs[cope]	split window and execute cscope command
:set		:se[t]		show or set options
:setfiletype	:setf[iletype]	set 'filetype', unless it was set already
:setglobal	:setg[lobal]	show global values of options
:setlocal	:setl[ocal]	show or set options locally
:sfind	:sf[ind]	split current window and edit file in 'path'
:sfirst	:sfir[st]	split window and go to first file in the argument list
:shell	:sh[ell]	escape to a shell
:simalt	:sim[alt]	Win32 GUI: simulate Windows ALT key
:sign		:sig[n]		manipulate signs
:silent	:sil[ent]	run a command silently
:sleep	:sl[eep]	do nothing for a few seconds
:sleep!	:sl[eep]!	do nothing for a few seconds, without the cursor visible
:slast	:sla[st]	split window and go to last file in the argument list
:smagic	:sm[agic]	:substitute with 'magic'
:smap		:smap		like ":map" but for Select mode
:smapclear	:smapc[lear]	remove all mappings for Select mode
:smenu	:sme[nu]	add menu for Select mode
:smile	:smi[le]	make the user happy
:snext	:sn[ext]	split window and go to next file in the argument list
:snomagic	:sno[magic]	:substitute with 'nomagic'
:snoremap	:snor[emap]	like ":noremap" but for Select mode
:snoremenu	:snoreme[nu]	like ":noremenu" but for Select mode
:sort		:sor[t]		sort lines
:source	:so[urce]	read Vim or Ex commands from a file
:split	:sp[lit]	split current window
:stop		:st[op]		suspend the editor or escape to a shell
:stag		:sta[g]		split window and jump to a tag
:startinsert	:star[tinsert]	start Insert mode
:startgreplace  :startg[replace] start Virtual Replace mode
:startreplace	:startr[eplace]	start Replace mode
:static	:static		prefix for a class member or function
:stopinsert	:stopi[nsert]	stop Insert mode
:stjump	:stj[ump]	do ":tjump" and split window
:stselect	:sts[elect]	do ":tselect" and split window
:sunhide	:sun[hide]	same as ":unhide"
:sunmap	:sunm[ap]	like ":unmap" but for Select mode
:sunmenu	:sunme[nu]	remove menu for Select mode
:suspend	:sus[pend]	same as ":stop"
:sview	:sv[iew]	split window and edit file read-only
:swapname	:sw[apname]	show the name of the current swap file
:syntax	:sy[ntax]	syntax highlighting
:syntime	:synti[me]	measure syntax highlighting speed
:syncbind	:sync[bind]	sync scroll binding
:t		:t		same as ":copy"
:tNext	:tN[ext]	jump to previous matching tag
:tabNext	:tabN[ext]	go to previous tab page
:tabclose	:tabc[lose]	close current tab page
:tabdo	:tabdo		execute command in each tab page
:tabedit	:tabe[dit]	edit a file in a new tab page
:tabfind	:tabf[ind]	find file in 'path', edit it in a new tab page
:tabfirst	:tabfir[st]	go to first tab page
:tablast	:tabl[ast]	go to last tab page
:tabmove	:tabm[ove]	move tab page to other position
:tabnew	:tabnew		edit a file in a new tab page
:tabnext	:tabn[ext]	go to next tab page
:tabonly	:tabo[nly]	close all tab pages except the current one
:tabprevious	:tabp[revious]	go to previous tab page
:tabrewind	:tabr[ewind]	go to first tab page
:tabs		:tabs		list the tab pages and what they contain
:tab		:tab		create new tab when opening new window
:tag		:ta[g]		jump to tag
:tags		:tags		show the contents of the tag stack
:tcd		:tc[d]		change directory for tab page
:tchdir	:tch[dir]	change directory for tab page
:tcl		:tcl		execute Tcl command
:tcldo	:tcld[o]	execute Tcl command for each line
:tclfile	:tclf[ile]	execute Tcl script file
:tearoff	:te[aroff]	tear-off a menu
:terminal	:ter[minal]	open a terminal window
:tfirst	:tf[irst]	jump to first matching tag
:throw	:th[row]	throw an exception
:tjump	:tj[ump]	like ":tselect", but jump directly when there is only one match
:tlast	:tl[ast]	jump to last matching tag
:tlmenu	:tlm[enu]	add menu for Terminal-Job mode
:tlnoremenu	:tln[oremenu]	like ":noremenu" but for Terminal-Job mode
:tlunmenu	:tlu[nmenu]	remove menu for Terminal-Job mode
:tmapclear	:tmapc[lear]	remove all mappings for Terminal-Job mode
:tmap		:tma[p]		like ":map" but for Terminal-Job mode
:tmenu	:tm[enu]	define menu tooltip
:tnext	:tn[ext]	jump to next matching tag
:tnoremap	:tno[remap]	like ":noremap" but for Terminal-Job mode
:topleft	:to[pleft]	make split window appear at top or far left
:tprevious	:tp[revious]	jump to previous matching tag
:trewind	:tr[ewind]	jump to first matching tag
:try		:try		execute commands, abort on error or exception
:tselect	:ts[elect]	list matching tags and select one
:tunmap	:tunma[p]	like ":unmap" but for Terminal-Job mode
:tunmenu	:tu[nmenu]	remove menu tooltip
:undo		:u[ndo]		undo last change(s)
:undojoin	:undoj[oin]	join next change with previous undo block
:undolist	:undol[ist]	list leafs of the undo tree
:unhide	:unh[ide]	open a window for each loaded file in the buffer list
:unlet	:unl[et]	delete variable
:unlockvar	:unlo[ckvar]	unlock variables
:unmap	:unm[ap]	remove mapping
:unmenu	:unme[nu]	remove menu
:unsilent	:uns[ilent]	run a command not silently
:update	:up[date]	write buffer if modified
:vglobal	:v[global]	execute commands for not matching lines
:var		:var		variable declaration in Vim9
:version	:ve[rsion]	print version number and other info
:verbose	:verb[ose]	execute command with 'verbose' set
:vertical	:vert[ical]	make following command split vertically
:vim9cmd	:vim9[cmd]	make following command use Vim9 script syntax
:vim9script	:vim9s[cript]	indicates Vim9 script file
:vimgrep	:vim[grep]	search for pattern in files
:vimgrepadd	:vimgrepa[dd]	like :vimgrep, but append to current list
:visual	:vi[sual]	same as ":edit", but turns off "Ex" mode
:viusage	:viu[sage]	overview of Normal mode commands
:view		:vie[w]		edit a file read-only
:vmap		:vm[ap]		like ":map" but for Visual+Select mode
:vmapclear	:vmapc[lear]	remove all mappings for Visual+Select mode
:vmenu	:vme[nu]	add menu for Visual+Select mode
:vnew		:vne[w]		create a new empty window, vertically split
:vnoremap	:vn[oremap]	like ":noremap" but for Visual+Select mode
:vnoremenu	:vnoreme[nu]	like ":noremenu" but for Visual+Select mode
:vsplit	:vs[plit]	split current window vertically
:vunmap	:vu[nmap]	like ":unmap" but for Visual+Select mode
:vunmenu	:vunme[nu]	remove menu for Visual+Select mode
:windo	:windo		execute command in each window
:write	:w[rite]	write to a file
:wNext	:wN[ext]	write to a file and go to previous file in argument list
:wall		:wa[ll]		write all (changed) buffers
:while	:wh[ile]	execute loop for as long as condition met
:winsize	:wi[nsize]	get or set window size (obsolete)
:wincmd	:winc[md]	execute a Window (CTRL-W) command
:winpos	:winp[os]	get or set window position
:wnext	:wn[ext]	write to a file and go to next file in argument list
:wprevious	:wp[revious]	write to a file and go to previous file in argument list
:wq		:wq		write to a file and quit window or Vim
:wqall	:wqa[ll]	write all changed buffers and quit Vim
:wundo	:wu[ndo]	write undo information to a file
:wviminfo	:wv[iminfo]	write to viminfo file
:xit		:x[it]		write if buffer changed and close window
:xall		:xa[ll]		same as ":wqall"
:xmapclear	:xmapc[lear]	remove all mappings for Visual mode
:xmap		:xm[ap]		like ":map" but for Visual mode
:xmenu	:xme[nu]	add menu for Visual mode
:xrestore	:xr[estore]	restores the X server connection
:xnoremap	:xn[oremap]	like ":noremap" but for Visual mode
:xnoremenu	:xnoreme[nu]	like ":noremenu" but for Visual mode
:xunmap	:xu[nmap]	like ":unmap" but for Visual mode
:xunmenu	:xunme[nu]	remove menu for Visual mode
:z		:z		print some lines
:~		:~		repeat last ":substitute"



# grande fonction de VIM

##1. Édition de texte
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
##2. Modification de texte via le mode Ex:
:substitute	:s[ubstitute]	rechercher et remplacer du texte
:smagic		:sm[agic]	":substitute" avec l'option 'magic'
:snomagic	:sno[magic]	":substitute" sans l'option 'magic'
:global		:g[lobal]	exécuter des commandes sur les lignes correspondantes
:vglobal	:v[global]	exécuter des commandes sur les lignes non correspondantes
:sort		:sor[t]		trier des lignes
:join		:j[oin]		joindre des lignes
:move		:m[ove]		déplacer des lignes
:t		:t		identique à ":copy"
:left		:le[ft]		aligner les lignes à gauche
:right		:ri[ght]	aligner les lignes à droite
:center		:ce[nter]	centrer les lignes
:retab		:ret[ab]	modifier la taille de la tabulation
:normal		:norm[al]	exécuter des commandes du mode Normal
:filter		:filt[er]	filtrer la sortie de la commande suivante
:number		:nu[mber]	afficher les lignes avec numéro de ligne
:list		:l[ist]		afficher les lignes (avec caractères invisibles)
:print		:p[rint]	afficher des lignes
:z		:z		afficher plusieurs lignes
:~		:~		répéter le dernier ":substitute"
:dl		:dl		raccourci pour :delete avec l'option 'l'
:dp		:d[elete]p	raccourci pour :delete avec l'option 'p'
:read		:r[ead]		insérer le contenu d'un fichier dans le texte
:insert		:i[nsert]	insérer du texte

##3. Colorisation syntaxique.
:colorscheme	:colo[rscheme]	load a specific color scheme
:highlight	:hi[ghlight]	définir les méthodes de mise en évidence
:match		:mat[ch]	définir une correspondance à mettre en évidence
:ownsyntax	:ow[nsyntax]	définir une coloration syntaxique locale pour cette fenêtre
:syntax		:sy[ntax]	gestion de la coloration syntaxique
:syntime	:synti[me]	mesurer la vitesse de la coloration syntaxique
:sign		:sig[n]		manipuler les signes (marqueurs dans la gouttière)

##4. Mapping de commande
:map		:map		afficher ou définir un mapping (modes Normal et Visuel)
:noremap	:no[remap]	définir un mapping non récursif
:mapclear	:mapc[lear]	supprimer tous les mappings des modes Normal et Visuel
:unmap		:unm[ap]	supprimer un mapping
:nohlsearch	:noh[lsearch]	suspendre la mise en évidence de la recherche

### Mode Commande
:cmap		:cm[ap]		like ":map" but for Command-line mode
:cmapclear	:cmapc[lear]	clear all mappings for Command-line mode
:cnoremap	:cno[remap]	like ":noremap" but for Command-line mode
:cunmap		:cu[nmap]	like ":unmap" but for Command-line mode

### Mode Insertion
:imap		:im[ap]		comme ":map" mais pour le mode Insertion
:imapclear	:imapc[lear]	comme ":mapclear" mais pour le mode Insertion
:inoremap	:ino[remap]	comme ":noremap" mais pour le mode Insertion
:iunmap		:iu[nmap]	comme ":unmap" mais pour le mode Insertion

### Mode Normal
:nmap		:nm[ap]		comme ":map" mais pour le mode Normal
:nmapclear	:nmapc[lear]	supprimer tous les mappings du mode Normal
:nnoremap	:nn[oremap]	comme ":noremap" mais pour le mode Normal
:nunmap		:nun[map]	comme ":unmap" mais pour le mode Normal

### Mode Visuel et Sélection
:vmap		:vm[ap]		comme ":map" mais pour les modes Visuel+Sélection
:vmapclear	:vmapc[lear]	supprimer tous les mappings des modes Visuel+Sélection
:vnoremap	:vn[oremap]	comme ":noremap" mais pour les modes Visuel+Sélection
:vunmap		:vu[nmap]	comme ":unmap" mais pour les modes Visuel+Sélection

### Mode Visuel uniquement
:xmap		:xm[ap]		comme ":map" mais pour le mode Visuel
:xmapclear	:xmapc[lear]	supprimer tous les mappings du mode Visuel
:xnoremap	:xn[oremap]	comme ":noremap" mais pour le mode Visuel
:xunmap		:xu[nmap]	comme ":unmap" mais pour le mode Visuel

### Mode Sélection uniquement
:smap		:smap		comme ":map" mais pour le mode Sélection
:smapclear	:smapc[lear]	supprimer tous les mappings du mode Sélection
:snoremap	:snor[emap]	comme ":noremap" mais pour le mode Sélection
:sunmap		:sunm[ap]	comme ":unmap" mais pour le mode Sélection

### Mode Opérateur-en-attente
:omap		:om[ap]		comme ":map" mais pour le mode Opérateur-en-attente
:omapclear	:omapc[lear]	supprimer tous les mappings du mode Opérateur-en-attente
:onoremap	:ono[remap]	comme ":noremap" mais pour le mode Opérateur-en-attente
:ounmap		:ou[nmap]	comme ":unmap" mais pour le mode Opérateur-en-attente

### Mode Terminal-Job
:tmap		:tma[p]		comme ":map" mais pour le mode Terminal-Job
:tmapclear	:tmapc[lear]	supprimer tous les mappings du mode Terminal-Job
:tnoremap	:tno[remap]	comme ":noremap" mais pour le mode Terminal-Job
:tunmap		:tunma[p]	comme ":unmap" mais pour le mode Terminal-Job

### Mode Langue (Lang-Arg)
:lmap		:lm[ap]		comme ":map!" mais inclut le mode Lang-Arg
:lmapclear	:lmapc[lear]	comme ":mapclear!" mais inclut le mode Lang-Arg
:lnoremap	:ln[oremap]	comme ":noremap!" mais inclut le mode Lang-Arg
:lunmap		:lu[nmap]	comme ":unmap!" mais inclut le mode Lang-Arg
:loadkeymap	:loadk[eymap]	charger les correspondances de clavier jusqu'à EOF

##5. Options de commande
:set		:se[t]		afficher ou définir des options
:setfiletype	:setf[iletype]	définir 'filetype' s'il n'est pas déjà défini
:setglobal	:setg[lobal]	afficher les valeurs globales des options
:setlocal	:setl[ocal]	afficher ou définir des options localement
:options	:opt[ions]	ouvrir la fenêtre des options
:filetype	:filet[ype]	activer/désactiver la détection du type de fichier

##6. Onglets multiples (Tab management)
:tab		:tab		créer un onglet lors de l'ouverture d'une fenêtre
:tabNext	:tabN[ext]	aller à l'onglet précédent
:tabclose	:tabc[lose]	fermer l'onglet courant
:tabdo		:tabdo		exécuter une commande dans chaque onglet
:tabedit	:tabe[dit]	éditer un fichier dans un nouvel onglet
:tabfind	:tabf[ind]	trouver un fichier dans 'path' et l'éditer dans un nouvel onglet
:tabfirst	:tabfir[st]	aller au premier onglet
:tablast	:tabl[ast]	aller au dernier onglet
:tabmove	:tabm[ove]	déplacer l'onglet à une autre position
:tabnew		:tabnew		éditer un fichier dans un nouvel onglet
:tabnext	:tabn[ext]	aller à l'onglet suivant
:tabonly	:tabo[nly]	fermer tous les onglets sauf le courant
:tabprevious	:tabp[revious]	aller à l'onglet précédent
:tabrewind	:tabr[ewind]	aller au premier onglet
:tabs		:tabs		lister les onglets et leur contenu
:tcd		:tc[d]		changer le répertoire pour l'onglet courant
:tchdir		:tch[dir]	changer le répertoire pour l'onglet courant (alias)

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
:new		:new		créer une nouvelle fenêtre vide
:vnew		:vne[w]		créer une nouvelle fenêtre vide, divisée verticalement
:only		:on[ly]		fermer toutes les fenêtres sauf la courante
:split		:sp[lit]	diviser la fenêtre courante
:vsplit		:vs[plit]	diviser la fenêtre courante verticalement
:vertical	:vert[ical]	la commande suivante divise verticalement
:topleft	:to[pleft]	la fenêtre divisée apparaît en haut ou à gauche
:rightbelow	:rightb[elow]	la fenêtre divisée apparaît à droite ou en bas
:resize		:res[ize]	modifier la hauteur de la fenêtre courante
:syncbind	:sync[bind]	synchroniser le défilement lié
:windo		:windo		exécuter une commande dans chaque fenêtre
:winsize	:wi[nsize]	obtenir ou définir la taille de la fenêtre (obsolète)
:wincmd		:winc[md]	exécuter une commande de fenêtre (CTRL-W)
:winpos		:winp[os]	obtenir ou définir la position de la fenêtre
:unhide		:unh[ide]	ouvrir une fenêtre pour chaque fichier chargé dans la liste des tampons
:sunhide	:sun[hide]	identique à ":unhide"
:pclose		:pc[lose]	fermer la fenêtre de prévisualisation
:pedit		:ped[it]	éditer un fichier dans la fenêtre de prévisualisation
:psearch	:ps[earch]	comme ":ijump" mais affiche la correspondance dans la fenêtre de prévisualisation

### Diviser + naviguer dans les fichiers
:sNext		:sN[ext]	diviser la fenêtre et aller au fichier précédent dans la liste
:sall		:sal[l]		ouvrir une fenêtre pour chaque fichier de la liste des arguments
:sargument	:sa[rgument]	diviser la fenêtre et aller à un fichier spécifique
:sfind		:sf[ind]	diviser la fenêtre et éditer un fichier dans 'path'
:sfirst		:sfir[st]	diviser la fenêtre et aller au premier fichier de la liste
:slast		:sla[st]	diviser la fenêtre et aller au dernier fichier de la liste
:snext		:sn[ext]	diviser la fenêtre et aller au fichier suivant
:sview		:sv[iew]	diviser la fenêtre et éditer un fichier en lecture seule

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
:browse		:bro[wse]	use file selection dialog
:edit		:e[dit]		éditer un fichier
:enew		:ene[w]		éditer un nouveau tampon sans nom
:ex		:ex		identique à ":edit"
:find		:fin[d]		trouver un fichier dans 'path' et l'éditer
:first		:fir[st]	aller au premier fichier de la liste des arguments
:last		:la[st]		aller au dernier fichier de la liste des arguments
:next		:n[ext]		aller au fichier suivant de la liste des arguments
:previous	:prev[ious]	aller au fichier précédent de la liste des arguments
:rewind		:rew[ind]	aller au premier fichier de la liste des arguments
:view		:vie[w]		éditer un fichier en lecture seule
:visual		:vi[sual]	identique à ":edit", quitte le mode Ex
:file		:f[ile]		afficher ou définir le nom du fichier courant
:files		:files		lister tous les fichiers de la liste des tampons
:ls		:ls		lister tous les tampons
:saveas		:sav[eas]	enregistrer le fichier sous un autre nom
:write		:w[rite]	écrire dans un fichier
:wNext		:wN[ext]	écrire et aller au fichier précédent
:wall		:wa[ll]		écrire tous les tampons modifiés
:wnext		:wn[ext]	écrire et aller au fichier suivant
:wprevious	:wp[revious]	écrire et aller au fichier précédent
:update		:up[date]	écrire le tampon s'il a été modifié
:hide		:hid[e]		masquer le tampon courant lors d'une commande
:noswapfile	:nos[wapfile]	les commandes suivantes ne créent pas de fichier d'échange
:preserve	:pre[serve]	écrire tout le texte dans le fichier d'échange
:recover	:rec[over]	récupérer un fichier depuis un fichier d'échange
:swapname	:sw[apname]	afficher le nom du fichier d'échange courant

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

### Structures de contrôle
:if		:if		exécuter des commandes si la condition est vraie
:else		:el[se]		partie d'une commande :if
:elseif		:elsei[f]	partie d'une commande :if
:endif		:en[dif]	fin du bloc :if
:while		:wh[ile]	boucle tant que la condition est vraie
:endwhile	:endw[hile]	fin du bloc :while
:for		:for		boucle for
:endfor		:endfo[r]	fin du bloc :for
:try		:try		exécuter des commandes, interrompre en cas d'erreur ou d'exception
:catch		:cat[ch]	partie d'une commande :try
:finally	:fina[lly]	partie d'une commande :try
:endtry		:endt[ry]	fin du bloc :try
:throw		:th[row]	lever une exception
:return		:retu[rn]	retourner depuis une fonction utilisateur

### Variables et portée
:let		:let		assigner une valeur à une variable ou une option
:unlet		:unl[et]	supprimer une variable
:lockvar	:lockv[ar]	verrouiller des variables
:unlockvar	:unlo[ckvar]	déverrouiller des variables
:var		:var		déclarer une variable en Vim9
:import		:imp[ort]	Vim9 : importer un élément depuis un autre script

### Exécution et sources
:source		:so[urce]	lire des commandes Vim ou Ex depuis un fichier
:runtime	:ru[ntime]	sourcer des scripts Vim dans 'runtimepath'
:normal		:norm[al]	exécuter des commandes du mode Normal
:sandbox	:san[dbox]	exécuter une commande dans le bac à sable
:silent		:sil[ent]	exécuter une commande silencieusement
:unsilent	:uns[ilent]	exécuter une commande de façon non silencieuse
:verbose	:verb[ose]	exécuter une commande avec 'verbose' activé
:legacy		:leg[acy]	utiliser la syntaxe de script classique pour la commande suivante
:vim9cmd	:vim9[cmd]	utiliser la syntaxe Vim9 pour la commande suivante
:vim9script	:vim9s[cript]	indique un fichier script Vim9
:filter		:filt[er]	filtrer la sortie de la commande suivante

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
:rubydo		:rubyd[o]	execute Ruby command for each line
:rubyfile	:rubyf[ile]	execute Ruby script file

### tcl scripting
:tcl		:tcl		exécuter une commande Tcl
:tcldo		:tcld[o]	exécuter une commande Tcl pour chaque ligne
:tclfile	:tclf[ile]	exécuter un fichier script Tcl

### mzscheme scripting
:mzscheme	:mz[scheme]	exécuter une commande MzScheme
:mzfile		:mzf[ile]	exécuter un fichier script MzScheme

##11. autocmd
:autocmd	:au[tocmd]	enter or show autocommands
:augroup	:aug[roup]	select the autocommand group to use
:doautocmd	:do[autocmd]	apply autocommands to current buffer
:doautoall	:doautoa[ll]	apply autocommands for all loaded buffers
:noautocmd	:noa[utocmd]	following commands don't trigger autocommands

##12. Terminal
:terminal	:ter[minal]	ouvrir une fenêtre de terminal intégré
:shell		:sh[ell]	lancer un shell interactif
:stop		:st[op]		suspendre l'éditeur ou basculer vers un shell
:suspend	:sus[pend]	identique à ":stop"
:startinsert	:star[tinsert]	démarrer le mode Insertion
:startgreplace  :startg[replace] démarrer le mode Remplacement virtuel
:startreplace	:startr[eplace]	démarrer le mode Remplacement
:stopinsert	:stopi[nsert]	quitter le mode Insertion

##13. Marquage de texte (Mark)
:mark		:ma[rk]		définir une marque
:k		:k		définir une marque (raccourci)
:marks		:marks		lister toutes les marques
:jumps		:ju[mps]	afficher la liste des sauts
:keepalt	:keepa[lt]	la commande suivante conserve le fichier alternatif
:keepmarks	:kee[pmarks]	la commande suivante conserve les marques
:keepjumps	:keepj[umps]	la commande suivante conserve la liste des sauts et les marques
:keeppatterns	:keepp[atterns]	la commande suivante conserve l'historique des motifs de recherche
:lockmarks	:loc[kmarks]	la commande suivante conserve les marques en place
:oldfiles	:ol[dfiles]	lister les fichiers ayant des marques dans le fichier viminfo

##14. Abbréviations
:abbreviate	:ab[breviate]	enter abbreviation
:abclear	:abc[lear]	remove all abbreviations
:cabbrev	:ca[bbrev]	like ":abbreviate" but for Command-line mode
:cabclear	:cabc[lear]	clear all abbreviations for Command-line mode
:cnoreabbrev	:cnorea[bbrev]	like ":noreabbrev" but for Command-line mode
:cunabbrev	:cuna[bbrev]	like ":unabbrev" but for Command-line mode
:iabbrev	:ia[bbrev]	like ":abbrev" but for Insert mode
:iabclear	:iabc[lear]	like ":abclear" but for Insert mode
:inoreabbrev	:inorea[bbrev]	like ":noreabbrev" but for Insert mode
:iunabbrev	:iuna[bbrev]	like ":unabbrev" but for Insert mode
:noreabbrev	:norea[bbrev]	enter an abbreviation that will not be
:unabbreviate	:una[bbreviate]	remove abbreviation

##15. Intégration des tags
:tag		:ta[g]		sauter à un tag
:tags		:tags		afficher le contenu de la pile de tags
:pop		:po[p]		revenir à l'entrée précédente dans la pile de tags
:ppop		:pp[op]		":pop" dans la fenêtre de prévisualisation
:tNext		:tN[ext]	sauter au tag correspondant précédent
:tfirst		:tf[irst]	sauter au premier tag correspondant
:tlast		:tl[ast]	sauter au dernier tag correspondant
:tnext		:tn[ext]	sauter au tag correspondant suivant
:tprevious	:tp[revious]	sauter au tag correspondant précédent
:trewind	:tr[ewind]	sauter au premier tag correspondant
:tjump		:tj[ump]	comme ":tselect", saute directement s'il n'y a qu'une correspondance
:tselect	:ts[elect]	lister les tags correspondants et en sélectionner un
:stag		:sta[g]		diviser la fenêtre et sauter à un tag
:stjump		:stj[ump]	faire ":tjump" et diviser la fenêtre
:stselect	:sts[elect]	faire ":tselect" et diviser la fenêtre

### 15.1 Fenêtre de prévisualisation des tags
:ptag		:pt[ag]		afficher le tag dans la fenêtre de prévisualisation
:ptNext		:ptN[ext]	":tNext" dans la fenêtre de prévisualisation
:ptfirst	:ptf[irst]	":trewind" dans la fenêtre de prévisualisation
:ptjump		:ptj[ump]	":tjump" dans la fenêtre de prévisualisation
:ptlast		:ptl[ast]	":tlast" dans la fenêtre de prévisualisation
:ptnext		:ptn[ext]	":tnext" dans la fenêtre de prévisualisation
:ptprevious	:ptp[revious]	":tprevious" dans la fenêtre de prévisualisation
:ptrewind	:ptr[ewind]	":trewind" dans la fenêtre de prévisualisation
:ptselect	:pts[elect]	":tselect" dans la fenêtre de prévisualisation

##16. Misk
:@		:@		execute contents of a register
:@@		:@@		repeat the previous ":@"
:behave	:be[have]	set mouse and selection behavior

##17. Menu
:menu		:me[nu]		définir un nouvel élément de menu
:noremenu	:noreme[nu]	définir un menu qui ne sera pas remappé
:unmenu		:unme[nu]	supprimer un menu
:menutranslate  :menut[ranslate] ajouter une traduction de menu
:emenu		:em[enu]	exécuter un menu par son nom
:popup		:popu[p]	afficher un menu contextuel par son nom
:tearoff	:te[aroff]	détacher un menu

### Tous les modes
:amenu		:am[enu]	entrer un nouvel élément de menu pour tous les modes
:anoremenu	:an[oremenu]	entrer un nouveau menu pour tous les modes (non remappé)
:aunmenu	:aun[menu]	supprimer un menu pour tous les modes

### Mode Commande
:cmenu		:cme[nu]	ajouter un menu pour le mode Commande
:cnoremenu	:cnoreme[nu]	comme ":noremenu" mais pour le mode Commande
:cunmenu	:cunme[nu]	supprimer un menu pour le mode Commande

### Mode Insertion
:imenu		:ime[nu]	ajouter un menu pour le mode Insertion
:inoremenu	:inoreme[nu]	comme ":noremenu" mais pour le mode Insertion
:iunmenu	:iunme[nu]	supprimer un menu pour le mode Insertion

### Mode Normal
:nmenu		:nme[nu]	ajouter un menu pour le mode Normal
:nnoremenu	:nnoreme[nu]	comme ":noremenu" mais pour le mode Normal
:nunmenu	:nunme[nu]	supprimer un menu pour le mode Normal

### Mode Visuel et Sélection
:vmenu		:vme[nu]	ajouter un menu pour les modes Visuel+Sélection
:vnoremenu	:vnoreme[nu]	comme ":noremenu" mais pour les modes Visuel+Sélection
:vunmenu	:vunme[nu]	supprimer un menu pour les modes Visuel+Sélection

### Mode Visuel uniquement
:xmenu		:xme[nu]	ajouter un menu pour le mode Visuel
:xnoremenu	:xnoreme[nu]	comme ":noremenu" mais pour le mode Visuel
:xunmenu	:xunme[nu]	supprimer un menu pour le mode Visuel

### Mode Sélection
:smenu		:sme[nu]	ajouter un menu pour le mode Sélection
:snoremenu	:snoreme[nu]	comme ":noremenu" mais pour le mode Sélection
:sunmenu	:sunme[nu]	supprimer un menu pour le mode Sélection

### Mode Opérateur-en-attente
:omenu		:ome[nu]	ajouter un menu pour le mode Opérateur-en-attente
:onoremenu	:onoreme[nu]	comme ":noremenu" mais pour le mode Opérateur-en-attente
:ounmenu	:ounme[nu]	supprimer un menu pour le mode Opérateur-en-attente

### Mode Terminal-Job
:tlmenu		:tlm[enu]	ajouter un menu pour le mode Terminal-Job
:tlnoremenu	:tln[oremenu]	comme ":noremenu" mais pour le mode Terminal-Job
:tlunmenu	:tlu[nmenu]	supprimer un menu pour le mode Terminal-Job
:tmenu		:tm[enu]	définir l'infobulle d'un menu
:tunmenu	:tu[nmenu]	supprimer l'infobulle d'un menu

##18. integration avec les outils de programmation
:compiler	:comp[iler]	do settings for a specific compiler
:make		:mak[e]		exécuter la commande externe 'makeprg' et analyser les erreurs
:cscope		:cs[cope]	execute cscope command
:cstag		:cst[ag]	use cscope to jump to a tag
:scscope	:scs[cope]	diviser la fenêtre et exécuter une commande cscope
:lmake		:lmak[e]	execute external command 'makeprg' and parse error messages

##19. Marks
:delmarks	:delm[arks]	delete marks
:clearjumps	:cle[arjumps]	effacer la liste des sauts


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


##25. Quitter Vim
:quit		:q[uit]		quitter la fenêtre courante (quitter Vim si une seule fenêtre)
:quitall	:quita[ll]	quitter Vim
:qall		:qa[ll]		quitter Vim
:cquit		:cq[uit]	quitter Vim avec un code d'erreur
:wq		:wq		écrire le fichier et quitter la fenêtre ou Vim
:wqall		:wqa[ll]	écrire tous les tampons modifiés et quitter Vim
:xit		:x[it]		écrire si le tampon a été modifié et fermer la fenêtre
:xall		:xa[ll]		identique à ":wqall"

##26. Annulation et rétablissement
:undo		:u[ndo]		annuler le(s) dernier(s) changement(s)
:undojoin	:undoj[oin]	joindre le changement suivant au bloc d'annulation précédent
:undolist	:undol[ist]	lister les feuilles de l'arbre d'annulation
:redo		:red[o]		rétablir un changement annulé
:earlier	:ea[rlier]	revenir à un état antérieur (annuler)
:later		:lat[er]	aller à un état plus récent (rétablir)
:rundo		:rund[o]	lire les informations d'annulation depuis un fichier
:wundo		:wu[ndo]	écrire les informations d'annulation dans un fichier

##27. Recherche dans les fichiers
:grep		:gr[ep]		exécuter 'grepprg' et sauter à la première correspondance
:grepadd	:grepa[dd]	comme :grep, mais ajouter à la liste courante
:lgrep		:lgr[ep]	exécuter 'grepprg' et sauter à la première correspondance (liste de locations)
:lgrepadd	:lgrepa[dd]	comme :lgrep, mais ajouter à la liste courante
:vimgrep	:vim[grep]	rechercher un motif dans des fichiers
:vimgrepadd	:vimgrepa[dd]	comme :vimgrep, mais ajouter à la liste courante
:lvimgrep	:lv[imgrep]	rechercher un motif dans des fichiers (liste de locations)
:lvimgrepadd	:lvimgrepa[dd]	comme :lvimgrep, mais ajouter à la liste courante

### 27.1 Recherche d'identifiants et de définitions
:ilist		:il[ist]	lister les lignes où l'identifiant correspond
:isearch	:is[earch]	afficher une ligne où l'identifiant correspond
:ijump		:ij[ump]	sauter à la définition de l'identifiant
:dlist		:dli[st]	lister les #define
:dsearch	:ds[earch]	afficher un #define
:djump		:dj[ump]	sauter à un #define
:dsplit		:dsp[lit]	diviser la fenêtre et sauter à un #define

##28. Session et persistance
:mksession	:mks[ession]	écrire les informations de session dans un fichier
:mkvimrc	:mkv[imrc]	écrire les mappings et options courants dans un fichier
:mkexrc		:mk[exrc]	écrire les mappings et options courants dans un fichier .exrc
:mkview		:mkvie[w]	écrire la vue de la fenêtre courante dans un fichier
:rviminfo	:rv[iminfo]	lire depuis le fichier viminfo
:wviminfo	:wv[iminfo]	écrire dans le fichier viminfo

##29. Affichage et interface
:redraw		:redr[aw]	forcer le rafraîchissement de l'écran
:redrawstatus	:redraws[tatus]	forcer le rafraîchissement de la/des ligne(s) de statut
:redrawtabline  :redrawt[abline]  forcer le rafraîchissement de la barre d'onglets
:mode		:mod[e]		afficher ou changer le mode d'écran
:messages	:mes[sages]	afficher les messages précédemment affichés
:history	:his[tory]	afficher une liste d'historique
:version	:ve[rsion]	afficher le numéro de version et d'autres informations
:intro		:int[ro]	afficher le message d'introduction
:viusage	:viu[sage]	aperçu des commandes du mode Normal
:exusage	:exu[sage]	aperçu des commandes Ex
:promptfind	:pro[mptfind]	ouvrir la boîte de dialogue GUI pour la recherche
:promptrepl	:promptr[epl]	ouvrir la boîte de dialogue GUI pour la recherche/remplacement
:profile	:prof[ile]	profiler des fonctions et des scripts
:profdel	:profd[el]	arrêter le profilage d'une fonction ou d'un script
:goto		:go[to]		aller à un octet dans le tampon

##30. Packages et greffons
:packadd	:pa[ckadd]	ajouter un greffon depuis 'packpath'
:packloadall	:packl[oadall]	charger tous les paquets sous 'packpath'

##31. Environnement et système
:language	:lan[guage]	définir la langue (locale)
:lcd		:lc[d]		changer le répertoire localement
:lchdir		:lch[dir]	changer le répertoire localement (alias)
:pwd		:pw[d]		afficher le répertoire courant
:digraphs	:dig[raphs]	afficher ou entrer des digrammes
:fixdel		:fix[del]	définir le code de touche de <Del>
:hardcopy	:ha[rdcopy]	envoyer le texte à l'imprimante
:sleep		:sl[eep]	ne rien faire pendant quelques secondes
:sleep!		:sl[eep]!	ne rien faire pendant quelques secondes, sans le curseur visible
:smile		:smi[le]	rendre l'utilisateur heureux
:open		:o[pen]		démarrer le mode open (non implémenté)
:gui		:gu[i]		démarrer l'interface graphique (GUI)
:gvim		:gv[im]		démarrer l'interface graphique (GUI)
:simalt		:sim[alt]	Win32 GUI : simuler la touche Windows ALT
:xrestore	:xr[estore]	restaurer la connexion au serveur X
:nbclose	:nbc[lose]	fermer la session Netbeans courante
:nbkey		:nb[key]	transmettre une touche à Netbeans
:nbstart	:nbs[art]	démarrer une nouvelle session Netbeans



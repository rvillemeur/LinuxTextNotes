#!/bin/sh

#source: https://www.baeldung.com/linux/bash-console-geometry

# move cursor to the bottom-right corner
# CSI Ps ; Ps H : Move Cursor Position [row;column] (default = [1,1]) (CUP)
# CSI 6 n  : Report Cursor Position (CPR) [row;column] as CSI r ; c R

# apparait sous la forme [[ROW;COLR
#read cursor position
# -s: silent mode
# -d: delim R
# -p: display prompt on standard error
# demande à afficher le code du terminal, qui va déplace le curseur jusqu'à 999@999
# Le terminal répond sous la forme d'une saisie clavier (stdin) de la forme \e[row;colR
# On lit la réponse jusqu'au caractère "R". La réponse est splitté par ";" dans les 2 variables
IFS=';' read -sdR -p $'\e[999;999H\e[6n' ROW COL

# On enlève l'escape du code retourné (du type \e[) par extension de paramètre
# ${VAR#pattern} : Demande à Bash de supprimer la plus petite partie au début de la variable qui correspond au motif (pattern).
# *[ : Signifie "n'importe quel caractère suivi d'un crochet". Cela supprime donc exactement le \e[ qui nous gêne.
rows=${ROW#*[}
cols=$COL

echo "Terminal width: $cols"
echo "Terminal height: $rows"

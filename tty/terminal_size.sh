#!/bin/sh

#source: https://www.baeldung.com/linux/bash-console-geometry

# move cursor to the bottom-right corner
# CSI P s ; P s H Cursor Position [row;column] (default = [1,1]) (CUP)
# CSI 6 n  : Report Cursor Position (CPR) [row;column] as CSI r ; c R
echo -ne "\e[999;999H\e[6n"

#read cursor position
IFS=';' read -sdR -p $'\e[6n' ROW COL

rows=${ROW#*[}
cols=$COL

echo "Terminal width: $cols"
echo "Terminal height: $rows"

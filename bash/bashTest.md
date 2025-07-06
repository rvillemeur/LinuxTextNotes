# test en bash

## substitution de parametre
https://tldp.org/LDP/abs/html/parameter-substitution.html
https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html

## ecriture de test

Les tests peuvent s'écrire à l'aide des commandes et operateurs suivants:
- commande "`test`" et  "`[ ... ]`" (qui est un alias de test)
- Construction `[[ ... ]]`

Les commandes internes `test` et `[` imitent les programmes `/bin/[` et 
`/bin/test`. `[[` est une amélioration apportée par bash à la commande `[`. Elle 
comporte plusieurs améliorations qui en font un meilleur choix si vous écrivez 
des scripts destinés à bash. 

Il s'agit d'une fonctionnalité syntaxique du shell, elle a donc un comportement 
particulier que `[` n'a pas. Vous n'avez plus besoin de mettre les variables 
entre guillemets comme un fou, car `[[` gère les chaînes vides et les chaînes 
contenant des espaces de manière plus intuitive, sans devoir prendre en compte 
le découpage de mot déterminé par la variable `IFS`.  Par exemple, avec `[`, 
vous devez écrire ` if [ -f "$file" ]` pour gérer correctement les chaînes vides 
ou les noms de fichiers contenant des espaces. Avec `[[`, les guillemets sont 
inutiles: `if [[ -f $file ]]`

Comme il s'agit d'une fonctionnalité syntaxique, elle vous permet d'utiliser les 
opérateurs `&&` et `||` pour les tests booléens et `<` et `>` pour les 
comparaisons de chaînes. `[` ne peut pas faire cela car il s'agit d'une commande 
régulière et `&&`, `||`, `<` et `>` ne sont pas transmis aux commandes 
régulières en tant qu'arguments de ligne de commande.

Il dispose de l'opérateur `=~` pour effectuer des correspondances 
d'expressions régulières. Avec `[` , vous pourriez écrire `if [ "$answer" = y -o 
"$answer" = yes ]` Avec `[[`, vous pouvez écrire cela comme `if [[ $answer =~ 
^y(es)?$ ]]`

Cela vous permet même d'accéder aux groupes capturés qu'il stocke dans 
`BASH_REMATCH`. Par exemple, `${BASH_REMATCH[1]}` serait "es" si vous aviez tapé 
"yes" en entier ci-dessus.

Vous obtenez gratuitement la correspondance de motifs, également appelée 
globbing. Peut-être êtes-vous moins strict sur la façon de taper "yes".  
Peut-être que cela ne vous dérange pas si l'utilisateur tape "y-n'importe quoi" 
Nous avons ce qu'il vous faut `if [[ $ANSWER = y* ]]`

Gardez à l'esprit qu'il s'agit d'une extension bash. Assurez-vous d'avoir la 
ligne shebang `#!/bin/bash` pour votre script si vous utilisez des doubles 
crochets.

## test string & integer
https://tldp.org/LDP/abs/html/tests.html

https://tldp.org/LDP/abs/html/testconstructs.html
https://mywiki.wooledge.org/BashFAQ/031

###string comparison

>           [[ a > b ]] || echo "a does not come after b"
<           [[ az < za ]] && echo "az comes before za"
= (or ==)   [[ a = a ]] && echo "a equals a"
!=          [[ a != b ]] && echo "a is not equal to b"

###integer comparison

-gt          [[ 5 -gt 10 ]] || echo "5 is not bigger than 10"
-lt          [[ 8 -lt 9 ]] && echo "8 is less than 9"
-ge          [[ 3 -ge 3 ]] && echo "3 is greater than or equal to 3"
-le          [[ 3 -le 8 ]] && echo "3 is less than or equal to 8"
-eq          [[ 5 -eq 05 ]] && echo "5 equals 05"
-ne          [[ 6 -ne 20 ]] && echo "6 is not equal to 20"

###conditional evaluation

&&           [[ -n $var && -f $var ]] && echo "$var is a file"
||           [[ -b $var || -c $var ]] && echo "$var is a device"

### expression grouping

(...)        [[ $var = img* && ($var = *.png || $var = *.jpg) ]] && echo "$var starts with img and ends with .jpg or .png"

### Pattern matching

= (or ==)   [[ $name = a* ]] || echo "name does not start with an 'a': $name"

RegularExpression matching

=~           [[ $(date) =~ ^Fri\ ...\ 13 ]] && echo "It's Friday the 13th!"

## test fichier
[source tldp](https://tldp.org/LDP/abs/html/fto.html)

-e          file exists
-f          file is a regular file (not a directory or device file)
-s          file is not zero size
-d          file is a directory
-b          file is a block device
-c          file is a character device
-p          file is a pipe
-h          file is a symbolic link
-L          file is a symbolic link
-S          file is a socket
-t          file (descriptor) is associated with a terminal device
-r          file has read permission (for the user running the test)
-w          file has write permission (for the user running the test)
-x          file has execute permission (for the user running the test)
-g          set-group-id (sgid) flag set on file or directory
-u          set-user-id (suid) flag set on file
-k          sticky bit set
-O          you are owner of file
-G          group-id of file same as yours
-N          file modified since it was last read
f1 -nt f2   file f1 is newer than f2
f1 -ot f2   file f1 is older than f2
f1 -ef f2   files f1 and f2 are hard links to the same file
!           "not" -- reverses the sense of the tests above (returns true if condition absent).

## page de référence
[test operator in bash](https://linuxhandbook.com/bash-test-operators/)

# Note bash

## introduction

Un shell est simplement un macroprocesseur qui exécute des commandes. Le terme « 
macroprocesseur » désigne une fonctionnalité qui permet 
d'[étendre](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html) 
du texte et des symboles afin de créer des expressions plus longues. 
C'est le point d'entrée pour les interfaces homme/machine dite en ligne de commande

Un shell Unix est à la fois un interpréteur de commandes et un langage de 
programmation. En tant qu'interpréteur de commandes, le shell fournit à 
l'utilisateur une interface vers le riche ensemble d'utilitaires GNU. Les 
fonctionnalités du langage de programmation permettent de combiner ces 
utilitaires. 

Les shells peuvent être utilisés de manière interactive ou non interactive. En 
mode interactif, ils acceptent les entrées saisies au clavier. En mode non 
interactif, les shells exécutent les commandes lues dans un fichier. 

Un shell permet l'exécution de commandes GNU, de manière synchrone ou 
asynchrone. Le shell attend que les commandes synchrones soient terminées avant 
d'accepter d'autres entrées ; les commandes asynchrones continuent à s'exécuter 
en parallèle avec le shell pendant qu'il lit et exécute des commandes 
supplémentaires. Les constructions de redirection permettent un contrôle fin de 
l'entrée et de la sortie de ces commandes.  De plus, le shell permet de 
contrôler le contenu de l'environnement des commandes. 

Les shells fournissent également un petit ensemble de commandes intégrées 
(builtins) qui implémentent des fonctionnalités impossibles ou peu pratiques à 
obtenir via des utilitaires séparés.

## bash built-ins

### command & variables
https://www.gnu.org/software/bash/manual/html_node/Executing-Commands.html
https://www.gnu.org/software/bash/manual/html_node/Quoting.html
https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html

#### using built-in command
* alias / unalias
* builtin
* command
* enable

* times
* help
* :
* eval
* hash
* | / |&

#### read data
* mapfile
* read
* readarray

#### work with other script
* source / .
* export

#### directory listing and printing
* cd
* echo
* printf
* pwd

#### variable declaration
* declare / typeset
* let
* local
* readonly

#### directory stacks
* dirs
* popd
* pushd

#### subroutines & subprocesses
* builtin
* coproc
* caller
* type
* ulimit
* exec
* umask
* logout
* exit
* return

### behavior
* set / unset
* shopt

### command line
* bind
* getopts
* shift

### programming structure
https://www.gnu.org/software/bash/manual/html_node/Redirections.html
* break
* continue
* test / [
* until
* while
* for
* if
* case
* select
* ((...)) / [[...]]
* && / || / ! /
* (...) / {...}

### job controls
https://www.gnu.org/software/bash/manual/html_node/Job-Control.html
* bg
* fg
* jobs
* kill
* trap
* wait
* disown
* suspend

### history
* fc
* history

## tips & trick

### ls command remplacement
* `echo *` will show files in the current folder through file globbing on Bourne compatible shells.
* printf %s\\n ./*

## Additional command (not built in but expected)
https://www.gnu.org/software/coreutils/manual/coreutils.html
https://www.gnu.org/software/gawk/manual/gawk.html
https://www.gnu.org/software/sed/#help
https://www.gnu.org/software/m4/

## references
https://tldp.org/LDP/abs/html/index.html
https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents
https://www.man7.org/linux/man-pages/man1/bash.1.html
https://tldp.org/LDP/Bash-Beginners-Guide/html/index.html

## Philosophie des outils et intégration entre programmes

La philosophie des outils Unix se résume [ainsi](https://en.wikipedia.org/wiki/Unix_philosophy) :

1. Chaque programme ne doit faire qu'une seule chose et bien le faire, plutôt 
   que d'ajouter des fonctionnalités à un programme existant.
2. Les programmes doivent pouvoir travailler ensemble. La sortie d'un 
   programme peut devenir l'entrée un autre programme (en particulier à l'aide 
   du pipe "|". 
3. Le format texte est privilégié, car c'est un format d'échange universel

Ce qui fait la force de cette philosophie, c'est que, de part sa simplicité, on 
peut écrire des programmes dans n'importe quel langage, à condition qu'ils 
puissent lire sur les entrées/sorties standard (STDIN, STDOUT, STDERR). C'est 
une forme basique d'IPC (Inter Process Communication - Communication Inter 
Processus), qui démultiplie la portée de chaque commande utilisée.

En effet, les commandes écrites par différents vendeurs et developpeurs ne 
peuvent pas communiquer entre eux si un cadriciel (framework) standard est
utilisé. Sur Unix, de façon historique,c'est le format texte, et les 
entrées/sorties standard. 

Ailleurs, [Microsoft 
COM](https://www.codeproject.com/Articles/6726/COM-from-scratch-PART-ONE), 
[Oracle java](https://dev.java/)
ou [Microsoft .Net](https://dotnet.microsoft.com/en-us/) sont d'autres approche 
de développement logiciel multi-language.  Il faut cependant que soit les autres 
languages soient portées sur la plateforme ([Jython](https://www.jython.org/), 
[IronPython](https://ironpython.net/)), soit qu'un module soit écrit pour 
interfacer avec COM (Intégré avec [Visual Basic 
classic](https://en.wikipedia.org/wiki/Visual_Basic_(classic), ou le module 
[PyWin32](https://pywin32.com/guide/). Cette approche est cependant plus 
complexe, il faut par exemple s'assurer de la cohérence des types de données 
entre langages de programmation (transtypage), ainsi que des mécanismes 
d'allocation et de libération de mémoire. Dans le cas de COM, il y avait aussi 
un mécanisme d'identification des composants, soit à l'aide de la base de 
registre Windows, ou plus tard, des composants RegFreeCOM. COM avait aussi 
différentes façon de gérer le multi-threading.

On peut noter l'existence de DCOM (ou Distributed COM), qui était une tentative 
de Microsoft d'avoir des IPC/RPC distribué sur différents machines.
Aujourd'hui, la communication inter-process se fait d'avantage entre service web 
et API (Application Programming Interface) associé plutot qu'entre outils 
locaux, et les outils comme DCOM sont tombés en désuétude.

Enfin, le rêve d'une machine virtuelle multi-language sera peut être une réalité 
avec [web assembly](https://webassembly.org/), avec par exemple 
[nukita](https://github.com/Nuitka/Nuitka) qui permet de compiler du code Python 
vers Wasm. On trouve des modules similaire pour 
[Perl](https://perlwasm.github.io/) et bien sur 
[Javascript](https://developer.mozilla.org/en-US/docs/WebAssembly/Guides/Using_the_JavaScript_API)


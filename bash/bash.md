# Note bash

## introduction
a shell is simply a macro processor that executes commands. The term macro
processor means functionality where text and symbols are [expanded](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html) to create
larger expressions.


A Unix shell is both a command interpreter and a programming language.  As a
command interpreter, the shell provides the user interface to the rich set of
GNU utilities.  The programming language features allow these utilities to be
combined.

Shells may be used interactively or non-interactively. In interactive mode, they
accept input typed from the keyboard. When executing non-interactively, shells
execute commands read from a file.

A shell allows execution of GNU commands, both synchronously and asynchronously.
The shell waits for synchronous commands to complete before accepting more
input; asynchronous commands continue to execute in parallel with the shell
while it reads and executes additional commands. The redirection constructs
permit fine-grained control of the input and output of those commands.
Moreover, the shell allows control over the contents of commands’ environments.

Shells also provide a small set of built-in commands (builtins) implementing
functionality impossible or inconvenient to obtain via separate utilities.

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

## Limites des outils et autres langages

Limites des outils
Les outils traitent de sortie textuelle, qu'il faut parser et interpréter, et
gérer la communication entres processus.

Awk permet de traiter les fichiers structurés
Pour les traitements avancés, il vaut mieux utiliser d'autres outils

Pour le traitement de texte et la programmation procédurale et objet
https://www.perl.org

Pour des interfaces graphiques et la plupart des commandes systèmes
https://www.tcl-lang.org/

Pour des langages plus généralistes
Python et Ruby, ou nodejs.


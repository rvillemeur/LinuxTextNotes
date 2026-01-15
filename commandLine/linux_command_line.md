# environment
- terminal
- bash
-
# editor
- vim

Vim est un éditeur de texte bien intégré dans le terminal et avec l'environnement unix
Emacs est un environnement d'édition de contenu textuel. Il replace plusieurs outils

# introduction
La ligne de commande est l'outils fondamental permettant de piloter un ordinateur.

Chaque programme en s'exécutant est un processus qui se voit attribuer par défaut 3 handle correspondant à
- STDIN -> entrée standard
- STDOUT -> sortie standard
- STDERR -> sortie d'erreur standard
-
Les processus communiquent entre eux à l'aide de signaux qui permettent de les 
tuer, de savoir s'ils sont terminé proprement, etc... Ces processus peuvent être manipulé à travers le "shell", qui sert d'interface vers le système d'exploitation.

L'environnement unix en ligne de commande se caractérise par quelques concepts appliqué de façon uniforme qui donne toute la puissance à cette plate-forme. D'une façon surprenante, près de 60 ans après avoir posé ces principes, ils continuent de s'appliquer d'une façon très moderne. La programmation conciste toujours essentiellement à écrire des instruction texte dans un fichier. L'interaction avec un LLM peut se faire en ligne de commande, et un outils comme ChatGPT s'est fait connaître par sa capacité à produire du texte ressemblant à la pensée humaine. La plupart des échanges entre humain continue de se faire sous forme d'échange textuel. 

1. Tout est fichier.
Ou comme dit prosaïquement, tout est "handle". On trouve 3 fichiers assigné par défaut à chaque processus: STDIN, STDOUT, et STDERR. Les processus peuvent également lire et écrire dans des fichiers.
Ce principe s'applique à tout: gestion des périphériques (terminal, clavier, souris, etc.), génération de nombre aléatoire, interface réseaux, etc. Ces fichiers peuvent être vu comme un flux d'octet, mais appliqué au texte, cela permet une flexibilité incroyable.

2. On peut faire communiquer certains processus par un flux de texte, lié ensemble par des pipes.
Cette forme de communication, bien que semblant rudimentaire, se révèle extrêmement puissante.
La majorité de l'information que nous consommons se fait sous forme de texte.
- email
- journaux
- tchat.
- blog.
- réponse de prompt IA (soumis encore sous forme de texte). 

L'environnment Unix de base fournis les outils nécessaire pour traiter l'information textuelle.

3. l'interaction entre les programmes et le systèmes d'exploitation se fait à travers le shell. La communication se fait en envoyant des code d'erreur standardisé (SIGINT, etc.), permettant de tuer des processus ou de connaitre leur statut.

4. Le terminal permet d'afficher le texte d'une façon efficace, et avec un minimum de mise en page. Dès les premières versions, on pouvait afficher du texte en gras, italique, sousligné. Avec l'arrivée de l'unicode et des émojis, on peut ajouter un aspect graphique donnant un aspect moderne à cet univers auparavant austère et limité à un sous-ensemble de l'écriture.
Il permet aussi d'interagir avec les données. Si les programmes en ligne de commande permettent de traiter un grand volume de donnée en lot, des programmes en mode texte (TUI), permettent d'interagir avec d'une façon plus conviviale. 

5. L'environnement de ligne de commande, associé au terminal, permet de créer tout type de programme.
Besoin d'une calculatrice ? Pas besoin d'une interface graphique.
Communiquer ? Le courriel, IRC, n'ont pas attendu les environnements de bureaux pour exister.
Rédiger un document ? Des outils que TeX/LaTex, Groff, permettent de créer des documents et des graphismes dépassant la qualité de la plupart des traitements de texte wysiwyg.
Un éditeur comme Vim permet d'éditer du texte facilement. 

La première abstraction utilisé est le fichier.
the "everything is a file" dates back to the very early days of UNIX - 
the late 1960s / early 1970s. One thing it did was simplify the operating system
 in the sense that you could either write to or read from pretty well everything 
 in the system in much the same way - which became very handy when networking 
 started to happen.

Windows (modern / NT-family), on the other hand, has a lot to owe OS/2 with it's 
more "everything is an object" philosophy. One advantage of this, is that when 
you 'talk' to the object, it will 'know' what to do with what you are asking it 
for / to do. The downside though, is you need to know how to ask it to do what 
you want it to do.

While potentially more powerful and more flexible, it does give up simplicity.

edit: these are VERY BROAD brush strokes - not a deep analysis / critique


Torvalds has corrected this by saying it is not exactly "everything is a file", 
it is more like "everything is a handle". This means there is an API that is 
similar to opening, reading and writing a stream of bytes but it does not 
define the interactions beyond that.

## file viewing
- cat
- less
- tail
- head
- nl
- od
- xxd
- wc

# text manipulation
- cut
- paste
- tr
- sort
- uniq
- tee
- spell
-

# text language
- sed
- awk
- m4

# text processing
- groff
- tex/LaTex

## file and directory operation
- ls
- basename
- dirname
- mv
- rm
- cp
- pwd
- mkdir
- rmdir
- stat
- df
- du
- file
- touch

# file access right
- chgrp
- umask
- chmod
- chown
- chattr
- lsattr

# file comparison
- diff
- patch
- comm
- cmp

# file compression
- tar
- gzip
- compress
- uuencode
- uudecode

# file searching
- find
- slocate
- which
- grep
- type

# admin system

## autres outils disponible selon les paquets
### gestion de reseau - ipconfig2 et consort

### gestion des mots de passe: https://www.passwordstore.org/

### gestion des logs avec systemd: *journalctl* et *systemctl* 

### placement de caractère sur le terminal: *tput*

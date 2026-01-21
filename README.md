# LinuxTextNotes
Collection of notes on unix text management utilities and tools

L'environnement Unix dès ses origines a été orienté texte, qui est l'interface
par défaut permettant aux programmes de communiquer entre eux. 

On y retrouve
- Des outils pour traiter le texte (text processing) comme cat, sed, awk, grep, head, tail, spell, etc.
- Des éditeurs de texte, le plus répandu et connu étant Vi, emacs brillant second.
- Des outils de formatage de texte: groff, TeX/LaTeX
- Le shell qui permet de relier ces programmes entre eux en offrant à l'utilisateur un environnement interactif
- Le terminal, qui par ses codes de contrôles permet de créer des interfaces utilisateur textuelles (TUI) avancé

Les interfaces graphiques ont montré leur utilité pour plusieurs outils:
- retouche d'image
- analyse audio
- exploration graphique

Cependant, pour le traitment du texte et l'adminstration système, la ligne de commande reste irremplaçable

Le design des interfaces modernes permet aux utilisateurs de se passer de quelques heures d’apprentissage des outils équivalents en ligne de commande. Cependant, ces outils permettent d'élaborer un modèle mental de ce qu'il font et de la tache à résoude, ce que les interfaces graphiques ne permettent pas ou moins.

Les graphiques chatoyant et colorés, la facilité d'interaction avec la souris, offrent une façon ludique d'utiliser un ordinateur.  Le succès ne se dément pas depuis l'introduction de l'Apple Lisa en 1983, Apple Macintosh en 1984, et l'explosion de Windows 3.1 en 1992.  Le Web avec ses pages multi-couleurs, ses graphismes interactifs et son environnement distribué offre également une plate-forme attractive depuis son exposition au grand public pendant les années 1990.

Cependant, pour les opérations de base, comme le traitement de texte, un
tableur, le courriel, les forums de discussions instantanées, en bref, toutes
les moyens de communications basés sur du texte, le terminal et ses outils se
revèle, plusieurs décennie après leur introduction, remarquablement adapté et
capable de suivre l'évolution des pratiques. L'introduction de police de
caractère unicode pour illustrer, les logiciels développés uniquement en mode
texte étendent chaque jour un peu plus les possibilités de cette plate-forme.

Un éditeur de texte comme Vim, devient, une fois la période ardue d'apprentissage passée, une extension des doigts, et permet d'intéragir avec le texte quasiment sans y penser.

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
Dans l'ordre:
- L'environnement de base, le shell (bash), et la communication inter-processus.
- traitement de texte et administration système - le règne de la ligne de commande.
  * outils pour analyser le texte (head, tail, cut, sort, etc.)
  * outils système (rpm, réseaux, son, utilisateur/groupes, container, affichage, bureau, etc.)
  * outils fournissant des informations (ls, pwd, etc.), et tous les outils en ligne de commande
  * Outils avancé, la mise en page de texte avec Groff.
- L'interaction avec le texte: Terminal et TUI.
  * le terminal tty et ses code de mise en page
  * l'intégration et l'utilisation de police de caractère Unicode pour étendre l'affichage au dela de l'alphabet.
- édition de texte - l'éditeur VI.
  * édition de base
  * Commande g et s
  * intégration avec le shell
- Outils TUI avancé et développement de ses propres outils
  * quelques outils TUI (mc, mail, etc.)
  * développer ses propres outils avec python et/ou perl

# Notion
* fichier (pour lire, écrire, stocker l'information)
* ligne de commande
* IPC avec le '|' et le transfert d'information par flux de texte (text stream).
* bash comme lanceur de ligne de commande, et les macros pour étendre les arguments.
* terminal pour l'affichage du texte, et l'introduction des application avec une TUI. 

La force d'un éditeur comme Vi est sa totale intégration avec l'ensemble.
Outre le fait qu'il utilise les codes consoles pour permettre une affichage
dans le terminal, c'est aussi sa capacité à utiliser et intégrer les commandes
du système qui en font en véritable couteau suisse d'édition et d'analyse de la
donnée.

Le bash avec le système de Pipe, et la standardisation des entrées/sortie
(STDIN, STDOUT, STDERR) permet à différents programme de communiquer facilement.

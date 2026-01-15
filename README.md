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

La force d'un éditeur comme Vi est sa totale intégration avec l'ensemble.
Outre le fait qu'il utilise les codes consoles pour permettre une affichage
dans le terminal, c'est aussi sa capacité à utiliser et intégrer les commandes
du système qui en font en véritable couteau suisse d'édition et d'analyse de la
donnée.

Le bash avec le système de Pipe, et la standardisation des entrées/sortie
(STDIN, STDOUT, STDERR) permet à différents programme de communiquer facilement.

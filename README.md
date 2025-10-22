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


La force d'un éditeur comme Vi est sa totale intégration avec l'ensemble.
Outre le fait qu'il utilise les codes consoles pour permettre une affichage
dans le terminal, c'est aussi sa capacité à utiliser et intégrer les commandes
du système qui en font en véritable couteau suisse d'édition et d'analyse de la
donnée.

Le bash avec le système de Pipe, et la standardisation des entrées/sortie
(STDIN, STDOUT, STDERR) permet à différents programme de communiquer facilement.

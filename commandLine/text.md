# Entrée/sortie dans les commandes

Linux/Unix fournis de base des outils pour traiter et filtrer le texte, ce qui fait sa force.
La communication se fait à travers les pipes "|", qui échange des flux de texte d'une commande vers une autre, le STDOUT d'une commande devenant le STDIN de la commande suivante.

Parmis les outils disponible:
* AWK (traitement de données structurées)
* Banner (affichage d'un texte dans la console)
* cat (concatenate - aggregation de plusieurs ficher en 1 seul)
* cut (extrait des champs particulier d'un fichier)
* fmt (formattage de texte pour affichage dans la console)
* grep (recherche de ficher par expression régulière (global - RegEx - Print))
* head (affichage des premières lignes d'un fichier)
* iconv/uconv (conversion entre encodage de texte)
* join (fusion de 2 fichiers possédant un champ de donnée en commun)
* paste (fusion de 2 ou plusieurs fichier en integrant les champs d'une même ligne ensemble)
* sed (Stream Editor - permet de modifier un texte en mode batch).
* sort (trier le contenu d'un texte)
* string (extrait les chaines de caractères imprimable d'un fichier)
* tail (affichage des dernières lignes d'un fichier)
* tee (démultiplication des sorties de données entre fichier et STDOUT).
* tr (remplace dynamiquement des caractères par d'autre).
* wc (word count - fournis des statistique sur un fichier)

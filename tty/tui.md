# TUI - Text User Interface or Terminal User Interface

La ligne de commande est reine pour tout ce qui est interaction avec le système d'exploitation, et pour le traitement en lot des données. Cependant, quand il s'agit d'intéragir, les applications incluant une interface utilisateur ont depuis longtemps remporté la palme de la convivialité. 

Le terminal permet de construire une interface texte, avec tous les agréements qu'un terminal et une police de caractère moderne puissent offrir. Par exemple, en affichant des caractères émojis, ou à vocation technique.
On dépasse largement l'affichage des lettre de l'alphabet, et des quelques caractères disponible pour construire une interface texte basique. Les derniers développement dans le domaine permettent d'afficher des émojis en couleur. Le terminal, dans ses dernières incarnations, profite de l'accélération matérielle pour afficher le texte, et permet de mettre à l'ecran tout caractère contenu dans une police.

De part le minimalisme et les contraintes qu'il impose, les interfaces TUI sont plus contraintes que les interfaces classiques plus large qu'on retrouve dans les applications de bureaux. Elles ont cependant l'avantage de pouvoir s'afficher sur n'importe quel terminal compatible, de souvent nécessiter beaucoup moins de ressource, et de se focaliser sur l'essentiel. 

Le prompt de la ligne de commande est le niveau minimum qu'on puisse faire.
On peut personnaliser le prompt Bash, en y incluant des fonctions spécifique pour par exemple afficher l'heure, le chemin du fichier, le nom de la machine, etc.
On peut aussi utiliser le code d'affichage du terminal pour y introduire de la couleur.

Vim est un bon exemple de programme permettant l'édition de texte. 
Les codes terminaux sont l'équivalent, 40 ans avant, des balises HTML, à ceci près qu'on ne peut pas personnaliser leur affichage comme on le ferait avec CSS.
Un texte en gras reste un texte en gras. On peut en revanche choisir sa position dans l'écran, 
## introduction

Je trouve les interfaces textes fascinantes. Elle semblent repousser les limites
établies depuis les terminaux d'origine. Les terminaux d'origines étaient limité
par les polices de caractères disponible, leur affichage bitmap. Les terminaux
modernes peuvent afficher des polices de caractères intégrant une collection de
glyphes satisfaisant beaucoup de besoin d'illustration, telle que la police
`Caskaydia` qu'on peut trouver [ici](https://github.com/eliheuer/caskaydia-cove).

Les fenêtres des applications textuelles étaient historiquement affichés grâce 
aux glyphes [*Box Drawing*](https://en.wikipedia.org/wiki/Box-drawing_characters).

Plutot qu'interface utilisateur en mode texte, il serait plus approprié de
parler d'interface utilisateur en mode Terminal. On quitte la simplicité
d'échange de la *ligne de commande*. Ce genre d'interface a en revanche toute son
utilité pour intéragir en affichant l'information et en permettant d'intéragir
avec qui permettent aux humains que nous sommes de mieux l'appréhender. Si on
affiche plusieurs champs, on perd en efficacité pour le traitement textuel, on
gagne en convivialité sur la représentation de l'information.

## Multiplexeur de terminaux

Les multiplexeurs de terminaux permettent d'afficher plusieurs environnement
shell à partir d'un même terminal et ordinateur, sans devoir multiplier les
fenêtres sur l'environnement de bureau. Les plus connu et utilisés sont:

- tmux (licence BSD)
- screen (project GNU)

## exemple de bureaux complet en mode texte 

Bien que ressemblant plus à une preuve de concept qu'à un environnement
utilisable au quotidien, je trouve fascinant de voir jusqu'ou il est possible de
repousser les limites des interfaces textuelles
[twin](https://github.com/cosmos72/twin)

## librairie python pour développer des applications en mode TUI 

Les librairies *historique* telle que `ncurse` se retrouve petit à petit
remplacée par des alternatives plus modernes, et offrant plus de possibilités,
comme le placement des éléments en suivant la même logique que les boites dans
les librairies graphiques traditionelles.

Au moment d'écrire ces lignes (21 juin 2024), je trouve que la librairie
`textualize` offre le plus de possibilité pour écrire des applications
pleinement fonctionnelle en mode texte. Le rendu se rapproche vraiment des
interfaces graphiques complètes.

[textualize](https://textual.textualize.io/) ,[site officiel](https://www.textualize.io/) et [repo github](https://github.com/Textualize)
D'autres librairies sont disponibles sur internet. Il suffit de les rechercher par
*TUI libraries*, en spécifiant le language voulu

On a pu voir que la plate-forme permet de chainer des utilitaire simple pour créer des traitement complexe sur le texte.
Un language comme Python permet de créer des programmes en interface texte permettant d'intéragir avec la donnée.

Un éditeur comme Vim permet de manipuler le texte. On peut intéragir avec lui sur un mode client/serveur, et c'est intégré dans une librarie Python: https://github.com/andri-ch/vimrunner-python.
Tmux permet de faire du multi-fenétrage dans un terminal. La encore, un librarie Python permet d'interagir par programmation. https://github.com/tmux-python/libtmux.

A partir de ces différentes libraries ( *textualize, vimrunner-python, libtmux* ), on peut imaginer créer des interface textuelle permettant d'intéragir avec le texte et de fournir des interfaces sur mesure pour l'utilisateur. 


## exemple d'application TUI
[liste github](https://github.com/rothgar/awesome-tuis)
[TUI pour apprendre le terminal](https://github.com/learnbyexample/TUI-apps?tab=readme-ov-file)


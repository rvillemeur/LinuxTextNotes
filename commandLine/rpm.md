## rpm

rpm est le gestionnaire de package bas niveau pour fedora. Pour toute installation
et suppression de programme, on utilisera plutot `dnf` qui gère les dépendances entre
paquet. Cependant, pour connaitre les origines des programmes et des fichiers systèmes,
il est souvent utile d'utiliser les commandes rpm.

## example rpm

* rpm -e -> suppression de package
* rpm -qf -> package d'origine du fichier
* rpm -ql -> liste le contenu d'un package
* rpm -qa -> liste de tous les packages installés sur un systèmes.
* rpm -qi -> information sur un package.

## dnf

dnf est l'interface plus haut niveau qui permet d'installer et de supprimer facilement
les packages fedora en gérant les dépendances entre eux.

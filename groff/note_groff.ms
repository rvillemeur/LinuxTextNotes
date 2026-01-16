modules nécessaires

groff have a basic install with any flavor of linux. However, if you want to use
it fully, you'll need to install additional packages.

dnf install groff: add necessary package to base install
dnf install groff-doc: not mandatory, but you'll have all groff doc on your system.
dnf install groff-perl: Include amoung other post-processor gropdf to create pdf files.
dnf install perl-IO-Zlib pour la librairie de compression ZLib


Groff est un des premiers programmes de mise en forme de texte. Il précède TeX/LaTex, et permet de faire des mises en page avancé, incluant du graphisme, des formules mathématiques, etc. Il permet également l'inclusion d'hyperlien, la création de documents PDFs, etc.

Groff en tant que tel peut être vu comme un langage assembleur permettant la mise en forme de texte. Certains programmes l'accompagnant, comme ceux permettant de générer des diagrammes, peuvent être en réalités des scripts perl générant du code Groff à partir d'un programme de plus haut  niveau. Cela me fait vraiment penser à la relation entre l'assembleur et le langage C.



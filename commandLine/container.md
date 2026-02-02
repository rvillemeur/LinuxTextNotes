# Container - conteneurs

Les conteneurs (container) sont des unités exécutables qui regroupent le code d'une application avec ses bibliothèques et dépendances.
Ils permettent au code de s'exécuter dans un environnement isolé, reproductible et séparé de la machine hôte. Cela permet de ne pas polluer la machine de base avec des biblithèques et logiciels qui ne sont utilisé que dans un cadre précis. Plus portable et économes en ressource que les machines virtuelles (de type [virtual box](https://www.virtualbox.org/) ou [qemu](https://www.qemu.org/)).

*Docker* est la solution la plus connue dans ce domaine. 

Dans le cas de Fedora, [podman](https://podman.io/) est installé par défaut, et offre une solution flexible pour gérer ses containers locaux.

*Podman* s'utilise très bien en ligne de commande, documenté à https://docs.podman.io/en/stable/Commands.html
Podman est compatible avec ligne de commande de *Docker*, et la référence Docker est parfois utile pour mieux comprendre les subtilités des commandes Podman (https://docs.docker.com/reference/cli/docker/).

## dev container

Pour les développeurs, une solution a gagné en popularité ces dernières années:
Utiliser un container pour isoler son environnement de développement. Plus de
variable ou de librairie installé pouvant interférer avec le développement en
cours, et produire un résultat différent entre la machine de développment, et
l'environnement final. Un container étant un mini-environnement à lui seul,
contenant uniquement les librairies et les outils nécessaire pour faire le
développement demandé. On peut alors avoir un environnement sur-mesure, et
complètement distinct pour faire du Python, du Rust, du développement web, ou
n'importe quoi d'autre. Un environnement fermé de ce type permet aussi de
cibler une version spécifique d'un langage ou d'un environnoment de
programmation, sans craindre de contaminer son ordinateur de base.

Les prérequis sont relativement simple, car SSH suffit. Il est la plupart du
temps déjà installé sur une distribution linux. Le fichier ContainerFile permet
de s'assurer qu'ils sera bien installé avec l'image utilisé:

Le container peut partager l'accès au code source via un point de montage de
disque local, ou héberger totalement la solution.

Il existe plusieurs solutions pour mettre en oeuvre ce type de solution. La
première, développé et popularisé par Microsoft, consiste à ajouter un fichier
*devcontainer.json* à son projet. L'éditeur, comme Vim ou VS code, peut ensuite
utiliser ce fichier pour instancier ou se connecter à l'environnement de
développement containerisé. Il faut cependant ajouter un plugins à ces éditeurs
pour que la magie s'opère. Plus d'info et détails sur le fichier, les outils
sont disponibles sur le site https://containers.dev/. Par derrière, l'éditeur
va invoquer docker en instanciant un fichier ContainerFile. On peut sauter
cette étape en allant à la seconde solution, qui se concentre sur l'essentiel. 

La seconde solution consiste à créer son environnement sur mesure via le
fichier *ContainerFile*, et à lancer le container. On trouvera des astuces de
configuration sur
https://code.visualstudio.com/remote/advancedcontainers/overview


Le fichier devcontainer.json permet aussi à un éditeur comme VS Code de charger
des modules supplémentaires pour faciliter l'édition de code, comme un serveur
LSP, la colorisation syntaxique. Dans un environnement console brut comme celui
visé, il faudra installer ces outils en plus, et les configurer pour le projet.
Par exemple, pour un LSP (Language Server Protocol), regardez sur
https://langserver.org/ pour trouver le serveur adapté à votre langage.

Si le container contient le code en plus des outils, il y a 2 possibilités:
- utiliser la phase de création du container pour y inclure les paramètres de l'environnement du terminal (comme bashrc, vimrc, tmuxrc, etc.)
- S'y connecter en remote, en montant le système du fichier distant via SSH (regarder du côté de SSHFS), ou en l'éditant à distance avec VIM via netrw ou la commande interne *scp*. 

## tips

Running GUI wayland apps from Docker/podman: https://unix.stackexchange.com/questions/330366/how-can-i-run-a-graphical-application-in-a-container-under-wayland

introduction: https://www.infoq.com/articles/devcontainers/

Dans Podman/Docker, copier et exécuter un script externe pour personnaliser l'environnement:

```DockerFile
COPY ./scripts/install-subversion.sh /tmp/install-subversion.sh
RUN chmod +x /tmp/install-subversion.sh
RUN /tmp/install-subversion.sh \
  && rm -f /tmp/install-subversion.sh
```

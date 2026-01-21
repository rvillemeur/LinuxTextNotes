# Container - conteneurs

Les conteneurs (container) sont des unités exécutables qui regroupent le code d'une application avec ses bibliothèques et dépendances.
Ils permettent au code de s'exécuter dans un environnement isolé, reproductible et séparé de la machine hôte. Cela permet de ne pas polluer la machine de base avec des biblithèques et logiciels qui ne sont utilisé que dans un cadre précis. Plus portable et économes en ressource que les machines virtuelles (de type [virtual box](https://www.virtualbox.org/) ou [qemu](https://www.qemu.org/)).

*Docker* est la solution la plus connue dans ce domaine. 

Dans le cas de Fedora, [podman](https://podman.io/) est installé par défaut, et offre une solution flexible pour gérer ses containers locaux.

*Podman* s'utilise très bien en ligne de commande, documenté à https://docs.podman.io/en/stable/Commands.html
Podman est compatible avec ligne de commande de *Docker*, et la référence Docker est parfois utile pour mieux comprendre les subtilités des commandes Podman (https://docs.docker.com/reference/cli/docker/).


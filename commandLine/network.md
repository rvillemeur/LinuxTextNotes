# commande de networking

## rappel sur les composants:
* DNS - Domain Name System - lien entre addresse IP et nom 'humain' pour les machines.
* DHCP - Dynamic Host Configuration Protocol - allocation dynamique d'addresse IP.
* Routeur - périphérique permettant la communication inter-réseaux.

Cours théorique de bonne facture:
https://zestedesavoir.com/tutoriels/2789/les-reseaux-de-zero/
https://irp.nain-t.net/doku.php/start


## nmcli - commande de haut niveau, en dehors des interfaces graphiques, pour les machines desktop

`nmcli` est un interface pour *NetworkManager* qui permet de gérer les interfaces et connection réseaux.
Il permet d'avoir une interface plus haut niveau que les commandes plus bas niveau présentées après.

[doc fedora](https://fedoraproject.org/wiki/Networking/CLI)

NetworkManager s'intègre avec DBUS, et permet une manipulation directement avec les outils de configuration desktop. 
## ip - commande de plus bas niveau que nmcli

`ip` permet d'afficher et de manipuler le routage, les périphériques et interfaces réseaux, les tunnels, etc.

Ce sont des commandes de plus bas niveau que `nmcli`.

[difference entre ip et nmcli](https://aboutnetworks.net/linux-networking-part-1/)

## Authentification et connection wifi.

`wpa_supplicant, wpa_passphrase et wpa_cli` permettent de gérer l'authentification avec le routeur wifi.
Dans les réseaux informatique, un *supplicant* est un logiciel attaché à un noeud qui demande à être authentifié par une 'authentifieur' situé à un autre point (typiquement un routeur) pour donner accès.

## configuration de l'adresse de la machine avec systemd (semble plus pour les serveurs)

Pour configurer le réseau, on utilise " **networking.service** " pour **lo** et
" **NetworkManager.service** " avec **systemd**.

avec `systemd`, le réseau peut être configuré dans `/etc/systemd/network`. 

Pour le configurer sans interface graphique, en utilisant DHCP, vous pouvez avoir
" **/etc/systemd/network/dhcp.network** " avec par exemple

```txt
[Match]
Name=en*

[Network]
DHCP=yes
```
Pour un réseau statique, le fichier serait " **/etc/systemd/network/static.network** " avec

```txt
[Match]
Name=en*

[Network]
Address=192.168.0.15/24
Gateway=192.168.0.1
```

[source systemd](https://www.debian.org/doc/manuals/debian-reference/ch05.en.html#_the_modern_network_configuration_without_gui)

## vérification de la config avec dbus
`qdbus-qt6 --system --literal  org.freedesktop.NetworkManager`

[reference](https://askubuntu.com/questions/185784/configuration-of-the-network-manager-via-dbus-how-to-set-the-ad-hoc-mode/190790#190790)

## packages utiles
* `iputils`
* `NetworkManager`
* `iproute`
* `wpa_supplicant`


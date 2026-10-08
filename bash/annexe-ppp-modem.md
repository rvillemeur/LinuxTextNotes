# Annexe — Se connecter par PPP, comme au temps du modem

*Pour les lecteurs qui ont connu cette époque, et pour les autres : le récit d'un rituel où une même ligne était, tour à tour, un terminal puis un tuyau à paquets.*

Avant l'ADSL et la fibre, on ne se « branchait » pas à Internet : on l'**appelait**. Le modem composait un numéro, une autre machine décrochait à l'autre bout de la ville, et pendant une poignée de secondes deux appareils se cherchaient dans un crissement devenu légendaire. Ce qui suit décrit ce rituel sur un système Unix, et met en lumière un basculement qui résonne avec tout ce livre : au fil d'une seule session, la ligne série changeait de **régime** — d'abord terminal, ensuite lien réseau.

## Ce qu'il fallait

- Un **modem** raccordé à un port série — `/dev/ttyS0` (ou, sur les vieux noyaux, le périphérique d'appel sortant `/dev/cua0`) — lui-même relié à la prise téléphonique.
- Un **fournisseur d'accès** avec sa batterie de modems et son serveur d'accès (les Livingston PortMaster, Ascend MAX et autres Cisco de l'époque).
- Deux programmes : **`chat`**, qui dialogue avec le modem en commandes AT, et **`pppd`**, le démon PPP.
- Quelques **fichiers de configuration**, dans `/etc/ppp/`.

## Le rituel, étape par étape

1. **Décrocher et composer.** `chat` envoie au modem la commande de réinitialisation `ATZ`, puis `ATDT` suivi du numéro (`DT` pour *dial tone*, la numérotation à fréquences ; `DP` pour les vieux centraux à impulsions). On entendait la tonalité, puis les notes DTMF du numéro.

2. **La poignée de main.** Les deux modems se « voyaient », négociaient un protocole et une vitesse — c'est le crissement caractéristique, la séquence d'apprentissage. Le modem local annonçait alors `CONNECT 28800` (ou 33600, ou 56000 dans les belles années). À cet instant, une porteuse reliait les deux machines.

3. **S'authentifier.** Deux écoles coexistaient. À l'ancienne, le serveur distant présentait une **invite texte** — `login:` puis `password:` — et l'on s'y connectait *comme à un terminal* : la ligne était encore en régime `N_TTY`, avec cuisson et écho. Plus tard, l'authentification passa **dans PPP lui-même**, via PAP ou CHAP, le secret rangé dans `/etc/ppp/pap-secrets`.

4. **Basculer en PPP.** C'est le moment-clé. `pppd` reprenait la ligne et faisait un `TIOCSETD` vers `N_PPP` : la discipline de ligne changeait de module. **La ligne cessait d'être un terminal pour devenir un tuyau à paquets.** LCP montait le lien, IPCP négociait l'adresse IP (et souvent les serveurs DNS).

5. **En ligne.** L'interface `ppp0` apparaissait, `defaultroute` posait la route par défaut, `usepeerdns` écrivait `/etc/resolv.conf`. On était sur Internet — jusqu'à ce que quelqu'un décroche le téléphone de la cuisine et coupe tout.

## Les fichiers

Le script de dialogue avec le modem, `/etc/ppp/chat-monfai` :

```
ABORT    BUSY
ABORT    'NO CARRIER'
ABORT    'NO DIALTONE'
''       ATZ
OK       ATDT0860922000
CONNECT  ''
ogin:    monidentifiant
assword: monmotdepasse
```

Chaque ligne est un couple *attendre / envoyer*. `''` signifie « n'attends rien, envoie `ATZ` » ; `OK` reçu, on compose ; `CONNECT` reçu, on n'envoie rien (`''`). Les motifs tronqués `ogin:` et `assword:` évitent les pièges de casse sur la première lettre. (En PAP/CHAP, on supprime les deux dernières lignes : `pppd` s'occupe seul de l'authentification.)

La définition du correspondant, `/etc/ppp/peers/monfai` :

```
/dev/ttyS0
115200
crtscts
lock
noauth
defaultroute
usepeerdns
connect '/usr/sbin/chat -f /etc/ppp/chat-monfai'
```

Ici, `115200` est la vitesse entre l'ordinateur et le modem (bien supérieure à celle de la porteuse téléphonique) ; `crtscts` active le contrôle de flux matériel ; `lock` pose un verrou dans `/var/lock` pour que deux programmes ne se disputent pas la ligne ; `noauth` dit qu'on n'exige pas du correspondant qu'il s'authentifie auprès de nous.

Et l'on lançait le tout, en administrateur, d'une seule commande :

```
pppd call monfai
```

## À la main — le vrai souvenir

Avant les scripts, on faisait tout au clavier. On ouvrait un programme de terminal série (`minicom`, `seyon`, `cu`, `kermit`), on tapait `ATDT` et le numéro, on écoutait la connexion se faire, puis on se connectait à la main sur l'invite `login:`.

Et venait l'instant que personne n'a oublié : l'écran se remplissait soudain de charabia —

```
~ÿ}#À!}!}!} }4}"}&} } } } }%}&ÞÓ...
```

Ce n'était pas une panne. C'étaient les **trames PPP** que le serveur distant commençait à émettre, et que le terminal — toujours en régime `N_TTY` — s'efforçait vainement d'afficher comme du texte. Chaque `~` est l'octet `0x7E`, le fanion qui ouvre une trame PPP ; les `}` sont l'échappement des caractères de contrôle. On voyait, littéralement, des paquets réseau qu'on prenait pour des caractères. C'était le signal : on quittait le programme de terminal et l'on lançait `pppd` sur la même ligne. Le charabia cessait ; la ligne venait de changer de régime.

Ce détail, cocasse à l'époque, dit tout le propos de ce livre : sur le fil, il n'y a jamais eu que des octets. Le terminal essayait de les lire comme du texte parce que c'est son métier ; PPP les voulait comme des trames. Le même flux, deux lectures.

## Raccrocher

On arrêtait `pppd` (`kill`, ou une combinaison de touches), il commandait au modem de raccrocher, la porteuse tombait — `NO CARRIER` — et, le dernier descripteur refermé, la ligne retrouvait d'elle-même son régime `N_TTY`. Prête pour le prochain appel.

---

*Une même ligne, deux régimes successifs : terminal pour s'annoncer, tuyau à paquets pour l'Internet. L'abstraction du terminal a survécu au fil de cuivre qui l'a nommée — et l'emplacement « discipline de ligne » s'est révélé, le temps d'une soirée connectée, exactement pour ce qu'il est : un siège interchangeable posé sur un flux d'octets.*

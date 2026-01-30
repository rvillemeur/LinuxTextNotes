# client IRC weechat

IRC est un protocole de communication permettant de discuter à plusieurs dans des salons.
Même s'il est tombé en désuétude face aux clients graphique comme Discord ou slack, il est toujours utillisé 
dans les communauté open-source pour échanger

Il existe plusieurs clients pour se connecter à un serveur IRC. Dans le cadre de ce livre, j'ai choisis
*weechat*, qui est pré-packagé sur la plupart des distributions, et qui tourne dans un terminal, critère majeur de sélection.

## lancement

Dans le terminal, tapez la commande `weechat`. L'interface devrait s'ouvrir.

## avoir de l'aide.

tapez `/help` dans la fenêtre de *weechat*.

## quitter weechat

`/exit`  permet de quitter le logiciel


## se connecter à un serveur.

`/connect irc.freenode.net` ou `/connect irc.libera.chat`
`/disconnect` pour quitter le serveur
`/quit` déconnecter du serveur

## aller dans un salon (channel) particulier

`/join #vim`

`part #vim` pour quitter un channel

## lister les channels disponibles

`/list`

Pour rechercher des channels sur libera.chat, recherchez sur https://netsplit.de/

## pour ajouter le mapping de key `a la vim`
https://github.com/GermainZ/weechat-vimode

## pour aller plus loin

https://libera.chat/
https://weechat.org/files/doc/stable/weechat_user.en.html
https://libera.chat/guides/clients
https://libera.chat/guides/findingchannel

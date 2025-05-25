# VI and Ex text editor

## Commande VI

Les fonctions de base d'un éditeur de texte sont de:

- ouvrir et fermer l'application
- naviguer dans le texte
- ajouter, supprimer, modifier et déplacer du texte.

La plupart des commande de VI suivent le modèle

    NOMBRE COMMANDE OBJET-TEXTE
ou

>    COMMANDE NOMBRE OBJET-TEXTE

### OUVERTURE D'UN FICHIER

>    vi nom_fichier

### QUITTER VI

>    ZZ

### NAVIGUER DANS LE TEXTE - OBJET TEXTE

>    h, j, k, l  - déplacement par ligne
>    0, $        - début et fin de ligne
>    ^           - premier caractère non blanc de la ligne
>    n¦          - caractère n de la  ligne
>    w, W        - avance par mot
>    e, E        - va à la fin d'un mot
>    b, B        - recule par mot
>    +, ENTER    - au premier caractère de la ligne suivante
>    -           - au premier caractère de la ligne précédente

>    (           - début de la phrase courante
>    )           - fin de la phrase courante
>    {           - début du paragraphe courant
>    }           - fin du paragraphe courant
>    [[          - début de la section courante
>    ]]          - fin de la section courante

>    H           - va à la première ligne de l'écran
>    M           - va à la ligne au milieu de l'écran
>    L           - va à la dernière ligne de l'écran

>    nH          - va à n ligne sous le haut de l'écran
>    nL          - va à n lignes sur le bas de l'écran

>    nG          - va la ligne n du fichier

### NAGIGUER DANS LE TEXTE PAR RECHERCHE - OBJET TEXTE

>    /pattern    - recherche le pattern dans le texte vers l'avant
>    ?pattern    - recherche le pattern dans le texte vers l'arriére
>    n, /        - repète la dernière recherche dans la même direction 
>    N, ?        - repète la dernière recherche dans le direction inverse

>    fx          - déplace le curseur sur la prochaine occurence de x
>    Fx          - déplace le curseur sur la précédente occurence de x
>    tx          - déplace le curseur avant la prochaine occurence de x
>    Tx          - déplace le curseur après la précédente occurence de x
>    ;           - répète le déplacement dans même direction
>    ,           - répète le déplacement dans la direction opposé

### NAVIGUER DANS LE TEXTE PAR MARQUES - OBJET TEXTE

>    mx          - marque la position courante avec x ([a-zA-Z])
>    'x          - retourne au premier caractère de la ligne marqué par x
>    `x          - retourne à la position marqué par x
>    ``          - retourne à la marque précédente
>    ''          - retourne au début de la ligne contenant la marque précédente

### NAVIGUER DANS LES ECRANS

>    CTRL-F      - avance d'un écran
>    CTRL-B      - recule d'un écran

>    CTRL-D      - avance d'un demi écran
>    CTRL-U      - recule d'un demi écran

>    CTRL-E      - avance l'écran d'une ligne
>    CTRL-Y      - recule l'écran d'une ligne

>    CTRL-L      - redessine l'écran

>    z           - déplace la ligne courante en haut de l'écran
>    z.          - déplace la ligne courante au milieu de l'écran
>    z-          - déplace la ligne courante en base de l'écran

### INSERTION DE TEXTE

>    i           - insère texte
>    I           - insère texte en début de ligne

>    a           - ajout texte
>    A           - ajout texte en fin de ligne

>    o           - ouvre une nouvelle ligne sous le curseur
>    O           - ouvre une nouvelle ligne au dessus du curseur

### SUPPRESSION DE TEXTE

>    d           - suppression de texte
>    dd          - suppression d'une ligne
>    D           - suppression jusqu'à la fin de la ligne

>    x           - supprime un caractère sous ou après le curseur
>    X           - supprime un caractère avant le curseur

### MODIFICATION DE TEXTE

>    c           - change texte
>    cc          - change ligne courante
>    C           - change jusqu'à la fin de la ligne

>    r           - remplace un caractere
>    R           - remplace X caractère 

>    s           - substitution de X caractère
>    S           - substitution de la ligne entière

>    ~           - change la casse de caractére

### DEPLACEMENT DE TEXTE

>    p           - place le texte aprés la position du curseur
>    P           - place le texte avant la position du curseur

>    y           - copie le texte
>    yy          - copie la ligne entière

>    J           - joint 2 lignes ensemble

### DIVERS

>    .           - rejoue la dernière commande
>    u           - annule la dernière commande
>    U           - annule la dernière commade sur la ligne courante.

>    CTRL-G      - affiche les statistiques du fichier

>    "b cmd      - utilise le buffer b [0-9] par défaut, sinon [a-z] pour la commande
>    @b          - execute le contenu du buffer b

>    Q           - passe en mode Ex

## Commande Ex

La plupart des commandes EX suivent le modèle
>    :adresse COMMANDE OPTIONS

adresse peut être

- numéro de ligne explicite
- pattern de recherche
- symbole de positionement.

Les commandes EX peuvent être combiné avec l'opérateur |

### OUVERTURE

>    ex nom_fichier

### ECRITURE sur disque

>    :w[rite]    - écrit ou renomme le buffer sur le disque
>    :w!
>    :w >> file  - ajoute les données dans le fichier file
>    :r[ead] file     - ajoute les données de file dans le fichier courant.
>    :f[ile] file - change le nom du fichier en file.

### FERMETURE

>    :x[it]      - sauve et quitte
>    :wq         - sauve et quitte
>    :q[uit]     - quitte Ex
>    :e!         - reouvrir le fichier en perdant les modification
>    :q!         - fermeture du fichier en perdant les modifications.
>    :pre[serve] - sauvegarde le texte en swap
>    :rec[over]  - récupère un fichier de la zone de sauvegarde
>    :o[pen]     - quitte le mode Ex pour passer en mode VI
>    :vi[sual]   - quitte le mode Ex pour passer en mode VI

### DEFINITION D'ADRESSE DANS EX

>    :.          - ligne en cours
>    :%          - toutes les lignes du fichier
>    :n          - ligne du fichier
>    :$          - dernière ligne du fichier
>    :/pattern/  - texte satisfaisant pattern vers l'avant
>    :?pattern?  - texte satisfaisant pattern vers l'arrière.
>    :n,m        - ligne n à m (, permet de définir un range)
>    :n;m        - ligne n à m, avec n redéfini comme la ligne courante

>    +n          - ajoute n ligne à la sélection
>    -n          - retire n lignes à la sélection#

### NAVIGUER DANS LES ECRANS

>    :p[rint]    - affiche la ligne
>    :l[ist]     - affiche la ligne avec les caractère non imprimable
>    :nu[mber]   - affiche la ligne avec son numéro de ligne
>    :z type     - redessine l'écran (type peut être +, ., =, -, ^)

### NAVIGUER DANS LE TEXTE PAR MARQUES

>    :ma[rk] x   - marque le texte avec le marqueur x

### INSERTION DE TEXTE

>    :i[nsert] texte.   - insère du texte.
>    :a[ppend] texte.   - ajout de texte
>    :pu[t]         - insère un caractère ou le texte qui vient d'être supprimé
>    :y[ank]         - copie du texte placé dans un buffer

### SUPPRESSION DE TEXTE

>    :d[elete]   - suppression de texte (qui peut être mis dans un buffer)

### MODIFICATION DE TEXTE

>    :c[hange] texte.   - change le texte
>    :s[ubstitute]/pattern1/pattern2/cgp    - substition de texte
>        - c = confirm
>        - g = global
>        - p = print
>    :&          - repète une substitution
>    :~          - repète la dernière subsitution

### DEPLACEMENT DE TEXTE

>    :m[ove]     - déplacement de texte

>    :co[py]     - copie les lignes
>    :t[o]       - copie les lignes

>    :j[oin]     - joint du texte

>    :>          - indente vers la gauche.
>    :<          - indente vers la droite.

### DIVERS

>    :set        - définit la valeur d'une option vi/ex
>    :#          - affiche temporairement les numéros de lignes
>    :=          - affiche le nombre de ligne total du fichier
>    :g[lobal]   - commande globale, permettant de répéter une commande ex
>    :v          - exclusion globale (inverse de :g)
>    :so[urce] file    - évalue les commandes ex contenue dans le fichier file.
>    :sh[ell]    - ouvre un nouveau shell, et revient en mode edit après
>    :u[ndo]     - annule les dernières commandes d'édition
>    :ve[rsion]  - affiche la version de vi/ex
>    :!cmd       - execute la commande systeme. Si précédé d'un numéro de ligne, remplace le texte
>    :@buf       - execute le contenu du buffer

### NAVIGUER DANS LES BUFFERS EX

>    :n[ext]     - buffer suivant
>    :ar[gs]     - liste des buffers ouverts par la ligne de commande
>    :rew[ind]        - revient au début de la liste des buffers
>    :e[dit] file     - ouvre un nouveau buffer et le sauve dans file
>    :e[dit] #        - edite le buffer alternatif
>    :e[dit] %        - buffer courant

### MAP

Les commandes vi peuvent être mappé à une nouvelle combinaison de touche.

>    :map        - définit un nouveau mapping
>    :unmap      - supprime un mapping

### ABBREV

Un texte répétitif peut être associé à une combinaison de touche

>    :ab[brev]       - définit une abbréviation
>    :una[bbreviate] - retire la définition de l'abbréviation

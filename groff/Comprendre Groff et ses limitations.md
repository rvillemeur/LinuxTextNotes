# Comprendre Groff et ses limitations

## User

Je cherche à me familiariser avec Groff, et à comprendre ses limites. Outre la limitation historique qui limitait les commandes à 2 caractères, mais qui a été levé dans les versions récentes de gnu groff. En revanche, j'ai plus de mal à faire la différence entre markup et commande inline. Peux-tu m'aider à me familiariser avec Groff ?

## Claude

# Se familiariser avec GNU Groff

Bonne idée ! Groff est un outil puissant, mais sa syntaxe mélange plusieurs niveaux qu'il faut bien distinguer. Voici une vue d'ensemble structurée.

---

## Les trois niveaux de syntaxe

```
.\" Ceci est un commentaire
.TH MON_PROG 1 "2026-04-28"   ← Requête/macro (début de ligne)
.SH NOM
mon_prog \- un exemple \fBgras\fR  ← Escape inline dans le texte
```

### 1. Les *requests* (requêtes primitives)

Ce sont les commandes **de bas niveau** intégrées au moteur de Groff. Elles commencent **toujours en colonne 1** avec un `.` (ou `'` pour la variante non-interruptive).

```groff
.br          \" saut de ligne
.sp 2        \" 2 lignes vides
.in +4n      \" indentation +4 caratères
.ll 65n      \" longueur de ligne = 65 caractères
.ad l        \" alignement à gauche (left)
.na          \" no-adjust : désactive la justification
```

### 2. Les *macros*

Ce sont des **requêtes de haut niveau**, définies soit par vous, soit par un *macro package* (`-man`, `-ms`, `-mom`, `-me`…). Elles s'utilisent exactement comme les requêtes (début de ligne, `.`), mais leur nom est défini dans un fichier externe.

```groff
.SH "NOM DE SECTION"    \" macro du package -man
.PP                     \" nouveau paragraphe (-man/-ms)
.B mot                  \" texte en gras (-man)
.IP \[bu] 2             \" item de liste avec bullet (-man)
```

> **Règle simple** : si ça commence par `.` en début de ligne → c'est une requête ou une macro. La différence entre les deux est transparente à l'usage.

---

### 3. Les *escape sequences* (commandes inline) ← votre point de confusion

Ce sont des séquences commençant par `\`, utilisables **n'importe où dans le texte courant**, y compris au milieu d'une phrase. Elles n'interrompent pas le flux du texte.

| Escape | Rôle |
|---|---|
| `\fB` … `\fR` | Passe en **gras**, revient en roman |
| `\fI` … `\fR` | Passe en *italique* |
| `\f[BI]` … `\f[]` | Gras-italique (syntaxe longue) |
| `\[mu]` | Caractère spécial : × (multiplie) |
| `\[bu]` | Bullet • |
| `\~` | Espace insécable |
| `\(em` | Tiret cadratin — |
| `\n[.ll]` | Valeur d'un registre numérique |
| `\*[VERSION]` | Valeur d'une chaîne de caractères |
| `\hspace{4n}` | Espace horizontal forcé |
| `\"` | Commentaire jusqu'à fin de ligne |

**Exemple concret** :

```groff
.PP
Voici un texte avec un mot en \fBgras\fR et un autre en \fIitalique\fR,
ainsi qu'un tiret\(emcomme celui\-ci et un bullet\~\[bu] inline.
```

---

## La distinction clé : bloc vs. inline

```
        ┌─────────────────────────────────────────────┐
        │ DÉBUT DE LIGNE (.xxx)  →  agit sur le BLOC  │
        │                           (paragraphe,       │
        │                            espacement,        │
        │                            structure)         │
        ├─────────────────────────────────────────────┤
        │ DANS LE TEXTE (\xxx)   →  agit sur le FLUX  │
        │                           (fonte, caractère, │
        │                            registre, mesure)  │
        └─────────────────────────────────────────────┘
```

Un piège classique : la macro `.B` du package **-man** *sort du flux* pour rendre du gras, alors que `\fB...\fR` le fait *inline*. Les deux produisent du gras, mais :

```groff
.B "mot entier"          \" toute la ligne/argument en gras
Un \fBmot\fR au milieu.  \" seulement "mot" en gras
```

---

## Les registres et les chaînes

Deux mécanismes de variables accessibles uniquement en inline :

```groff
.nr MonCompteur 42           \" définit un registre numérique
La valeur est \n[MonCompteur].

.ds MaChaine "Bonjour monde" \" définit une chaîne
Voici : \*[MaChaine].
```

---

## Un exemple complet et compilable

Sauvegardez ceci en `test.ms` et compilez avec `groff -ms test.ms | ps2pdf - out.pdf` :

```groff
.\" test.ms - exemple avec le package -ms
.TL
Mon titre
.AU
Auteur
.AB
Résumé du document.
.AE
.NH 1
Première section
.PP
Voici un paragraphe avec du texte \fBen gras\fR, du texte
\fIen italique\fR, et un tiret cadratin\(emcomme ceci.
.PP
Un registre personnalisé\~: on est à la ligne\ \n[.ln].
.NH 2
Sous-section
.IP \[bu] 2
Premier item de liste.
.IP \[bu] 2
Deuxième item avec un \f[BI]gras-italique\f[].
```

---

## Résumé mnémotechnique

- **`.` en col. 1** → commande de **structure** (macro/requête)
- **`\` dans le texte** → commande de **rendu inline** (escape)
- Les *macro packages* (`-man`, `-ms`, `-mom`) vous évitent d'écrire les requêtes primitives à la main

Avez-vous un cas d'usage précis en tête (pages de man, document technique, etc.) ? Je peux approfondir la partie qui vous intéresse.

## User

Peux-tu m'aider à comprendre comment écrire une macro, et comment se passe la gestion des variables et des fonctions dans les macros groff ?

## Claude

# Écrire des macros dans GNU Groff

## Les blocs de définition : `.de` et `.de1`

Une macro se définit avec `.de` (ou `.de1` pour désactiver l'interpolation à la définition) et se termine par `..` :

```groff
.de MAMACRO
.  br
Bonjour depuis la macro !
..
```

> **Convention de style** : indenter le corps de la macro avec des espaces (après le `.`) est purement cosmétique, mais fortement recommandé pour la lisibilité.

La macro s'appelle ensuite comme n'importe quelle requête :

```groff
.MAMACRO
```

---

## Les arguments : `\$1`, `\$2`, … `\$*`

Groff passe les arguments **par position**, accessibles via des escapes spéciaux :

| Escape | Contenu |
|---|---|
| `\$1` … `\$9` | Arguments positionnels 1 à 9 |
| `\$[10]` | Argument 10 et au-delà (syntaxe longue) |
| `\$*` | Tous les arguments, séparés par des espaces |
| `\$@` | Tous les arguments, chacun entre guillemets |
| `\$0` | Nom de la macro elle-même |
| `\$#` | Nombre d'arguments reçus |

```groff
.de SALUT
Bonjour, \fB\$1\fR ! Tu as \$2 ans.
..

.SALUT Alice 30
.\"-→  Bonjour, Alice ! Tu as 30 ans.
```

Les arguments contenant des espaces doivent être **entre guillemets** à l'appel :

```groff
.SALUT "Jean-Pierre" 45
```

---

## Les variables : registres et chaînes

### Registres numériques `.nr`

```groff
.nr MonNombre 0          \" initialisation
.nr MonNombre +1         \" incrément
.nr MonNombre \$1        \" assignation depuis un argument

La valeur est \n[MonNombre].
```

Les registres supportent des **formats d'affichage** :

```groff
.af MonNombre i    \" affichage en chiffres romains minuscules
.af MonNombre A    \" affichage en lettres majuscules (A, B, C...)
```

Registres **en lecture seule** fournis par Groff :

| Registre | Valeur |
|---|---|
| `\n[.ln]` | Numéro de ligne courant |
| `\n[.f]` | Police courante (numéro) |
| `\n[.ps]` | Taille de police courante |
| `\n[.ll]` | Longueur de ligne courante |
| `\n[.i]` | Indentation courante |
| `\n[.$]` | Nombre d'arguments (dans une macro) |

### Chaînes `.ds`

```groff
.ds MaChaine "Valeur initiale"
.as MaChaine " suite ajoutée"    \" .as = append (concaténation)

Résultat : \*[MaChaine]
```

> **Piège** : `.ds` et `.nr` ont une portée **globale**. Il n'y a pas de variables locales natives — il faut ruser (voir plus bas).

---

## Le contrôle de flux

### Conditionnelles : `.if`, `.ie` / `.el`

```groff
.if \$1>10 .br               \" condition simple, une seule requête

.if \$1>10 \{\              \" bloc multi-lignes
.  sp
.  br
\}

.ie \$1>10 \{\              \" if/else
.  B "grand"
\}
.el \{\
.  B "petit"
\}
```

Les opérateurs de comparaison :

| Syntaxe | Sens |
|---|---|
| `\$1>10` | numérique : supérieur |
| `\$1=10` | numérique : égal |
| `'\$1'Alice'` | chaîne : égalité |
| `n` | mode nroff (terminal) |
| `t` | mode troff (typo) |
| `d MACRONAME` | la macro/chaîne est définie |
| `r MON_REG` | le registre existe |

```groff
.if d MAMACRO \{\
.  tm La macro MAMACRO est déjà définie.
\}
```

### Boucles : `.while` et `.until`

```groff
.nr I 0
.while \n[I]<5 \{\
.  tm Itération : \n[I]
.  nr I +1
\}
```

---

## Simuler des fonctions avec des arguments et variables locales

Groff n'a **pas de portée lexicale**. L'idiome classique pour protéger les variables est de les **sauvegarder/restaurer** manuellement, ou d'utiliser un préfixe de nommage :

```groff
.de ENCADRE
.\" Sauvegarde
.nr _enc_saved_i \n[.i]
.nr _enc_saved_ll \n[.ll]
.\" Travail
.in +4n
.ll -4n
.nf
\$*
.fi
.\" Restauration
.in \n[_enc_saved_i]u
.ll \n[_enc_saved_ll]u
..
```

### La récursion et `.als` (alias)

Vous pouvez **redéfinir une macro en la sauvegardant** d'abord avec `.als` :

```groff
.als PP_ORIG PP          \" crée un alias de la macro existante PP
.de PP
.  tm [debug] Nouveau paragraphe détecté
.  PP_ORIG               \" appelle l'original
..
```

---

## Les macros à deux parties : `de` + `de` (open/close)

Le pattern le plus courant dans les macro packages — une macro d'ouverture et une de fermeture qui partagent un état via des registres globaux :

```groff
.de BOITE_DEBUT
.nr _boite_level \n[_boite_level]+1
.sp 0.5
.nf
+----------------------------------+
..

.de BOITE_FIN
.fi
+----------------------------------+
.sp 0.5
.nr _boite_level \n[_boite_level]-1
..

.\" Usage :
.BOITE_DEBUT
Contenu de la boîte.
.BOITE_FIN
```

---

## Passer des macros en argument : `.de` avec `\$0`

Une macro peut **connaître son propre nom** et se comporter différemment selon la façon dont elle est appelée — utile pour les variantes :

```groff
.de TITRE1
.sp 2
.ps +4
\fB\$*\fR
.ps
.sp 1
..

.als TITRE2 TITRE1
.als TITRE3 TITRE1

.de TITRE1
.ie '\$0'TITRE1' .sp 2
.el .ie '\$0'TITRE2' .sp 1
.el .sp 0.5
.ps +4
\fB\$*\fR
.ps
..
```

---

## Déboguer avec `.tm` et `.tm1`

`.tm` écrit sur **stderr**, ce qui est parfait pour déboguer sans polluer le rendu :

```groff
.de MA_MACRO
.tm [MA_MACRO] appelée avec \$# arguments : \$*
.tm [MA_MACRO] registre courant = \n[MonNombre]
..
```

---

## Récapitulatif visuel

```
.de NOM          ← ouverture de définition
  \$1 \$2 …      ← arguments positionnels (escapes)
  \n[REG]        ← lecture d'un registre (escape)
  \*[STR]        ← lecture d'une chaîne (escape)
  .nr REG val    ← écriture registre (requête)
  .ds STR val    ← écriture chaîne (requête)
  .if COND \{   ← branchement
  \}
  .while C \{   ← boucle
  \}
..               ← fermeture de définition
```

> **À retenir** : dans une macro, la frontière *requête/inline* reste la même qu'en dehors — ce qui change, c'est que vous avez accès aux `\$n` et que le code est **évalué à l'appel**, pas à la définition.

Voulez-vous qu'on construise ensemble un exemple complet — par exemple un mini-package de macros pour un type de document précis ?

## User

Tu utilises des majuscules pour les macros, et des minuscules pour les requêtes. Est-ce un requis ou une simple convention de nommage ?

## Claude

C'est une **pure convention**, pas un requis technique.

Groff est insensible à la casse pour les noms de macros et de requêtes — `.PP`, `.pp` et `.Pp` sont trois macros distinctes mais toutes valides. Rien dans le moteur n'impose une casse particulière.

## D'où vient cette convention ?

Elle est héritée des macro packages historiques :

- **`-man`** et **`-ms`** utilisent des majuscules courtes : `.SH`, `.PP`, `.TH`, `.LP`
- **`-mom`** (plus moderne) utilise aussi des majuscules, mais des noms longs : `.HEADING`, `.BLOCKQUOTE`
- Les **requêtes primitives** du moteur sont toutes en minuscules : `.br`, `.sp`, `.in`, `.ll`, `.de`, `.nr`

Ce contraste visuel *majuscules = macro utilisateur/package*, *minuscules = primitives moteur* est donc une convention qui s'est imposée par imitation des packages standards. Elle a l'avantage pratique d'éviter les collisions avec les requêtes intégrées, qui occupent tout le bas de casse court.

## La vraie contrainte historique

La limitation que vous mentionniez — les noms à **2 caractères maximum** — s'appliquait à l'ancien troff et à nroff. C'est pour cela que `.SH`, `.PP`, `.TH` font exactement 2 caractères. GNU Groff a levé cette limite depuis longtemps, ce qui a permis à `-mom` d'adopter des noms longs lisibles comme `.FOOTNOTE` ou `.TOC`.

## En pratique

Vous pouvez très bien écrire :

```groff
.de maSection
.de Ma_Section
.de masection
```

Les trois sont légaux. Mais si vous mélangez du code avec des packages existants, respecter la convention majuscules/minuscules rend la lecture immédiatement claire : on sait d'un coup d'œil si on lit une primitive du moteur ou une macro de plus haut niveau.

## User

J'aimerai comprendre mieux en détail le fonctionnement des macros. Prenons par exemple la macro NH de package ms. Peux-tu m'aider à comprendre son fonctionnement ?

## Claude

Bonne idée — regardons directement le source. Cherchons d'abord où se trouve le fichier sur le système.

Excellent — on a tout ce qu'il faut. Décortiquons ça ensemble.

---

## Anatomie de la macro `.NH`

La définition réelle s'appelle `@NH` (le `@` est la convention interne de `-ms` pour les macros "privées"). L'alias public `.NH` est branché dessus après l'initialisation.

Voici le source annoté, bloc par bloc :

### Bloc 1 — Le cas spécial `.NH S` (initialisation manuelle)

```groff
.de @NH
.ie '\$1'S' \{\"            ← Si le 1er argument est la lettre "S"...
.  shift                   ←   on le consomme, les suivants deviennent $1, $2…
.  nr nh*hl 0              ←   remet le compteur de niveau à 0
.  while \n[$] \{\"        ←   boucle sur tous les arguments restants
.    nr nh*hl +1           ←     avance le niveau
.    nr H\n[nh*hl] 0\$1    ←     initialise H1, H2, H3… à la valeur fournie
.    shift                 ←     passe à l'argument suivant
.  \}
.  if !\n[nh*hl] \{\"      ←   si aucun argument n'a été traité → erreur
.    nr H1 1
.    nr nh*hl 1
.    @error missing arguments to .NH S
.  \}
\}
```

> `.NH S 0 3 1` permet de **forcer manuellement** les compteurs à des valeurs arbitraires : H1=0, H2=3, H3=1. C'est le seul moyen de reprendre une numérotation à un point précis.

---

### Bloc 2 — Le cas normal `.NH [niveau]`

```groff
.el \{\
.  nr nh*ohl \n[nh*hl]     ← sauvegarde l'ancien niveau dans nh*ohl
.  ie \n[$] \{\"           ← si un argument est fourni...
.    nr nh*hl 0\$1         ←   le niveau courant devient cet argument
.    ie \n[nh*hl]<=0 \{\"  ←   si invalide (0 ou négatif)...
.      nr nh*ohl 0
.      nr nh*hl 1          ←   on force au niveau 1
.    \}
.    el \{\"               ←   sinon : vérification de cohérence
.      if \n[nh*hl]-\n[nh*ohl]>1 \{\"  ← saut de niveau ? (ex: .NH 1 puis .NH 3)
.        @warning ...      ←   avertissement, mais on continue
.      \}
.    \}
.  \}
.  el .nr nh*hl 1          ← sans argument → niveau 1 par défaut
```

Ensuite, la **remise à zéro des sous-niveaux** qui ont été "dépassés" :

```groff
.  while \n[nh*hl]>\n[nh*ohl] \{\"   ← pour chaque niveau entre ancien et nouveau
.    nr nh*ohl +1
.    nr H\n[nh*ohl] 0               ← remet le compteur à 0
.  \}
.  nr H\n[nh*hl] +1                 ← INCRÉMENTE le compteur du niveau courant
\}
```

> Concrètement, si vous étiez en `.NH 2` puis faites `.NH 1`, les registres `H2`, `H3`… sont remis à 0. La prochaine section de niveau 2 repartira bien de 1.

---

### Bloc 3 — Construction de la chaîne de numérotation

```groff
.ds SN-NO-DOT \n(H1         ← commence la chaîne avec H1 (ex: "2")
.nr nh*i 1
.while \n[nh*i]<\n[nh*hl] \{\"   ← boucle du niveau 2 jusqu'au niveau courant
.  nr nh*i +1
.  as SN-NO-DOT .\n[H\n[nh*i]]  ← concatène ".Hn" (ex: ".3", ".1")
\}
.ds SN-DOT \*[SN-NO-DOT].   ← ajoute le point final → "2.3.1."
```

Deux chaînes sont ainsi construites dynamiquement :

| Chaîne | Contenu pour `.NH 2` après `.NH 1` |
|---|---|
| `\*[SN-NO-DOT]` | `2.1` |
| `\*[SN-DOT]` | `2.1.` |
| `\*[SN-STYLE]` | alias vers l'une ou l'autre (par défaut `SN-DOT`) |

---

### Bloc 4 — Le rendu visuel

```groff
.nr sh*psincr (\n[GROWPS]-\n[nh*hl])*\n[PSINCR]   ← calcule la variation de taille
.SH-NO-TAG                   ← applique le style (gras, espacement, taille)
.DEVTAG-NH "\$1"             ← tag pour le backend HTML
\*[SN-STYLE]                 ← imprime le numéro ("2.1." ou "2.1")
```

La taille de police est calculée ainsi :

```
taille finale = taille_base + (GROWPS - niveau) × PSINCR
```

Avec les valeurs par défaut `GROWPS=0` et `PSINCR=1p`, l'incrément est nul — tous les niveaux ont la même taille. Mais si vous posez `.nr GROWPS 3` et `.nr PSINCR 2p`, alors :
- niveau 1 → +4p
- niveau 2 → +2p
- niveau 3 → ±0p

---

## La structure globale des registres impliqués

```
Registres publics (configurables par l'utilisateur)
├── H1, H2, H3…   compteurs par niveau (lus via \n[H1] etc.)
├── GROWPS         seuil à partir duquel la taille diminue
└── PSINCR         pas d'incrément de taille par niveau

Registres internes (préfixe nh*)
├── nh*hl          niveau courant
├── nh*ohl         niveau précédent (pour détection de sauts)
└── nh*i           variable de boucle temporaire

Chaînes construites dynamiquement
├── SN-NO-DOT      "1.2.3"
├── SN-DOT         "1.2.3."
└── SN-STYLE       alias vers l'une des deux (personnalisable)
```

---

## Ce que cette macro enseigne sur Groff en général

1. **La convention `@NOM`** sert de "privé" — les macros internes du package sont préfixées `@` pour éviter les collisions avec l'utilisateur.
2. **Les registres servent d'état global** — `nh*hl` joue le rôle d'une variable d'instance persistante entre les appels.
3. **`.as` permet la construction de chaînes en boucle** — c'est le seul moyen de construire dynamiquement `"1.2.3"` sans récursion.
4. **La séparation style/logique** — `.SH-NO-TAG` est délibérément séparée pour être surchargeable sans toucher à la logique de numérotation.
5. **`.als` pour les alias publics** — le package expose `.NH` comme alias de `@NH`, ce qui lui permet de redéfinir `@NH` sans casser les documents existants.

Voulez-vous qu'on explore d'autres macros du package, ou approfondir un de ces mécanismes — les diversions (`.di`), les environnements (`.ev`), ou les traps (`.wh`) qu'on aperçoit dans le reste du fichier ?

## User

oui, peux-tu approfondir les environnements ?

## Claude

Commençons par observer comment `-ms` les utilise concrètement :

J'ai tout ce qu'il faut. Voici une explication complète.

---

## Les environnements dans GNU Groff

### Qu'est-ce qu'un environnement ?

Un environnement est un **bloc d'état typographique** isolé. Groff maintient en permanence un *environnement courant*, et tous les réglages de mise en page agissent sur lui seul. Switcher d'environnement, c'est comme empiler un nouveau contexte de rendu.

Ce qu'un environnement contient :

| Catégorie | Exemples |
|---|---|
| Fonte et taille | police courante, taille (`.ps`), interligne (`.vs`) |
| Géométrie de ligne | longueur (`.ll`), indentation (`.in`), retrait du 1er alinéa |
| Alignement | justification (`.ad`), centrage (`.ce`), remplissage (`.fi`/`.nf`) |
| État du tampon de ligne | le texte partiellement collecté, non encore sorti |
| Tabulations | positions de tabulation (`.ta`) |
| Espacement | interligne, espacement inter-paragraphe |

Ce qu'un environnement **ne contient pas** :
- les registres numériques (`.nr`) → globaux
- les chaînes (`.ds`) → globales
- les définitions de macros → globales
- l'état de la page (position verticale, numéro de page)

---

### Les requêtes fondamentales

```groff
.ev nom     ← passe à l'environnement "nom" (le crée s'il n'existe pas)
.ev         ← sans argument : revient à l'environnement précédent (pop)
```

C'est une **pile** (stack). Chaque `.ev nom` empile un nouveau contexte, chaque `.ev` sans argument le dépile. Le registre en lecture seule `\n[.ev]` contient le nom de l'environnement courant.

```groff
.tm Env courant : \n[.ev]   \" → affiche "0" par défaut
.ev monenv
.tm Env courant : \n[.ev]   \" → affiche "monenv"
.ev
.tm Env courant : \n[.ev]   \" → affiche "0" de nouveau
```

Deux autres requêtes utiles :

```groff
.evc source   ← copie tout l'état de l'environnement "source" dans le courant
```

---

### Les environnements de `-ms` décortiqués

En fouillant `s.tmac`, on voit que le package crée **4 environnements nommés** en plus de l'environnement `0` (le document principal) :

| Nom | Rôle |
|---|---|
| `0` | Environnement par défaut, corps du document |
| `h` | En-têtes et pieds de page (`.PT`, `.BT`) |
| `fn` | Notes de bas de page (`.FS`/`.FE`) |
| `k` | Blocs flottants / keeps (`.KS`/`.KF`/`.KE`) |
| `nf` | Environnement "no-fill" pour texte verbatim |
| `ne` | Environnement temporaire d'initialisation |

Regardons ce que fait `-ms` à chaque fois qu'il entre dans `fn` (les notes de bas de page) :

```groff
.de @FS              \" début de note
.ev fn               \" ← empile l'environnement "fn"
.par@reset-env       \" remet les marges à zéro dans cet env
.da fn@div           \" dirige la sortie vers une diversion
.if !\n[fn@height] .ns
...

.de @FE              \" fin de note
.br
.ev                  \" ← dépile → retour à l'environnement d'avant
.di                  \" ferme la diversion
...
```

**Tout ce qui est tapé entre `.FS` et `.FE` est rendu dans l'environnement `fn`**, avec sa propre taille de police (`FPS`), son interligne (`FVS`), sa longueur de ligne (`FL`) — sans jamais contaminer le corps du texte.

---

### La technique avancée : `\n[.ev]` comme clé de namespacing

C'est le point le plus subtil, visible dans `par@reset-env` :

```groff
.de par@reset-env
.nr \n[.ev]:il 0       \" indentation gauche de CET environnement
.nr \n[.ev]:li 0
.nr \n[.ev]:ri 0
.nr \n[.ev]:ai \n[\n[.ev]:PI]
...
```

Puisque les registres sont globaux, `-ms` les **préfixe dynamiquement avec le nom de l'environnement courant** via `\n[.ev]`. Quand on est dans `fn`, `\n[.ev]` vaut `fn`, donc le registre s'appelle `fn:il`. Dans `h`, il s'appelle `h:il`. Chaque environnement a ainsi son propre jeu de registres de mise en page, sans collision.

```groff
.ev fn
.nr \n[.ev]:PS 9000     \" = .nr fn:PS 9000  (taille police notes = 9pt en millipoints)
.ev h
.nr \n[.ev]:PS 11000    \" = .nr h:PS 11000  (taille police entêtes = 11pt)
.ev
```

Et `.aln` crée des **alias de registres** pour que les noms publics `PS`, `VS`, `LL` pointent automatiquement vers le bon registre selon l'environnement actif :

```groff
.aln \n[.ev]:PS PS     \" PS est un alias vers fn:PS quand on est dans fn
```

---

### Un exemple complet pour illustrer l'isolation

```groff
.\" Corps du document : police 12pt, justifié
.ps 12
.ad b

Un paragraphe normal en 12pt, justifié des deux côtés.

.\" Passage dans un environnement personnalisé
.ev encadre
.ps 10
.ad l
.ll 4i
.in 0.5i

Ce texte est dans l'environnement "encadre" :
10pt, aligné gauche, marge plus étroite.
Rien de tout cela n'affecte le corps principal.

.ev             \" ← retour automatique à l'état d'avant

La suite du corps : 12pt et justifié, comme si de rien n'était.
```

---

### Le piège classique : le tampon de ligne

Un environnement stocke aussi **le texte en cours de collecte** (la ligne en cours de remplissage). Si vous switchez d'environnement au milieu d'une ligne, le tampon de l'environnement précédent est suspendu, pas vidé. Il reprend exactement où il en était au retour.

```groff
Un début de phrase
.ev autre
.br          \" IMPORTANT : vider le tampon AVANT de switcher si nécessaire
...
.ev
```

C'est pourquoi on voit quasi-systématiquement `.br` juste avant `.ev` dans le source de `-ms`.

---

### Récapitulatif visuel

```
          ┌─────────────────────────────────────────┐
          │            ÉTAT GLOBAL                  │
          │  registres (.nr), chaînes (.ds),         │
          │  macros (.de), position page             │
          └────────────────┬────────────────────────┘
                           │ partagé par tous
          ┌────────────────▼────────────────────────┐
          │           PILE D'ENVIRONNEMENTS          │
          │                                         │
          │  ┌─────────────────────┐  ← sommet      │
          │  │ env "fn"            │  (actif)        │
          │  │  ps=9  ll=3i  ad=l  │                 │
          │  │  tampon: "voir no…" │                 │
          │  └──────────┬──────────┘                 │
          │  ┌──────────▼──────────┐                 │
          │  │ env "0"             │  (suspendu)     │
          │  │  ps=12 ll=6i  ad=b  │                 │
          │  │  tampon: "…du text" │                 │
          │  └─────────────────────┘                 │
          └─────────────────────────────────────────┘
                  .ev     → pop (retour à "0")
                  .ev fn  → push (entre dans "fn")
```

---

En résumé, les environnements sont le mécanisme qui permet à `-ms` de gérer simultanément le corps, les notes, les en-têtes et les blocs flottants **avec des typographies complètement différentes**, sans jamais avoir à sauvegarder et restaurer manuellement chaque paramètre. Voulez-vous qu'on explore les **diversions** (`.di`/`.da`) qui travaillent souvent de pair avec les environnements ?

## User

Oui, explique moi les diversions.

## Claude

Commençons par observer comment `-ms` les utilise :

Parfait, j'ai tout ce qu'il faut. Voici l'explication complète.

---

## Les diversions dans GNU Groff

### Le principe fondamental

En fonctionnement normal, Groff envoie le texte formaté directement vers la **sortie** (la page). Une diversion court-circuite ce flux : le texte est **collecté dans un tampon nommé** plutôt qu'imprimé. On peut ensuite relire ce tampon plus tard, à un endroit ou un moment différent.

```
Flux normal :    texte → formatage → page
Avec diversion : texte → formatage → tampon nommé → (plus tard) → page
```

---

### Les requêtes de base

```groff
.di NOM      ← ouvre une diversion, écrase le contenu existant de NOM
.da NOM      ← ouvre une diversion en mode append (concatène)
.di          ← ferme la diversion courante (sans argument)
```

Une fois fermée, la diversion se relit **comme une macro** :

```groff
.di monbloc
Contenu capturé.
.br
Deuxième ligne.
.di          ← ferme

.\" ... plus loin dans le document ...

.monbloc     ← rejoue le contenu à cet endroit
```

---

### Les registres automatiques après fermeture

À chaque fermeture de diversion (`.di` sans argument), Groff renseigne deux registres en lecture seule :

| Registre | Contenu |
|---|---|
| `\n[dn]` | Hauteur totale du contenu capturé (en unités de base) |
| `\n[dl]` | Largeur maximale d'une ligne dans la diversion |

C'est ce qui permet à `-ms` de savoir combien de place prend une note de bas de page **avant** de décider où la placer :

```groff
.di
.nr fn*page-bottom-pos -\n[dn]   \" ← recule le bas de page de la hauteur de la note
```

Le registre `\n[.z]` (lecture seule) donne le **nom de la diversion courante**, ou la chaîne vide si on est dans le flux normal :

```groff
.if !'\n[.z]'' .@error on est déjà dans une diversion !
```

---

### `.di` vs `.da` : écraser ou accumuler

```groff
.di notes     ← repart de zéro à chaque appel
Note 1.
.di

.da notes     ← concatène au contenu existant
Note 2.
.di

.notes        ← affiche "Note 1.\nNote 2."
```

C'est exactement ce que fait la table des matières dans `-ms` :

```groff
.de @XS
.da toc*div       \" ← append : chaque titre s'accumule dans toc*div
.ev h
...
```

Chaque `.NH` ou `.SH` ajoute son entrée à `toc*div`. La macro `.TC` (table of contents) rejoue enfin `toc*div` en une seule fois en fin de document.

---

### Le cycle complet : capture, mesure, relecture, suppression

Voici le pattern systématiquement utilisé dans `-ms` :

```groff
.\"  1. CAPTURE
.di monbloc
.ev special         \" environnement dédié
...contenu...
.br
.ev                 \" retour à l'env précédent
.di                 \" fermeture → dn et dl sont renseignés

.\"  2. MESURE
.nr hauteur \n[dn]  \" on peut maintenant raisonner sur la taille

.\"  3. DÉCISION (ex: tient-il sur la page ?)
.if \n[.t]>\n[hauteur] \{\
.  monbloc          \" 4a. RELECTURE inline
.\}

.\"  5. NETTOYAGE
.rm monbloc         \" libère la mémoire
```

> `.rm` supprime la définition. Sans lui, la diversion reste en mémoire indéfiniment comme une macro ordinaire.

---

### Les trois usages dans `-ms`

#### 1. La page de titre (`TL`) — diversion différée

```groff
.de TL
.di cov*tl-div    ← tout ce qui suit TL est capturé...
.ft B
.ps +2
...

.de @AU            ← .AU ferme la diversion titre et en ouvre une nouvelle
.br
.di                ← ferme cov*tl-div
.di cov*au-div!\n[cov*n-au]  ← nouvelle diversion par auteur
```

Le titre, les auteurs, l'institution (`AI`) sont chacun capturés dans des diversions séparées. La macro `cov*print` les rejoue ensuite dans l'ordre correct avec la mise en page de couverture — indépendamment de l'ordre dans lequel l'utilisateur les a écrits.

#### 2. Les notes de bas de page (`FS`/`FE`) — diversion + trap

```groff
.de fn*start-div
.da fn@div          ← append : les notes s'accumulent page par page
...

.de fn*end-div
.di                 ← ferme
.nr fn*page-bottom-pos -\n[dn]   ← remonte la limite basse de la page
.ch pg@bottom \n[fn*page-bottom-pos]u  ← repositionne le trap de pied de page
```

La hauteur mesurée (`\n[dn]`) sert directement à recalculer la position du **trap** de fin de page, pour que le texte courant s'arrête exactement là où les notes commencent. C'est l'interaction clé entre diversions et traps — on y reviendra.

Si les notes débordent sur la page suivante, `-ms` les renomme :

```groff
.rn fn@div fn@overflow-div   ← la diversion débordante change de nom
```

#### 3. Les blocs flottants (`KS`/`KF`/`KE`) — diversion avec file d'attente

```groff
.de KF
.di kp@fdiv      ← capture le bloc
.ev k            ← dans son propre environnement

.de kp*fend
.di              ← ferme
.ie \n[.t]>\n[dn] \{\"  ← tient sur la page courante ?
.  kp@fdiv       ← oui : on le sort immédiatement
.\}
.el \{\
.  rn kp@fdiv kp@div!\n[kp@tail]  ← non : mis en file d'attente
.  nr kp*ht!\n[kp@tail] \n[dn]    ← sa hauteur est mémorisée
.  nr kp@tail +1                   ← avance le curseur de queue
.\}
```

Les blocs flottants sont stockés dans une **file nommée dynamiquement** (`kp@div!0`, `kp@div!1`…) et ressortis à la prochaine page qui a assez de place.

---

### La sortie transparente `\!` dans les diversions

Quand du texte est capturé dans une diversion puis rejoué, les requêtes sont exécutées **au moment du rejeu**, pas au moment de la capture. Mais parfois on veut forcer l'exécution **lors du rejeu dans un contexte de diversion imbriquée**. C'est le rôle de `\!` :

```groff
.di externe
\!.fn*embed-start \n[fn*embed-count]   ← cette requête sera exécutée
.\"                                       quand "externe" sera rejoué,
.\"                                       même si ce rejeu est lui-même
.\"                                       dans une autre diversion
.di
```

`\!` préfixe une ligne pour qu'elle soit traitée comme une **requête transparente** : elle traverse une couche de diversion supplémentaire sans être interprétée tout de suite.

---

### Récapitulatif visuel

```
  .di NOM ──────────────────────────────────────────┐
                                                     │ capture
  texte + requêtes formatés                          ▼
  (env courant appliqué)                      tampon "NOM"
                                                     │
  .di ─────── fermeture ──── \n[dn], \n[dl] renseignés
                                                     │
        ┌────────────────────────────────────────────┤
        │                                            │
        ▼ .NOM              ▼ .da NOM          ▼ .rm NOM
   rejeu immédiat        re-ouvre en        supprime
   (comme une macro)     mode append        le tampon
```

---

### Ce que les diversions permettent que rien d'autre ne peut faire

| Besoin | Mécanisme |
|---|---|
| Table des matières en fin de document | `.da` + relecture finale |
| Notes de bas de page repositionnées | `.di` + mesure `\n[dn]` + trap |
| Blocs flottants (figures, tableaux) | `.di` + file d'attente de diversions |
| Page de titre assemblée hors ordre | Plusieurs `.di` + relecture ordonnée |
| Mesurer un bloc avant de décider où le mettre | `.di` + `\n[dn]` + condition |

Voulez-vous qu'on explore les **traps** (`.wh`, `.ch`, `.dt`) qui sont l'autre moitié du mécanisme de pagination — et qui travaillent en tandem avec les diversions comme on vient de l'entrevoir ?

## User

Oui, regardons maintenant les traps.

## Claude

Commençons par cartographier tous les traps de `-ms` :

J'ai tout ce qu'il faut. Voici l'explication complète.

---

## Les traps dans GNU Groff

### Le principe fondamental

Un trap est une **alarme positionnelle** : on associe une macro à une position sur la page (ou dans un flux), et Groff l'exécute automatiquement quand le crayon virtuel atteint cette position. C'est le mécanisme qui transforme un flux de texte continu en pages structurées.

---

### Les trois familles de traps

#### 1. Traps de page — `.wh` et `.ch`

```groff
.wh position macro    ← plante un trap à cette position
.ch macro  position   ← déplace un trap existant (change position)
.ch macro             ← supprime un trap (sans deuxième argument)
```

La **position** est une mesure verticale sur la page :
- positive → depuis le haut de la page (`0` = tout en haut)
- négative → depuis le bas de la page (`-1i` = 1 pouce avant le bord bas)

```groff
.wh 0    pg@top      ← déclenche pg@top au sommet de chaque nouvelle page
.wh -\n[FM]u   pg@bottom   ← déclenche pg@bottom à FM unités du bas
.wh -\n[FM]u/2u pg*footer  ← déclenche pg*footer à mi-chemin dans la marge
```

Le registre en lecture seule `\n[.t]` donne la **distance jusqu'au prochain trap** — c'est la valeur fondamentale pour savoir s'il reste assez de place sur la page.

---

#### 2. Traps de diversion — `.dt`

```groff
.dt position macro
```

Fonctionne comme `.wh`, mais la position est relative au **contenu de la diversion en cours**, pas à la page. Quand le texte capturé dans une diversion atteint cette hauteur, la macro est déclenchée. Utilisé pour insérer des séparateurs ou détecter un débordement à l'intérieur d'une diversion.

---

#### 3. Traps d'entrée — `.it` et `.itc`

```groff
.it n macro    ← déclenche macro après les n prochaines lignes d'entrée
.itc n macro   ← idem, mais ne compte pas les lignes de continuation
```

Ces traps réagissent au **nombre de lignes lues**, pas à une position spatiale. Utile pour imposer une structure rythmique dans le texte (ex. : forcer un saut après N lignes dans un environnement spécial).

---

#### 4. La macro de fin — `.em`

```groff
.em macro
```

Pas un trap de position, mais son pendant logique : exécute `macro` quand **toute l'entrée a été consommée**. Dans `-ms` :

```groff
.em pg@end-text
```

`pg@end-text` marque la fin du texte (`pg@text-ended = 1`) puis appelle `pg@super-eject` pour vider les blocs flottants et notes restants avant de quitter.

---

### La chorégraphie de pagination de `-ms`

Voici comment les traps s'articulent pour produire une page complète :

```
Position 0 (haut de page)
│
│   .wh 0  pg@top
│   └─→ bascule en env "h"
│       imprime l'en-tête (.PT)
│       rejoue les blocs flottants en attente
│       pose .ns (no-space) pour bloquer les .sp parasites
│
│   ... corps du texte ...
│
│   .wh -FM  pg@bottom          ← FM = taille marge basse
│   └─→ appelle fn@bottom-hook  (sort les notes)
│       appelle pg*end-col ou pg*end-page
│
│   .wh -FM/2  pg*footer
│   └─→ bascule en env "h"
│       imprime le pied de page (.BT)
│       revient à l'env précédent
│
Position -FM (bas de page)
```

Les deux traps du bas sont séparés pour que le **pied de page** s'imprime dans la marge inférieure, **après** la logique de fin de colonne/page.

---

### Le déplacement dynamique des traps avec `.ch`

C'est là que les traps deviennent vraiment puissants. Leur position n'est pas figée — `-ms` les repositionne en temps réel selon le contenu.

**Scénario : une note de bas de page arrive**

```groff
\" 1. Normalement, pg@bottom est à -FM (bas de page standard)
.wh -\n[FM]u pg@bottom

\" 2. Une note est capturée, sa hauteur est mesurée dans \n[dn]
.nr fn*page-bottom-pos -\n[FM]-\n[dn]   \" remonte d'autant

\" 3. On déplace pg@bottom vers le haut pour faire de la place
.ch pg@bottom \n[fn*page-bottom-pos]u
```

```
Avant note :              Après note de 3 lignes :

┌──────────────┐          ┌──────────────┐
│ corps texte  │          │ corps texte  │
│              │          │              │
│              │          ├──────────────┤  ← pg@bottom remonté
│              │          │ ──────────── │  séparateur
│              │          │ [1] note...  │  notes
├──────────────┤          │              │
│ pg@bottom   │          ├──────────────┤
│              │          │ pg*footer   │
└──────────────┘          └──────────────┘
```

**Scénario : la note déborde**

Si la note est trop grande pour tenir sur la page courante, `-ms` plante un **trap temporaire** pour capturer le débordement :

```groff
.wh \n[fn@bottom-pos]u fn*catch-overflow

.de fn*catch-overflow
.di fn@overflow-div    ← redirige tout ce qui suit dans une diversion de débordement
..
```

Ce trap sera déclenché si le texte courant descend trop bas. Il ouvre une diversion qui capture le surplus de notes, lequel sera réinjecté en haut de la page suivante par `fn@top-hook`.

---

### La page de couverture : neutraliser les traps

Pour la page de couverture, `-ms` **déplace les traps hors de portée** :

```groff
.de pg@cs-top
.ch pg@bottom \n[.p]u*2u    ← deux fois la hauteur de page = jamais atteint
.ch pg*footer \n[.p]u*2u    ← idem
.ns
..
```

Multiplier par 2 la hauteur de page garantit que le trap ne sera jamais déclenché naturellement — c'est l'équivalent d'un "désactiver" puisqu'il n'existe pas de requête pour supprimer un trap de page sans en planter un autre.

---

### La macro de fin et `pg@super-eject`

`.em pg@end-text` garantit que le document ne se termine jamais brutalement :

```groff
.de pg@end-text
.br
.nr pg@text-ended 1
.pg@super-eject           ← vide la file des blocs flottants
..

.de pg@super-eject
.while \n[kp@tail]>\n[kp@head]:\n[pg@fn-flag] \{\
.  rs
.  bp                    ← force autant de sauts de page que nécessaire
\}
.bp
..
```

La boucle force des sauts de page supplémentaires tant qu'il reste des blocs flottants (`kp@tail > kp@head`) ou des notes débordantes (`fn@fn-flag`).

---

### Récapitulatif visuel : les trois types

```
.wh pos  MACRO    Trap de PAGE
│  déclenché quand le crayon vertical atteint "pos"
│  pos > 0 : depuis le haut
│  pos < 0 : depuis le bas
│  modifiable à tout moment avec .ch
│
.dt pos  MACRO    Trap de DIVERSION
│  déclenché à "pos" unités dans la diversion courante
│  réinitialisé à chaque nouvelle diversion
│
.it n    MACRO    Trap d'ENTRÉE
│  déclenché après n lignes d'entrée lues
│  consommé après déclenchement (one-shot)
│
.em      MACRO    Fin de document
   déclenché une seule fois, après la dernière ligne d'entrée
```

---

### Ce que les traps permettent

| Besoin | Mécanisme |
|---|---|
| En-têtes et pieds de page automatiques | `.wh 0` + `.wh -FM` |
| Réserver la place des notes de bas de page | `.ch pg@bottom` après mesure `\n[dn]` |
| Capturer le débordement de notes | `.wh` temporaire + diversion |
| Désactiver la pagination sur la couverture | `.ch` vers position hors portée |
| Vider les blocs flottants en fin de document | `.em` + boucle de sauts de page |

Les traps sont donc le **chef d'orchestre** de la pagination : les diversions collectent le contenu, les environnements isolent les styles, et les traps décident *quand* et *où* tout cela s'assemble sur la page.

Voulez-vous qu'on conclue le tour d'horizon avec les **registres d'état de page** (`\n[nl]`, `\n[.t]`, `\n[.p]`, `\n[%]`…) qui sont les capteurs que les traps et macros lisent en permanence pour prendre leurs décisions ?

## User

Ok, finissons ce tour d'horizon.

## Claude

Commençons par inventorier ce que `-ms` consulte réellement :

J'ai tout ce qu'il faut. Voici la synthèse complète.

---

## Les registres d'état de Groff

Groff expose en permanence l'état interne du moteur via des registres en **lecture seule**, tous préfixés par un point. Ce sont les "capteurs" que les macros interrogent pour prendre leurs décisions. Ils se regroupent en cinq familles.

---

### Famille 1 — Position verticale sur la page

Ce sont les registres les plus consultés dans tout package de macros.

| Registre | Contenu |
|---|---|
| `\n[nl]` | Position verticale absolue du crayon depuis le haut de la page courante, en unités de base. C'est **la position courante**. |
| `\n[.d]` | Identique à `nl` hors diversion. Dans une diversion, indique la position courante **dans la diversion**. |
| `\n[.h]` | La "laisse haute" (*high-water mark*) : la ligne la plus basse jamais atteinte sur la page courante. Ne recule jamais. |
| `\n[.t]` | Distance jusqu'au **prochain trap** (ou jusqu'au bas de page s'il n'y en a pas). C'est la marge de manœuvre restante. |
| `\n[.p]` | Hauteur totale de la page (`.pl`). |

La décision fondamentale de tout block flottant dans `-ms` s'écrit exactement :

```groff
.ie \n[.t]>\n[dn] \{\"   ← "est-ce que la place restante > hauteur du bloc ?"
.  kp@fdiv              ←   oui : on sort le bloc maintenant
.\}
.el \{\"
.  rn kp@fdiv kp@div!\n[kp@tail]  ← non : on le met en file d'attente
.\}
```

Et pour forcer un saut de page si nécessaire :

```groff
.de ds@need
.while \n[.t]<=(\$1)&(\n[nl]>\n[pg@header-bottom]) \{\
.  rs
'  sp \n[.t]u    ← saute jusqu'au trap, ce qui déclenche pg@bottom → bp
\}
..
```

---

### Famille 2 — Numéro et contrôle de page

| Registre | Contenu |
|---|---|
| `\n[%]` | Numéro de la page courante. Incrémenté à chaque `.bp`. Modifiable avec `.pn`. |
| `\n[.pe]` | Vaut 1 pendant l'exécution d'un saut de page (entre `.bp` et le prochain trap de haut de page). Utile pour ne pas déclencher certaines actions en plein saut. |
| `\n[.ne]` | Espace réservé par le dernier `.ne` qui a déclenché un saut de page. |
| `\n[.trunc]` | Espace vertical tronqué par le dernier trap de page (ce qui a été "avalé" pour atteindre le trap). |

---

### Famille 3 — Géométrie de ligne (environnement courant)

Ces registres reflètent l'état de **l'environnement actif** à l'instant de la lecture.

| Registre | Contenu |
|---|---|
| `\n[.l]` | Longueur de ligne courante (`.ll`). |
| `\n[.i]` | Indentation courante (`.in`). Alias `\n[.in]` (identique). |
| `\n[.k]` | Position horizontale du crayon dans la ligne en cours de collecte, relative à l'indentation. Vaut 0 en début de ligne. |
| `\n[.n]` | Longueur de la **dernière ligne** effectivement sortie. |
| `\n[.v]` | Interligne courant (`.vs`). |
| `\n[.j]` | Mode d'ajustement courant (`.ad`) : 0=gauche, 1=deux côtés, 3=centre, 5=droite. |
| `\n[.u]` | 1 si le mode fill est actif (`.fi`), 0 si `.nf`. |

La combinaison `\n[.k]` et `\n[.l]` permet de savoir si on est en début de ligne et combien d'espace reste sur la ligne courante — `-ms` l'utilise pour décider s'il faut terminer la ligne avant d'insérer un bloc :

```groff
.ie \n[.t]-(\n[.k]>0*1v)>\n[dn] \{\  ← si une ligne est en cours (\n[.k]>0),
.\"                                       on soustrait une ligne supplémentaire
```

---

### Famille 4 — Fonte et typographie

| Registre | Contenu |
|---|---|
| `\n[.f]` | Numéro de position de la fonte courante. |
| `\n[.fn]` | Nom de la fonte courante (registre de type chaîne). |
| `\n[.fam]` | Famille de fonte courante. |
| `\n[.s]` | Taille de police courante en points (entier). |
| `\n[.ps]` | Taille en *scaled points* (millièmes de points — plus précis que `.s`). |
| `\n[.ev]` | Nom de l'environnement courant. Fondamental pour le namespacing vu la session précédente. |

---

### Famille 5 — Diversions et glyphes

| Registre | Contenu |
|---|---|
| `\n[.z]` | Nom de la diversion courante. Chaîne vide si on est dans le flux normal. |
| `\n[dn]` | Hauteur de la dernière diversion fermée. Disponible juste après `.di` sans argument. |
| `\n[dl]` | Largeur maximale de la dernière diversion fermée. |
| `\n[.h]` | Laisse haute dans la diversion courante (réinitialisée à l'entrée de chaque diversion). |
| `\n[.w]` | Largeur du dernier glyphe sorti. |
| `\n[.cht]` | Hauteur du dernier glyphe (au-dessus de la ligne de base). |
| `\n[.cdp]` | Profondeur du dernier glyphe (descendantes, sous la ligne de base). |

---

### Famille 6 — Source et débogage

| Registre | Contenu |
|---|---|
| `\n[.F]` | Nom du fichier source en cours de lecture. |
| `\n[.c]` | Numéro de ligne dans le fichier source courant. |
| `\n[.H]` | Résolution horizontale du périphérique de sortie (unités par pouce). |
| `\n[.V]` | Résolution verticale du périphérique de sortie. C'est le **plus petit déplacement vertical possible**. |

`\n[.V]` est particulièrement important : c'est le quantum vertical du périphérique. Dans les calculs de position, `-ms` l'utilise pour éviter des valeurs nulles ou des positions impossibles :

```groff
.if \n[nl]+\n[fn@sep-dist]+\n[.V]>\n[fn@bottom-pos] \{\
.\"          ↑ ajoute un quantum pour tester la limite stricte
```

---

### Carte mentale complète

```
                    ┌─ \n[%]         numéro de page
                    ├─ \n[.p]        hauteur de page
  PAGE              ├─ \n[nl]        position crayon (absolue)
                    ├─ \n[.t]   ←──── distance au prochain trap  ← clé de décision
                    ├─ \n[.h]        laisse haute
                    └─ \n[.pe]       en cours de saut ?

                    ┌─ \n[.l]        longueur de ligne
  LIGNE             ├─ \n[.i]        indentation
  (env courant)     ├─ \n[.k]        position horizontale courante
                    ├─ \n[.n]        longueur dernière ligne sortie
                    └─ \n[.v]        interligne

                    ┌─ \n[.z]        nom de la diversion courante
  DIVERSION         ├─ \n[.d]        position dans la diversion
                    ├─ \n[dn]        hauteur (après fermeture)
                    └─ \n[dl]        largeur (après fermeture)

                    ┌─ \n[.f]        fonte courante
  FONTE             ├─ \n[.s]        taille courante
                    └─ \n[.ev]       environnement courant

                    ┌─ \n[.H]        quantum horizontal
  PÉRIPHÉRIQUE      └─ \n[.V]        quantum vertical
```

---

### Ce que ce tour d'horizon révèle sur l'architecture de Groff

En prenant du recul, les cinq mécanismes s'articulent en une seule machine cohérente :

```
  REGISTRES D'ÉTAT    ← le moteur expose son état en temps réel
       ↓ lus par
  MACROS & REQUÊTES   ← la logique de mise en page
       ↓ produisent du texte dans
  ENVIRONNEMENTS      ← contextes typographiques isolés
       ↓ dont la sortie est redirigée par
  DIVERSIONS          ← tampons de texte formaté mesurable
       ↓ dont la position déclenchent
  TRAPS               ← alarmes positionnelles
       ↓ qui rappellent
  MACROS & REQUÊTES   ← bouclage : la pagination est une boucle de rétroaction
```

Groff est fondamentalement un système de **flux avec rétroaction** : le texte descend sur la page, les traps détectent les positions critiques, les macros mesurent via les registres et les diversions, et repositionnent les traps pour la page suivante. C'est cette architecture — héritée de nroff en 1971 — qui reste sous le capot de chaque document `-ms` ou `-man` produit aujourd'hui.

## User

quelle macro conseille tu pour écrire avec groff aujourd'hui ?

## Claude

Bonne question — la réponse dépend vraiment de l'usage. Voici mon analyse honnête.

---

## Les packages disponibles aujourd'hui

### `-man` / `-mdoc` — pour les pages de manuel uniquement

Si vous écrivez des pages de man, la question ne se pose pas : `-man` est le standard universel, `-mdoc` (BSD) en est la variante sémantique plus moderne. En dehors de cet usage précis, ils ne sont pas conçus pour de la rédaction générale.

---

### `-ms` — solide mais daté

C'est le package qu'on vient de disséquer ensemble. Il est bien supporté, bien documenté, et sa mécanique interne est élégante. Mais son interface utilisateur porte ses 50 ans : peu d'arguments aux macros, personnalisation par registres globaux, syntaxe parfois incohérente. Correct pour des documents techniques simples, mais il faut accepter ses rugosités.

---

### `-mm` — à éviter

Originaire d'AT&T, il est dans groff pour compatibilité historique. Sa documentation est lacunaire dans la version GNU et la communauté qui le maintient est quasi-inexistante. Pas de raison de le choisir aujourd'hui.

---

### `-mom` — ma recommandation principale

C'est le package écrit spécifiquement pour GNU groff moderne, par Peter Schaffter, avec une philosophie radicalement différente : **lisible, cohérent, et complet**.

Ce qui le distingue concrètement :

**L'interface est en langage naturel**
```groff
.FAMILY  Libertinus
.FONT    R
.PT_SIZE 11
.LS      14

.HEADING 1 "Introduction"
.PP
Texte du paragraphe.

.FOOTNOTE
Ceci est une note.
.FOOTNOTE END
```

Pas de mnémoniques à deux lettres, pas de registres globaux obscurs à deviner.

**Il gère nativement** ce que `-ms` fait laborieusement : colonnes, lettrines, encadrés, marges asymétriques, styles de titres hiérarchiques configurables, table des matières automatique avec liens PDF, notes de bas de page et de fin de document, index.

**La documentation est exceptionnelle** — plusieurs centaines de pages en HTML, écrites par l'auteur lui-même, avec des exemples pour chaque macro. C'est rare dans l'écosystème groff.

```groff
.PRINTSTYLE TYPESET        \" ou TYPEWRITE pour rendu machine à écrire
.START

.DOC_TITLE "Mon document"
.AUTHOR    "Nom Auteur"
.DRAFT off

.HEADING 1 NAMED intro "Introduction"
.PP
Premier paragraphe...
```

---

### Le cas particulier : écrire du groff à la main en 2026

Il faut être honnête : pour de la **documentation longue** (livres, rapports), les alternatives modernes comme **AsciiDoc → PDF via Asciidoctor** ou **Pandoc Markdown → PDF via LaTeX** ont une courbe d'apprentissage plus faible et un écosystème d'outils plus riche.

Groff reste pertinent dans des cas précis :

- Pages de man (incontournable)
- Documents qui doivent être générés avec des outils POSIX uniquement, sans dépendances lourdes
- Systèmes embarqués ou environnements minimalistes
- Goût personnel pour le contrôle fin et la compréhension de ce qui se passe réellement
- Pipeline de génération scriptée où la légèreté de groff est un avantage

---

## Résumé

| Besoin | Recommandation |
|---|---|
| Pages de man | `-man` ou `-mdoc` |
| Document général, apprentissage | `-mom` |
| Compatibilité avec du code existant | `-ms` |
| Système minimaliste, scripting | `-ms` ou requêtes primitives directement |

Si vous partez de zéro aujourd'hui, **`-mom` est clairement le meilleur choix** : il capitalise sur tout ce qu'on a vu ensemble (environnements, diversions, traps) en vous en protégeant derrière une interface cohérente, tout en vous laissant descendre au niveau primitif quand vous en avez besoin.

## User

Je veux compiler un ensemble de note sur la ligne de commande et le terminal sous Linux. Je commencerai en introduisant bash, puis en montrant les différentes catégories de ligne de commande (sans être exhaustif: navigation de fichier, réseau, gestion de package, manipulation de texte). Je pensais ensuite enchaîner sur le terminal, ses codes pour introduire les TUI, avec l'iconique vim. Groff me semblait un usage intéressant pour montrer la puissance des outils cachés et historique et qui sont maintenant oubliés.

## Claude

Beau projet — cohérent et progressif. Quelques réflexions avant de vous lancer.

---

## Sur la structure générale

L'arc narratif que vous décrivez est solide : on part du shell (bash), on monte en abstraction vers les outils (commandes), puis on plonge dans la couche basse du terminal (codes d'échappement, TUI), et on conclut avec des outils "archéologiques" qui montrent que cette couche basse a toujours été là. C'est une bonne progression pédagogique.

Une suggestion de découpage :

```
Partie 1 — Le shell
  Bash : syntaxe, variables, expansions, redirections, pipes
  Le processus de démarrage (profile, bashrc, PATH)

Partie 2 — Les outils
  Navigation et fichiers     (ls, find, fd, tree…)
  Manipulation de texte      (grep, sed, awk, cut, sort, uniq…)
  Réseau                     (curl, wget, ss, ip, dig, nmap…)
  Gestion de paquets         (apt/dnf/pacman selon la cible)

Partie 3 — Le terminal
  Codes ANSI / séquences d'échappement
  Terminfo / termcap
  Les TUI : qu'est-ce que c'est, comment ça marche
  Vim comme étude de cas centrale

Partie 4 — Les outils historiques
  Groff : la typographie en ligne de commande
  (éventuellement : make, m4, lex/yacc selon votre ambition)
```

---

## Sur le choix de Groff comme conclusion

C'est le bon angle, mais attention au risque de rupture de ton. Groff est fascinant précisément parce qu'il préfigure des concepts qu'on retrouve ailleurs — le pipe de préprocesseurs (`pic | tbl | eqn | groff`), la séparation contenu/rendu, les macros comme langage de transformation. Si vous le présentez sous cet angle-là — *Groff comme archétype d'une philosophie Unix* — plutôt que comme un simple outil de typo, il s'intègre naturellement dans la continuité du document.

Le fil conducteur pourrait être : "les outils Unix ne font qu'une chose, mais ils se composent". Bash + pipes, sed + awk, groff + preprocesseurs — c'est le même principe à chaque niveau.

---

## Sur le format du document lui-même

Vous parliez de compiler des notes — est-ce que l'intention est de produire un document à partager (PDF, HTML), ou plutôt un ensemble de fichiers de référence personnelle ? Et envisagez-vous d'écrire ce document **en groff** (ce qui serait une mise en abyme intéressante pour la partie finale), ou dans un autre format ?

Ça conditionne beaucoup le choix du macro package et l'organisation des fichiers source.

## User

Je prenais comme défis de l'écrire en groff, avec l'aide de claude code. Est-ce une bonne idée ?

## Claude

C'est une excellente idée, pour plusieurs raisons — mais avec les yeux ouverts sur les contraintes.

---

## Pourquoi c'est une bonne idée

**La mise en abyme pédagogique est réelle.** Écrire un document sur les outils Unix *avec* un outil Unix historique, en ligne de commande, est cohérent jusqu'au bout. Ça donne une légitimité supplémentaire au chapitre sur Groff — vous n'en parlez pas de l'extérieur, vous l'avez pratiqué.

**Claude Code est bien adapté à ce type de projet.** Groff est verbeux et répétitif — définir un style cohérent, gérer les macros de mise en page, déboguer les espacements — c'est exactement le genre de tâche où un assistant qui voit vos fichiers et peut compiler/tester en boucle apporte beaucoup. Vous restez maître du contenu, Claude gère la plomberie typographique.

**Vous avez maintenant le bagage conceptuel.** Après cette session, vous comprenez ce que fait `-mom` sous le capot. Vous ne serez pas bloqué par un comportement mystérieux d'un environnement ou d'un trap — vous savez où chercher.

---

## Les contraintes à anticiper

**Groff n'est pas fait pour être écrit en fragments.** Un livre en groff, c'est naturellement un fichier maître avec des `.so` ou `.mso` pour inclure les chapitres. Il faut définir cette structure dès le départ, sinon les numérotations, la table des matières et les styles de titre deviennent incohérents.

**Les exemples de code seront votre principal défi typographique.** Un document sur bash et vim va contenir beaucoup de blocs de code — avec indentation, caractères spéciaux, coloration éventuelle. En `-mom` c'est gérable avec `.CODE` et `.CODE END`, mais ça demande une macro bien définie dès le début.

**Le workflow de prévisualisation doit être fluide.** Si compiler et voir le résultat prend 10 secondes et 3 commandes, vous perdrez votre élan. Avec Claude Code, définissez un `Makefile` dès le premier jour :

```makefile
PDF = document.pdf
SRC = main.ms chapitres/*.ms

$(PDF): $(SRC)
	groff -mom -Tpdf main.ms > $(PDF)

watch:
	while inotifywait -e modify $(SRC); do make; done
```

---

## Comment bien démarrer avec Claude Code

Le risque principal est de laisser Claude Code générer du groff sans contraintes, et de vous retrouver avec un style incohérent entre les chapitres. La bonne approche :

**Première session : définir uniquement la structure et le style**, pas le contenu. Demandez à Claude Code de produire un fichier `style.mom` qui définit toutes vos macros personnalisées — blocs de code, notes, commandes inline, avertissements — et un `main.mom` vide qui l'inclut. Compilez, vérifiez que ça ressemble à ce que vous voulez, validez avant d'écrire une ligne de contenu.

**Ensuite, travaillez chapitre par chapitre.** Claude Code peut vous aider à traduire vos notes en groff, déboguer les espacements bizarres, ou proposer une macro quand vous avez besoin d'un élément répétitif nouveau.

**Gardez le contenu sous votre contrôle.** C'est votre expertise sur bash, vim et les outils Unix qui a de la valeur — pas celle de Claude. Utilisez-le pour la forme, pas pour le fond.

---

## Ma suggestion concrète

Commencez par une session Claude Code avec ce brief précis :

> "Je veux écrire un document technique en GNU groff avec le package `-mom`. Le document contient beaucoup de blocs de code shell, des commandes inline dans le texte, et des notes marginales. Crée-moi la structure de fichiers et un fichier de style complet que je pourrai utiliser comme base, avec un exemple de chaque élément répétitif."

Validez ce socle avant tout le reste. C'est la décision la plus importante du projet — tout le reste en découle.

## User

Puisque tu connais la structure et l'ambition du projet, peux-tu m'écrire un prompt complet pour guider claude code au maximum ?

## Claude

Voici un prompt conçu pour être donné en une seule fois à Claude Code au démarrage du projet.

---

```
# Projet : "La ligne de commande et le terminal sous Linux"
# Document technique écrit en GNU groff avec le package -mom

## Contexte et ambition

Je veux écrire un document technique sur la ligne de commande et le terminal
sous Linux. Le document est destiné à un lecteur technique débutant à
intermédiaire. Il sera écrit entièrement en GNU groff avec le package -mom,
et produit en PDF via :

  groff -mom -Tpdf main.mom > document.pdf

Le document lui-même est une démonstration de la philosophie Unix : des outils
qui font une chose, qui se composent, et qui durent. Groff en est l'exemple
final et la mise en abyme.

## Structure du document

Le document est organisé en quatre parties :

  Partie 1 — Bash
    - Introduction au shell, rôle de bash
    - Syntaxe : variables, expansions, redirections, pipes
    - Démarrage : .profile, .bashrc, PATH

  Partie 2 — Les outils en ligne de commande
    - Navigation et fichiers  (ls, find, tree, fd…)
    - Manipulation de texte   (grep, sed, awk, cut, sort, uniq…)
    - Réseau                  (curl, ss, ip, dig…)
    - Gestion de paquets      (apt / dnf / pacman)

  Partie 3 — Le terminal
    - Codes ANSI et séquences d'échappement
    - Terminfo / termcap
    - Les TUI : définition et fonctionnement
    - Vim comme étude de cas

  Partie 4 — Les outils historiques
    - Groff : typographie en ligne de commande
    - La philosophie Unix : pipe de préprocesseurs, séparation contenu/rendu
    - Groff comme archétype : pic, tbl, eqn, groff

## Structure des fichiers source

Crée l'arborescence suivante :

  document.pdf          ← sortie compilée (ne pas versionner)
  Makefile              ← cible par défaut : PDF, cible watch avec inotifywait
  main.mom              ← fichier maître : inclut style.mom puis les chapitres
  style.mom             ← toutes les définitions de style et macros personnalisées
  chapitres/
    00-avant-propos.mom
    01-bash.mom
    02-outils.mom
    03-terminal.mom
    04-groff.mom

## Ce que je veux dans style.mom

### Mise en page générale
- Format A4, marges de 30mm (haut/bas) et 25mm (gauche/droite)
- Police principale : Libertinus ou Linux Libertine si disponible, sinon Times
- Taille de corps : 11pt, interligne 15pt
- En-tête : titre du chapitre courant (côté extérieur), numéro de page (côté intérieur)
- Pied de page : titre du document centré

### Hiérarchie des titres
- HEADING niveau 1 : nouveau chapitre, débute sur nouvelle page, 18pt gras,
  espace avant 0, espace après 18pt
- HEADING niveau 2 : 14pt gras, espace avant 18pt, espace après 10pt
- HEADING niveau 3 : 11pt gras italique, espace avant 12pt, espace après 6pt

### Éléments répétitifs — macros personnalisées à définir

  .CMD texte          ← commande inline dans le texte courant
                        rendu : fonte monospace, fond gris léger si possible,
                        sinon simplement monospace gras

  .BLOC_CODE          ← début d'un bloc de code multi-lignes
  ...contenu...
  .BLOC_CODE END      ← fin du bloc
                        rendu : retrait gauche de 8mm, police monospace 9pt,
                        pas de remplissage (.nf), espace avant/après de 6pt,
                        filet gauche vertical si faisable

  .NOTE               ← début d'une note ou aparté
  ...contenu...
  .NOTE END           ← fin
                        rendu : retrait gauche et droit de 12mm, italique,
                        espace avant/après de 8pt, filet gauche

  .TERM terme         ← introduit un terme technique pour la première fois
                        rendu : gras italique

  .TOUCHE touche      ← touche clavier (ex : .TOUCHE Ctrl-C)
                        rendu : encadré ou crochets + monospace

### Table des matières
- Générée automatiquement par -mom
- Placée au début du document (après la page de titre)
- Profondeur : niveaux 1 et 2 uniquement

### Page de titre
- Titre principal : "La ligne de commande et le terminal sous Linux"
- Sous-titre : "Un tour d'horizon des outils Unix"
- Auteur
- Date générée automatiquement

## Ce que je veux dans main.mom

Le fichier maître doit :
1. Inclure style.mom avec .MSOSTART ou la méthode appropriée
2. Déclarer la page de titre
3. Générer la table des matières
4. Inclure chaque chapitre avec .so chapitres/XX.mom
5. Appeler .TC en fin de document pour la TOC

## Ce que je veux dans chaque fichier de chapitre

Chaque fichier doit être autonome du point de vue du contenu mais hériter
du style défini dans style.mom. Il doit contenir :
- Un .HEADING 1 "Titre du chapitre"
- Quelques paragraphes d'exemple représentatifs du chapitre
- Au moins un .BLOC_CODE avec un exemple shell réaliste
- Au moins une utilisation de .CMD inline
- Au moins un .HEADING 2 et un .HEADING 3

Le contenu peut être un squelette — je l'écrirai moi-même — mais il doit
être suffisamment représentatif pour valider le rendu de chaque élément.

## Ce que je veux dans le Makefile

  PDF     = document.pdf
  SOURCE  = main.mom style.mom $(wildcard chapitres/*.mom)

  all: $(PDF)

  $(PDF): $(SOURCE)
  	groff -mom -Tpdf main.mom > $(PDF) 2>groff.log

  watch:
  	while inotifywait -e modify $(SOURCE); do make; done

  clean:
  	rm -f $(PDF) groff.log

  .PHONY: all watch clean

## Contraintes techniques

- Tester la compilation après chaque fichier créé. Si groff produit des
  avertissements dans groff.log, les corriger avant de continuer.
- Ne pas utiliser de fonctionnalités -mom non documentées ou expérimentales.
- Tous les chemins de fichiers doivent être relatifs.
- Le PDF final doit avoir les métadonnées correctes (titre, auteur) via les
  directives PDF de -mom.
- Si une fonctionnalité demandée (ex : fond gris pour .CMD) n'est pas
  faisable proprement en -mom sans hacks fragiles, proposer l'alternative
  la plus proche et la documenter dans un commentaire dans style.mom.

## Ordre de travail demandé

1. Créer le Makefile
2. Créer style.mom — compiler un fichier de test minimal pour valider
3. Créer main.mom — compiler, vérifier la page de titre et la TOC
4. Créer chapitres/00-avant-propos.mom — compiler, vérifier le rendu
5. Créer les chapitres 01 à 04 — compiler après chacun
6. Compilation finale — vérifier groff.log, corriger les avertissements

À chaque étape, montrer la commande de compilation utilisée et signaler
tout compromis fait par rapport aux spécifications ci-dessus.
```

---

## Quelques remarques sur ce prompt

**L'ordre de travail à la fin est important.** Claude Code a tendance à tout générer d'un coup. En imposant un ordre avec compilation à chaque étape, vous attrapez les problèmes tôt plutôt que de déboguer un PDF cassé de 50 pages.

**La clause de compromis** ("si ce n'est pas faisable, documenter l'alternative") est cruciale avec groff — certaines choses comme les fonds de couleur inline sont possibles mais fragiles selon le backend PDF. Mieux vaut le savoir dès le départ.

**Le contenu squelette des chapitres** est volontaire — vous ne voulez pas que Claude Code écrive votre livre sur bash à votre place. Il pose juste assez pour que le rendu soit validable.

Bonne écriture.

## User

Je préfère avec des chapitres découpés par sous-répertoire. Chaque chapitre peut avoir un sous-répertoire pour les assets (images, illustration) qui pourrait être inclus dans le livre. Peux-tu mettre à jour le prompt en ce sens ?

## Claude

```
# Projet : "La ligne de commande et le terminal sous Linux"
# Document technique écrit en GNU groff avec le package -mom

## Contexte et ambition

Je veux écrire un document technique sur la ligne de commande et le terminal
sous Linux. Le document est destiné à un lecteur technique débutant à
intermédiaire. Il sera écrit entièrement en GNU groff avec le package -mom,
et produit en PDF via :

  groff -mom -Tpdf main.mom > document.pdf

Le document lui-même est une démonstration de la philosophie Unix : des outils
qui font une chose, qui se composent, et qui durent. Groff en est l'exemple
final et la mise en abyme.

## Structure du document

Le document est organisé en quatre parties :

  Partie 1 — Bash
    - Introduction au shell, rôle de bash
    - Syntaxe : variables, expansions, redirections, pipes
    - Démarrage : .profile, .bashrc, PATH

  Partie 2 — Les outils en ligne de commande
    - Navigation et fichiers  (ls, find, tree, fd…)
    - Manipulation de texte   (grep, sed, awk, cut, sort, uniq…)
    - Réseau                  (curl, ss, ip, dig…)
    - Gestion de paquets      (apt / dnf / pacman)

  Partie 3 — Le terminal
    - Codes ANSI et séquences d'échappement
    - Terminfo / termcap
    - Les TUI : définition et fonctionnement
    - Vim comme étude de cas

  Partie 4 — Les outils historiques
    - Groff : typographie en ligne de commande
    - La philosophie Unix : pipe de préprocesseurs, séparation contenu/rendu
    - Groff comme archétype : pic, tbl, eqn, groff

## Structure des fichiers source

Crée l'arborescence suivante :

  document.pdf                    ← sortie compilée (ne pas versionner)
  Makefile                        ← cible par défaut : PDF, cible watch
  main.mom                        ← fichier maître
  style.mom                       ← définitions de style et macros

  chapitres/
    00-avant-propos/
      index.mom                   ← source du chapitre
      assets/                     ← images et illustrations du chapitre
    01-bash/
      index.mom
      assets/
    02-outils/
      index.mom
      assets/
    03-terminal/
      index.mom
      assets/
    04-groff/
      index.mom
      assets/

Chaque répertoire assets/ est créé même s'il est vide, avec un fichier
.gitkeep pour permettre le versionnement Git.

## Inclusion des chapitres

Groff ne résout pas les chemins relatifs au fichier source lors des
appels .so — il les résout depuis le répertoire de travail courant.
Le Makefile doit donc toujours invoquer groff depuis la racine du projet.
Les inclusions dans main.mom utilisent des chemins relatifs à cette racine :

  .so chapitres/00-avant-propos/index.mom
  .so chapitres/01-bash/index.mom
  ...

## Inclusion des assets

Chaque image doit être en format EPS ou PDF (seuls formats supportés
nativement par groff -mom pour l'inclusion dans un PDF de sortie).

Définir dans style.mom une macro d'inclusion d'image :

  .ILLUSTRATION chemin legende largeur

    chemin   : chemin relatif à la racine du projet
                ex : chapitres/01-bash/assets/pipeline.pdf
    legende  : texte de légende affiché sous l'image (peut être vide "")
    largeur  : largeur souhaitée exprimée en mm (ex : 120)

  Comportement attendu :
    - L'image est centrée
    - La légende est centrée sous l'image, en italique 9pt
    - Un espace de 8pt est ajouté avant et après le bloc
    - Si le chemin ne pointe vers aucun fichier, groff émet un
      avertissement via .tm mais ne plante pas

Dans chaque chapitre, inclure un appel .ILLUSTRATION commenté en exemple
(pointant vers un fichier assets/exemple.pdf fictif) pour montrer la
syntaxe à utiliser.

## Ce que je veux dans style.mom

### Mise en page générale
- Format A4, marges de 30mm (haut/bas) et 25mm (gauche/droite)
- Police principale : Libertinus ou Linux Libertine si disponible,
  sinon Times
- Taille de corps : 11pt, interligne 15pt
- En-tête : titre du chapitre courant (côté extérieur), numéro de page
  (côté intérieur)
- Pied de page : titre du document centré

### Hiérarchie des titres
- HEADING niveau 1 : nouveau chapitre, débute sur nouvelle page, 18pt
  gras, espace avant 0, espace après 18pt
- HEADING niveau 2 : 14pt gras, espace avant 18pt, espace après 10pt
- HEADING niveau 3 : 11pt gras italique, espace avant 12pt, espace
  après 6pt

### Éléments répétitifs — macros personnalisées à définir

  .CMD texte          ← commande inline dans le texte courant
                        rendu : fonte monospace, fond gris léger si
                        possible, sinon monospace gras

  .BLOC_CODE          ← début d'un bloc de code multi-lignes
  ...contenu...
  .BLOC_CODE END      ← fin du bloc
                        rendu : retrait gauche de 8mm, police monospace
                        9pt, pas de remplissage (.nf), espace avant/après
                        de 6pt, filet gauche vertical si faisable

  .NOTE               ← début d'une note ou aparté
  ...contenu...
  .NOTE END           ← fin
                        rendu : retrait gauche et droit de 12mm,
                        italique, espace avant/après 8pt, filet gauche

  .TERM terme         ← introduit un terme technique pour la première
                        fois — rendu : gras italique

  .TOUCHE touche      ← touche clavier (ex : .TOUCHE Ctrl-C)
                        rendu : crochets + monospace

  .ILLUSTRATION c l w ← voir section "Inclusion des assets" ci-dessus

### Table des matières
- Générée automatiquement par -mom
- Placée au début du document après la page de titre
- Profondeur : niveaux 1 et 2 uniquement

### Page de titre
- Titre : "La ligne de commande et le terminal sous Linux"
- Sous-titre : "Un tour d'horizon des outils Unix"
- Auteur
- Date générée automatiquement

## Ce que je veux dans main.mom

Le fichier maître doit :
1. Inclure style.mom
2. Déclarer la page de titre
3. Générer la table des matières
4. Inclure chaque chapitre avec .so chapitres/XX-nom/index.mom
5. Appeler .TC en fin de document

## Ce que je veux dans chaque index.mom de chapitre

Chaque fichier est autonome pour le contenu mais hérite du style de
style.mom. Il doit contenir :
- Un .HEADING 1 "Titre du chapitre"
- Quelques paragraphes d'exemple représentatifs du chapitre
- Au moins un .BLOC_CODE avec un exemple shell réaliste
- Au moins une utilisation de .CMD inline
- Au moins un .HEADING 2 et un .HEADING 3
- Un appel .ILLUSTRATION commenté montrant la syntaxe avec un asset
  fictif dans le sous-répertoire assets/ du chapitre

Le contenu est un squelette — je l'écrirai moi-même. Il doit être
suffisamment représentatif pour valider le rendu de chaque élément.

## Ce que je veux dans le Makefile

  PDF     = document.pdf
  SOURCE  = main.mom style.mom \
            $(wildcard chapitres/*/index.mom)
  ASSETS  = $(wildcard chapitres/*/assets/*)

  all: $(PDF)

  $(PDF): $(SOURCE) $(ASSETS)
  	groff -mom -Tpdf main.mom > $(PDF) 2>groff.log
  	@if [ -s groff.log ]; then \
  	  echo "=== Avertissements groff ===" ; cat groff.log ; fi

  watch:
  	while inotifywait -e modify $(SOURCE); do make; done

  clean:
  	rm -f $(PDF) groff.log

  .PHONY: all watch clean

## Contraintes techniques

- Compiler après chaque fichier créé. Si groff.log contient des
  avertissements, les corriger avant de continuer.
- Ne pas utiliser de fonctionnalités -mom non documentées ou
  expérimentales.
- Tous les chemins sont relatifs à la racine du projet.
- Le PDF final doit avoir les métadonnées correctes (titre, auteur)
  via les directives PDF de -mom.
- Si une fonctionnalité demandée n'est pas faisable proprement en -mom
  sans hacks fragiles, proposer l'alternative la plus proche et la
  documenter dans un commentaire dans style.mom.
- Les fichiers assets/ vides sont versionnables via un .gitkeep.
- Ajouter un .gitignore à la racine : ignorer document.pdf et
  groff.log, versionner tout le reste.

## Ordre de travail demandé

1. Créer .gitignore et le Makefile
2. Créer style.mom — compiler un fichier de test minimal pour valider
3. Créer main.mom — compiler, vérifier page de titre et TOC
4. Créer chapitres/00-avant-propos/index.mom et son assets/ — compiler
5. Créer les chapitres 01 à 04 dans l'ordre — compiler après chacun
6. Compilation finale — vérifier groff.log, corriger les avertissements,
   confirmer que les chemins d'assets sont correctement résolus

À chaque étape, afficher la commande de compilation utilisée et signaler
tout compromis fait par rapport aux spécifications ci-dessus.
```

---

## Ce qui a changé par rapport à la version précédente

**L'arborescence par sous-répertoire** avec `index.mom` comme convention de nommage — propre et extensible. Ajouter un chapitre revient à créer un répertoire, le Makefile le détecte automatiquement via `wildcard`.

**Le problème de résolution de chemin groff** est explicité dans le prompt. C'est un piège réel : groff résout `.so` depuis le répertoire courant, pas depuis l'emplacement du fichier source. Imposer que `make` soit toujours lancé depuis la racine évite des heures de débogage.

**La macro `.ILLUSTRATION`** est spécifiée avec son comportement de dégradation — si l'asset n'existe pas, on avertit sans planter, ce qui est essentiel pendant la phase d'écriture où les images arrivent après le texte.

**Les `assets/` et `.gitkeep`** sont explicitement demandés, ainsi que le `.gitignore` — des détails que Claude Code oublie souvent si on ne les spécifie pas.

## User

est-ce que claude code sera capable de convertir mes notes existantes en markdown vers groff + mom ? Quel serait l'effort requis ?

## Claude

Oui, Claude Code en sera capable — mais l'effort dépend beaucoup de ce qu'il y a dans vos notes Markdown.

## Ce qui se convertit facilement

La structure de base est une correspondance quasi-mécanique :

```
Markdown          →    groff -mom
─────────────────────────────────
# Titre           →    .HEADING 1 "Titre"
## Sous-titre     →    .HEADING 2 "Sous-titre"
**gras**          →    \*[BD]gras\*[PREV]
*italique*        →    \*[IT]italique\*[PREV]
`code inline`     →    .CMD code
```Bloc de code``` →    .BLOC_CODE / .BLOC_CODE END
- item de liste   →    .LIST / .ITEM / .LIST END
```

Claude Code peut écrire un script de conversion pour cette couche — en `sed`, `awk` ou Python — qui traite 80% des cas automatiquement.

## Ce qui demande un effort humain

**Les ambiguïtés sémantiques.** Markdown ne distingue pas un terme technique introduit pour la première fois d'un simple mot en italique. Votre `.TERM` n'a pas d'équivalent Markdown — il faudra annoter manuellement.

**Les blocs de code avec langage.** ` ```bash ` en Markdown n'a pas de rendu différencié en groff de base. Si vous voulez distinguer visuellement les blocs shell des blocs de configuration, c'est une décision editoriale qui ne peut pas être automatisée.

**Les tableaux Markdown.** Ils existent en groff via le préprocesseur `tbl`, mais la syntaxe est radicalement différente et l'intégration dans `-mom` demande soin. Claude Code peut le faire, mais chaque tableau devra être vérifié manuellement.

**Les images.** Vos Markdown référencent probablement des PNG ou JPG. Groff ne supporte nativement que EPS et PDF. Chaque image devra être convertie avec `convert` (ImageMagick) ou `img2pdf`. Claude Code peut automatiser ça, mais c'est une étape supplémentaire.

**Les liens.** Les liens hypertexte Markdown `[texte](url)` n'ont pas d'équivalent direct en `-mom`. On peut les rendre en PDF cliquables via les directives PDF de groff, mais c'est une transformation non triviale.

## L'estimation réaliste

Pour des notes typiques en Markdown, je découperais l'effort en trois couches :

**Couche automatisable par script (Claude Code, ~1h de mise au point)** — titres, paragraphes, gras/italique, blocs de code simples, listes. Produit un fichier groff compilable mais imparfait.

**Couche semi-automatique (relecture chapitre par chapitre)** — tableaux, images converties, liens, blocs de code avec contexte. Comptez 15 à 30 minutes par chapitre selon la densité.

**Couche editoriale (vous uniquement)** — `.TERM` sur les premiers usages, `.NOTE` sur les apartés, `.ILLUSTRATION` avec de vraies légendes, cohérence des niveaux de titre. C'est le travail qui donne de la valeur au document final — il ne peut pas être délégué.

## Ma suggestion

Ne convertissez pas vos notes telles quelles. Utilisez-les comme matériau source, et réécrivez chapitre par chapitre en groff directement, avec Claude Code à côté pour la syntaxe. Vous obtiendrez un document plus cohérent qu'une conversion automatique retouchée, et vous apprendrez vraiment `-mom` au passage — ce qui est cohérent avec l'esprit du projet.

La conversion automatique a tendance à produire du groff qui *compile* mais qui ne *profite pas* des capacités du format. C'est dommage pour un document dont l'un des chapitres parle de groff lui-même.

## User

Faut-il préciser dans le prompt que le document doit être rédigé en français ?

## Claude

Oui, absolument — et c'est plus subtil qu'il n'y paraît.

## Ce qu'il faut préciser explicitement

**La langue du contenu**, évidemment, mais aussi trois aspects techniques que groff doit connaître :

**La césure.** Groff utilise des dictionnaires de césure par langue. Sans instruction explicite, il applique les règles anglaises, et vous obtiendrez des coupures de mots incorrectes en français. Dans `style.mom` il faut ajouter :

```groff
.HYSET lang fr
```

ou au niveau primitif :

```groff
.hla fr
.hpf fr
```

Ce qui nécessite que le paquet `groff-extra` ou les dictionnaires hyphen soient installés (`hyphen-fr` sur Debian/Ubuntu).

**Les guillemets.** Le français utilise « » et non "". `-mom` a une directive pour ça :

```groff
.SMARTQUOTES FR
```

**L'encodage.** Vos notes en français contiendront des caractères accentués. Il faut s'assurer que groff traite les fichiers source en UTF-8 :

```groff
.\" en ligne de commande : groff -mom -Kutf8 -Tpdf main.mom
```

## Ce qu'il faut ajouter au prompt

Insérez une section dédiée juste après "Contraintes techniques" :

```
## Langue et typographie française

Le document est entièrement rédigé en français. Les points suivants
doivent être configurés dans style.mom et dans le Makefile :

CÉSURE
  Activer les règles de césure françaises via .hla fr et .hpf fr.
  Vérifier que le paquet hyphen-fr est disponible sur le système.
  Si absent, émettre un avertissement via .tm dans style.mom et
  continuer sans césure plutôt que de planter.

GUILLEMETS
  Activer .SMARTQUOTES FR pour obtenir les guillemets français
  « » automatiquement à partir des guillemets droits dans la source.

ENCODAGE
  Tous les fichiers source sont en UTF-8.
  La commande groff dans le Makefile doit inclure -Kutf8 :
    groff -mom -Kutf8 -Tpdf main.mom > document.pdf 2>groff.log

ESPACES INSÉCABLES
  En typographie française, une espace insécable précède : ; ! ?
  Définir dans style.mom une macro ou documenter l'escape à utiliser :
    \~ pour une espace insécable
  Exemple dans la source : mot\~; suite

LANGUE DES ÉLÉMENTS AUTOMATIQUES
  Les chaînes générées automatiquement par -mom (ex : "Table of
  Contents") doivent être redéfinies en français dans style.mom :
    .ds TOC_TITLE "Table des matières"
    .ds COVERTITLE_LABEL ""
  Vérifier dans la documentation -mom quelles chaînes sont
  redéfinissables et lister celles qui apparaissent dans le document.
```

## Un détail souvent oublié

Les éléments auto-générés par `-mom` — "Table of Contents", éventuellement "Chapter", les en-têtes de notes — sont en anglais par défaut. Claude Code devra inventorier lesquels apparaissent réellement dans votre document et les redéfinir. C'est facile à faire mais facile à oublier, d'où l'intérêt de le spécifier explicitement dans le prompt.

## User

Peux-tu me refaire un prompt complet avec toutes ces informations ?

## Claude

```
# Projet : "La ligne de commande et le terminal sous Linux"
# Document technique écrit en GNU groff avec le package -mom

## Contexte et ambition

Je veux écrire un document technique sur la ligne de commande et le terminal
sous Linux. Le document est destiné à un lecteur technique débutant à
intermédiaire. Il sera écrit entièrement en GNU groff avec le package -mom,
et produit en PDF via :

  groff -mom -Kutf8 -Tpdf main.mom > document.pdf

Le document lui-même est une démonstration de la philosophie Unix : des outils
qui font une chose, qui se composent, et qui durent. Groff en est l'exemple
final et la mise en abyme.

## Structure du document

Le document est organisé en quatre parties :

  Partie 1 — Bash
    - Introduction au shell, rôle de bash
    - Syntaxe : variables, expansions, redirections, pipes
    - Démarrage : .profile, .bashrc, PATH

  Partie 2 — Les outils en ligne de commande
    - Navigation et fichiers  (ls, find, tree, fd…)
    - Manipulation de texte   (grep, sed, awk, cut, sort, uniq…)
    - Réseau                  (curl, ss, ip, dig…)
    - Gestion de paquets      (apt / dnf / pacman)

  Partie 3 — Le terminal
    - Codes ANSI et séquences d'échappement
    - Terminfo / termcap
    - Les TUI : définition et fonctionnement
    - Vim comme étude de cas

  Partie 4 — Les outils historiques
    - Groff : typographie en ligne de commande
    - La philosophie Unix : pipe de préprocesseurs, séparation contenu/rendu
    - Groff comme archétype : pic, tbl, eqn, groff

## Structure des fichiers source

Crée l'arborescence suivante :

  document.pdf                    ← sortie compilée (ne pas versionner)
  Makefile                        ← cible par défaut : PDF, cible watch
  .gitignore                      ← ignorer document.pdf et groff.log
  main.mom                        ← fichier maître
  style.mom                       ← définitions de style et macros

  chapitres/
    00-avant-propos/
      index.mom                   ← source du chapitre
      assets/                     ← images et illustrations du chapitre
        .gitkeep
    01-bash/
      index.mom
      assets/
        .gitkeep
    02-outils/
      index.mom
      assets/
        .gitkeep
    03-terminal/
      index.mom
      assets/
        .gitkeep
    04-groff/
      index.mom
      assets/
        .gitkeep

## Inclusion des chapitres

Groff ne résout pas les chemins relatifs au fichier source lors des
appels .so — il les résout depuis le répertoire de travail courant.
Le Makefile doit donc toujours invoquer groff depuis la racine du projet.
Les inclusions dans main.mom utilisent des chemins relatifs à cette racine :

  .so chapitres/00-avant-propos/index.mom
  .so chapitres/01-bash/index.mom
  ...

## Inclusion des assets

Chaque image doit être en format EPS ou PDF (seuls formats supportés
nativement par groff -mom pour l'inclusion dans un PDF de sortie).

Définir dans style.mom une macro d'inclusion d'image :

  .ILLUSTRATION chemin legende largeur

    chemin   : chemin relatif à la racine du projet
                ex : chapitres/01-bash/assets/pipeline.pdf
    legende  : texte de légende affiché sous l'image (peut être vide "")
    largeur  : largeur souhaitée exprimée en mm (ex : 120)

  Comportement attendu :
    - L'image est centrée
    - La légende est centrée sous l'image, en italique 9pt
    - Un espace de 8pt est ajouté avant et après le bloc
    - Si le chemin ne pointe vers aucun fichier, groff émet un
      avertissement via .tm mais ne plante pas

Dans chaque chapitre, inclure un appel .ILLUSTRATION commenté en exemple
(pointant vers un fichier assets/exemple.pdf fictif) pour montrer la
syntaxe à utiliser.

## Ce que je veux dans style.mom

### Mise en page générale
- Format A4, marges de 30mm (haut/bas) et 25mm (gauche/droite)
- Police principale : Libertinus ou Linux Libertine si disponible,
  sinon Times
- Taille de corps : 11pt, interligne 15pt
- En-tête : titre du chapitre courant (côté extérieur), numéro de page
  (côté intérieur)
- Pied de page : titre du document centré

### Hiérarchie des titres
- HEADING niveau 1 : nouveau chapitre, débute sur nouvelle page, 18pt
  gras, espace avant 0, espace après 18pt
- HEADING niveau 2 : 14pt gras, espace avant 18pt, espace après 10pt
- HEADING niveau 3 : 11pt gras italique, espace avant 12pt, espace
  après 6pt

### Éléments répétitifs — macros personnalisées à définir

  .CMD texte          ← commande inline dans le texte courant
                        rendu : fonte monospace, fond gris léger si
                        possible, sinon monospace gras

  .BLOC_CODE          ← début d'un bloc de code multi-lignes
  ...contenu...
  .BLOC_CODE END      ← fin du bloc
                        rendu : retrait gauche de 8mm, police monospace
                        9pt, pas de remplissage (.nf), espace avant/après
                        de 6pt, filet gauche vertical si faisable

  .NOTE               ← début d'une note ou aparté
  ...contenu...
  .NOTE END           ← fin
                        rendu : retrait gauche et droit de 12mm,
                        italique, espace avant/après 8pt, filet gauche

  .TERM terme         ← introduit un terme technique pour la première
                        fois — rendu : gras italique

  .TOUCHE touche      ← touche clavier (ex : .TOUCHE Ctrl-C)
                        rendu : crochets + monospace

  .ILLUSTRATION c l w ← voir section "Inclusion des assets" ci-dessus

### Table des matières
- Générée automatiquement par -mom
- Placée au début du document après la page de titre
- Profondeur : niveaux 1 et 2 uniquement

### Page de titre
- Titre : "La ligne de commande et le terminal sous Linux"
- Sous-titre : "Un tour d'horizon des outils Unix"
- Auteur
- Date générée automatiquement

## Ce que je veux dans main.mom

Le fichier maître doit :
1. Inclure style.mom
2. Déclarer la page de titre
3. Générer la table des matières
4. Inclure chaque chapitre avec .so chapitres/XX-nom/index.mom
5. Appeler .TC en fin de document

## Ce que je veux dans chaque index.mom de chapitre

Chaque fichier est autonome pour le contenu mais hérite du style de
style.mom. Il doit contenir :
- Un .HEADING 1 "Titre du chapitre"
- Quelques paragraphes d'exemple représentatifs du chapitre
- Au moins un .BLOC_CODE avec un exemple shell réaliste
- Au moins une utilisation de .CMD inline
- Au moins un .HEADING 2 et un .HEADING 3
- Un appel .ILLUSTRATION commenté montrant la syntaxe avec un asset
  fictif dans le sous-répertoire assets/ du chapitre

Le contenu est un squelette — je l'écrirai moi-même. Il doit être
suffisamment représentatif pour valider le rendu de chaque élément.

## Ce que je veux dans le Makefile

  PDF     = document.pdf
  SOURCE  = main.mom style.mom \
            $(wildcard chapitres/*/index.mom)
  ASSETS  = $(wildcard chapitres/*/assets/*)

  all: $(PDF)

  $(PDF): $(SOURCE) $(ASSETS)
  	groff -mom -Kutf8 -Tpdf main.mom > $(PDF) 2>groff.log
  	@if [ -s groff.log ]; then \
  	  echo "=== Avertissements groff ===" ; cat groff.log ; fi

  watch:
  	while inotifywait -e modify $(SOURCE); do make; done

  clean:
  	rm -f $(PDF) groff.log

  .PHONY: all watch clean

## Langue et typographie française

Le document est entièrement rédigé en français. Les points suivants
doivent être configurés dans style.mom et dans le Makefile.

CÉSURE
  Activer les règles de césure françaises via .hla fr et .hpf fr.
  Vérifier que le paquet hyphen-fr est disponible sur le système avec :
    fc-list | grep -i libert
  Si absent, émettre un avertissement via .tm dans style.mom et
  continuer sans césure plutôt que de planter :
    .sy dpkg -l hyphen-fr 2>/dev/null | grep -q "^ii" \
      || tm style.mom: avertissement : hyphen-fr absent, césure désactivée

GUILLEMETS
  Activer .SMARTQUOTES FR pour obtenir les guillemets français
  « » automatiquement à partir des guillemets droits dans la source.

ENCODAGE
  Tous les fichiers source sont en UTF-8.
  La commande groff dans le Makefile inclut -Kutf8.

ESPACES INSÉCABLES
  En typographie française, une espace insécable précède : ; ! ? »
  et suit «. Documenter dans un commentaire en tête de style.mom
  l'escape à utiliser dans la source :
    \~ pour une espace insécable cadratin
    \  (backslash-espace) pour une espace insécable fine
  Exemple : mot\~; suite    →    mot ; suite

ÉLÉMENTS AUTO-GÉNÉRÉS
  Les chaînes générées automatiquement par -mom doivent être
  redéfinies en français dans style.mom. Inventorier et redéfinir
  au minimum :
    Table des matières  (par défaut "Table of Contents")
    En-tête de notes    (si applicable)
    Tout label généré automatiquement visible dans le PDF final
  Utiliser les mécanismes de redéfinition de chaînes de -mom
  (typiquement .STRINGREPLACE ou .ds selon la version).
  Documenter dans un commentaire chaque redéfinition effectuée
  et sa valeur originale anglaise.

## Contraintes techniques

- Compiler après chaque fichier créé. Si groff.log contient des
  avertissements, les corriger avant de continuer.
- Ne pas utiliser de fonctionnalités -mom non documentées ou
  expérimentales.
- Tous les chemins sont relatifs à la racine du projet.
- Le PDF final doit avoir les métadonnées correctes (titre, auteur,
  langue : fr) via les directives PDF de -mom.
- Si une fonctionnalité demandée n'est pas faisable proprement en -mom
  sans hacks fragiles, proposer l'alternative la plus proche et la
  documenter dans un commentaire dans style.mom.
- Les fichiers assets/ vides sont versionnables via un .gitkeep.
- Le .gitignore doit ignorer document.pdf et groff.log et versionner
  tout le reste.

## Ordre de travail demandé

1. Créer .gitignore et le Makefile
2. Créer style.mom — compiler un fichier de test minimal pour valider
   la mise en page, les polices, la césure française et les guillemets
3. Créer main.mom — compiler, vérifier la page de titre et la TOC
   en français
4. Créer chapitres/00-avant-propos/index.mom et son assets/ — compiler,
   vérifier que tous les éléments personnalisés (CMD, BLOC_CODE, NOTE,
   TERM, TOUCHE, ILLUSTRATION) s'affichent correctement
5. Créer les chapitres 01 à 04 dans l'ordre — compiler après chacun
6. Compilation finale — vérifier groff.log, corriger les avertissements,
   confirmer que les métadonnées PDF sont correctes, que la TOC est en
   français, et que les chemins d'assets sont correctement résolus

À chaque étape, afficher la commande de compilation utilisée et signaler
tout compromis fait par rapport aux spécifications ci-dessus.
```

---

## Ce qui a changé par rapport à la version précédente

La section **Langue et typographie française** est entièrement nouvelle et couvre les quatre dimensions du problème : césure, guillemets, encodage, espaces insécables, et éléments auto-générés. La vérification de `hyphen-fr` est intégrée au démarrage de `style.mom` pour détecter l'absence du dictionnaire avant même la première compilation. L'étape 4 de l'ordre de travail a été étoffée pour valider explicitement tous les éléments personnalisés sur l'avant-propos, qui sert ainsi de page de test complète avant d'attaquer le contenu réel.

## User

peux-tu me donner des exemples et toutes les options de la function \D’c...’ ?

## Claude

Voici la référence complète.

---

## L'escape `\D'...'` — référence complète

`\D` est l'escape de **dessin vectoriel** de Groff. Il envoie des commandes directement au backend de rendu (PostScript, PDF…). Le terminal n'en supporte presque aucune.

La position de départ est toujours la **position courante du crayon**. Après le dessin, le crayon est laissé au **point le plus à droite** de l'objet, sauf exception notée.

Les unités par défaut sont `m` (em) en horizontal et `v` (interligne) en vertical, sauf si vous suffixez explicitement (`2i`, `5p`, `3c`…).

---

### Les neuf commandes

#### `\D'l DX DY'` — segment de droite

Trace une ligne depuis la position courante jusqu'au point `(DX, DY)` relatif.

```groff
\D'l 3i 0'        \" ligne horizontale de 3 pouces
\D'l 0 2v'        \" ligne verticale vers le bas (2 interlignes)
\D'l 1i -1i'      \" diagonale : 1 pouce droite, 1 pouce haut
```

Exemple classique — encadrer du texte (du manuel groff) :

```groff
.de TEXTBOX
.  nr @wd \w'\$1'
\h'.2m'\
\h'-.2m'\v'(.2m - \n[rsb]u)'\
\D'l 0 -(\n[rst]u - \n[rsb]u + .4m)'\
\D'l (\n[@wd]u + .4m) 0'\
\D'l 0 (\n[rst]u - \n[rsb]u + .4m)'\
\D'l -(\n[@wd]u + .4m) 0'\
\h'.2m'\v'-(.2m - \n[rsb]u)'\
\$1\
\h'.2m'
..
```

---

#### `\D'c D'` — cercle (contour) / `\D'C D'` — cercle plein

`D` est le **diamètre**. Le point le plus à gauche du cercle est à la position courante.

```groff
\D'c 1i'          \" cercle vide, diamètre 1 pouce
\D'C 1i'          \" cercle plein (couleur de remplissage courante)
```

> Après le dessin, le crayon est au point le plus **à droite** du cercle (position courante + D).

---

#### `\D'e H V'` — ellipse (contour) / `\D'E H V'` — ellipse pleine

`H` est la largeur totale, `V` la hauteur totale. Le point le plus à gauche est à la position courante.

```groff
\D'e 2i 1i'       \" ellipse vide : 2 pouces de large, 1 de haut
\D'E 2i 1i'       \" ellipse pleine
\M[red]\D'E 2i 1i'\M[]   \" ellipse pleine rouge
```

---

#### `\D'a HC VC H V'` — arc de cercle

Trace un arc **dans le sens antihoraire** depuis la position courante.

- `(HC, VC)` : centre de l'arc, relatif à la position de départ
- `(H, V)` : point d'arrivée, relatif au centre

```groff
\D'a 1i 0 0 1i'   \" arc de 90° : centre à 1i droite, fin à 1i au-dessus du centre
```

> Groff ajuste le centre au point le plus proche du bisecteur perpendiculaire de la corde, pour garantir la continuité géométrique.

---

#### `\D'p H1 V1 ... HN VN'` — polygone (contour) / `\D'P ...'` — polygone plein

Trace un polygone en reliant la position courante à chaque point successif, puis referme automatiquement en revenant au point de départ.

```groff
\" Triangle équilatéral approximatif
\D'p 1i 0 -0.5i -0.87i'

\" Rectangle 3i × 1i
\D'p 3i 0 0 1i -3i 0'
```

Exemple du manuel — boîte avec fond de couleur :

```groff
.de TEXTBOX
.  nr @wd \w'\$1'
\h'.2m'\
\h'-.2m'\v'(.2m - \n[rsb]u)'\
\M[lightcyan]\
\D'P 0 -(\n[rst]u - \n[rsb]u + .4m) \
     (\n[@wd]u + .4m) 0 \
     0 (\n[rst]u - \n[rsb]u + .4m) \
     -(\n[@wd]u + .4m) 0'\
\h'.2m'\v'-(.2m - \n[rsb]u)'\
\M[]\
\$1\
\h'.2m'
..
```

> Pour un polygone à la fois **plein et encadré**, il faut le tracer deux fois : une fois avec `\D'P'` (fond) et une fois avec `\D'p'` (contour), car les deux propriétés sont indépendantes.

---

#### `\D'~ H1 V1 ... HN VN'` — B-spline

Trace une courbe B-spline passant par chaque point successif. Les coordonnées sont relatives au point précédent.

```groff
\D'~ 1i -0.5i 1i 0.5i 1i 0'   \" courbe en S sur 3 pouces
```

Moins utilisé en pratique que les autres formes — surtout pertinent pour des tracés générés par programme (préprocesseur `pic`).

---

#### `\D't N'` — épaisseur de trait

Règle l'épaisseur de **tous les tracés suivants** (jusqu'au prochain `.D't`).

```groff
\D't 0'       \" épaisseur minimale du périphérique
\D't 2p'      \" 2 points typographiques
\D't -1'      \" proportionnel à la taille de police (défaut)
```

> N'affecte pas le texte, seulement les commandes `\D`. S'utilise typiquement enveloppé dans `\Z` pour ne pas déplacer le crayon :

```groff
\Z'\D't 3p''
```

---

#### `\D'F ...'` — couleur de remplissage (GNU Groff uniquement)

Équivalent de `\M[couleur]`, mais en notation numérique directe. Cinq sous-commandes :

```groff
\D'Fr 32767 0 0'           \" RGB : rouge à mi-intensité
\D'Fg 40000'               \" gris (0 = noir, 65535 = blanc)
\D'Fc 0 65535 65535'       \" CMY : cyan pur
\D'Fk 0 0 0 32767'        \" CMYK : noir à 50%
\D'Fd'                     \" retour à la couleur de remplissage par défaut
```

En pratique, on préfère `\M[nom]` qui est plus lisible, mais `\D'F'` est utile dans du code généré automatiquement.

---

### Tableau récapitulatif

```
Commande          Objet                     Plein ?   Crayon après
──────────────────────────────────────────────────────────────────
\D'l DX DY'       segment de droite          —        point d'arrivée
\D'c D'           cercle                    non       + D (droite)
\D'C D'           cercle                    oui       + D (droite)
\D'e H V'         ellipse                   non       + H (droite)
\D'E H V'         ellipse                   oui       + H (droite)
\D'a HC VC H V'   arc antihoraire            —        point d'arrivée
\D'p H1V1…'       polygone                  non       dernier sommet
\D'P H1V1…'       polygone                  oui       dernier sommet
\D'~ H1V1…'       B-spline                   —        dernier point
\D't N'           épaisseur de trait         —        inchangé
\D'F? …'          couleur de remplissage     —        inchangé
```

---

### Couleur et remplissage : les deux axes indépendants

```groff
\M[couleur]   ← couleur de remplissage (filled objects)
\m[couleur]   ← couleur de trait et de texte (stroke)

\D'C 1i'      ← cercle plein : utilise \M
\D'c 1i'      ← cercle vide  : utilise \m pour le contour
```

Pour un cercle plein **et** encadré d'une couleur différente :

```groff
\M[yellow]\D'C 1i'\M[]    \" fond jaune
\m[black]\D'c 1i'\m[]     \" contour noir (retrace par-dessus)
```

---

### Interaction avec `\Z` et `\h`/`\v`

`\D` déplace le crayon. Pour dessiner sans affecter le flux de texte, on enveloppe dans `\Z` (qui restaure la position) :

```groff
\Z'\D'l 0 -1i''    \" trace une ligne vers le haut sans déplacer le crayon
```

Et pour positionner précisément avant de dessiner :

```groff
\h'2i'\v'0.5i'\D'c 0.5i'\h'-2.5i'\v'-0.5i'
\"         ↑ avance        ↑ descend   ↑ cercle   ↑ revient en arrière
```

En pratique, `\Z` est presque toujours préférable aux compensations manuelles.

## User

peut-on dessiner des courbes de bezier avec cette commande (ou avec Groff), et faire des dégradé de couleur (linéaire ou radial) ?

## Claude

Bonne question — les réponses sont nuancées. Vérifions ce que dit exactement la documentation.

J'ai tout ce qu'il faut pour une réponse précise et honnête.

---

## Courbes de Bézier

### Ce que Groff offre nativement : la B-spline, pas la Bézier

`\D'~'` trace une **B-spline**, pas une courbe de Bézier au sens strict. La distinction est importante :

- Une **courbe de Bézier cubique** est définie par 4 points de contrôle (départ, deux tangentes, arrivée) et passe exactement par le point de départ et d'arrivée.
- Une **B-spline** est définie par N points et passe *près* de chacun sans nécessairement les toucher — sauf le premier et le dernier.

En regardant ce que `grops` génère réellement pour `\D'~'`, on voit que le backend PostScript le traduit en `rcurveto` (courbe de Bézier cubique relative) — ce qui confirme que la B-spline est **approximée par des Bézier cubiques** sous le capot :

```
\D'~ 1i -1i 1i 1i 1i 0'
  →  PS : 36 -36 RL 24 -24 48 -24 72 0 RC 24 24 48 36 72 36 RC 36 0 RL
```

Groff décompose la B-spline en segments : une ligne droite au début, des `rcurveto` pour le corps, une ligne droite à la fin. C'est une approximation correcte mais vous ne contrôlez pas directement les points de contrôle des Bézier.

### Pour des Bézier cubiques exactes : passer par `pic`

Le préprocesseur `pic` offre `spline` qui génère exactement `\D'~'` :

```pic
.PS
spline from 0,0 to 1,1 to 2,0 to 3,1
.PE
```

Mais si vous voulez des **Bézier cubiques exactes** avec contrôle total sur les tangentes, il faut injecter du PostScript natif via `\X'ps: exec'` :

```groff
.\" Courbe de Bézier cubique : P0=(0,0) CP1=(1,2) CP2=(2,2) P3=(3,0)
\X'ps: exec gsave
  newpath
  0 0 moveto
  72 144 rlineto
  144 144 rlineto
  216 0 rlineto
  stroke
grestore'
```

C'est la seule façon d'accéder à l'opérateur PostScript `curveto` directement.

---

## Dégradés de couleur

### Réponse courte : non, pas nativement en Groff

Groff ne connaît que des couleurs uniformes. `\M[couleur]` et `\D'F...'` posent une couleur plate, c'est tout. Il n'existe aucune primitive `\D` pour les dégradés — ni linéaires, ni radiaux.

### Mais c'est faisable par deux chemins détournés

#### Chemin 1 — Injection PostScript native (`-Tps` uniquement)

PostScript niveau 3 supporte les shadings nativement. On peut les injecter via `\X'ps: exec'` :

```groff
.\" Dégradé linéaire rouge → bleu sur un rectangle 3i × 1i
\X'ps: exec
gsave
/Shading <<
  /ShadingType 2
  /ColorSpace /DeviceRGB
  /Coords [0 0 216 0]
  /Function <<
    /FunctionType 2
    /Domain [0 1]
    /C0 [1 0 0]
    /C1 [0 0 1]
    /N 1
  >>
>> shading
grestore'
```

Limitations importantes :
- Ne fonctionne qu'avec `-Tps` (sortie PostScript), pas `-Tpdf`
- `\X'ps: exec'` est transmis littéralement mais positionné dans le flux PS là où groff se trouve — la coordination avec la mise en page groff demande soin
- Les coordonnées sont en unités PostScript (points, 1/72 pouce), pas en unités groff

#### Chemin 2 — Image externe (universel)

Créer le dégradé dans un outil externe (Inkscape, ImageMagick, un script Python/Cairo), l'exporter en PDF ou EPS, et l'inclure avec la macro `.ILLUSTRATION` de votre projet. C'est la solution **la plus propre et la plus maintenable** :

```sh
# Générer un dégradé en PDF avec Cairo (Python)
python3 -c "
import cairo
s = cairo.PDFSurface('assets/degrade.pdf', 216, 72)
c = cairo.Context(s)
g = cairo.LinearGradient(0, 0, 216, 0)
g.add_color_stop_rgb(0, 1, 0, 0)   # rouge
g.add_color_stop_rgb(1, 0, 0, 1)   # bleu
c.rectangle(0, 0, 216, 72)
c.set_source(g)
c.fill()
s.finish()
"
```

```groff
.ILLUSTRATION chapitres/01-bash/assets/degrade.pdf "" 80
```

---

## Tableau de synthèse

```
Capacité                        Natif groff    Via pic    Via \X'ps:'    Image externe
────────────────────────────────────────────────────────────────────────────────────
B-spline approximée             ✓ \D'~'        ✓          —              —
Bézier cubique exacte           ✗              ✗          ✓ (-Tps)       ✓
Dégradé linéaire                ✗              ✗          ✓ (-Tps seul)  ✓
Dégradé radial                  ✗              ✗          ✓ (-Tps seul)  ✓
Compatible -Tpdf                ✓              ✓          ✗              ✓
```

---

### Conclusion pratique pour votre projet

Pour un document `-mom -Tpdf`, la voie réaliste est l'**image externe** : générez vos illustrations complexes (dégradés, Bézier précises) dans Inkscape ou avec un script Cairo/Matplotlib, exportez en PDF, et incluez-les via `.ILLUSTRATION`. C'est cohérent avec la philosophie Unix que vous documentez — chaque outil fait ce qu'il fait bien, et la composition fait le reste.

## User

comment consulter la documentation groff sous linux ?

## Claude

Groff a une documentation fragmentée entre plusieurs systèmes — voici comment naviguer dans chacun.

---

## Les pages `man`

La référence rapide pour chaque composant :

```sh
man groff        # vue d'ensemble, options de ligne de commande
man groff_ms     # package -ms
man groff_mom    # package -mom (très complet)
man groff_man    # package -man (pages de manuel)
man groff_char   # liste de tous les caractères spéciaux \[...]
man groff_font   # format des fichiers de fonte
man troff        # le moteur de bas niveau
man pic          # préprocesseur de diagrammes
man tbl          # préprocesseur de tableaux
man eqn          # préprocesseur d'équations
man grops        # backend PostScript
man gropdf       # backend PDF
```

---

## Le manuel de référence complet : `info groff`

C'est la source autoritaire — beaucoup plus détaillée que les pages man. Elle est découpée en volumes :

```sh
info groff                      # point d'entrée, table des matières
info groff "Drawing Geometric Objects"   # section spécifique
info groff "Environments"
info groff "Diversions"
info groff "Page Location Traps"
```

Navigation dans le lecteur `info` :

```
Tab        aller au prochain lien
Enter      suivre le lien
l          revenir en arrière (last)
n / p      section suivante / précédente
u          monter d'un niveau
s          rechercher dans le nœud courant
S          rechercher dans tout le manuel
q          quitter
```

Si vous préférez éviter l'interface `info`, convertissez en texte :

```sh
info groff --subnodes -o groff.txt   # tout le manuel en un fichier texte
less groff.txt
```

Ou consultez directement les fichiers compressés comme on l'a fait ensemble :

```sh
zcat /usr/share/info/groff.info-2.gz | sed 's/\x1b\[[0-9;]*m//g' | less
```

---

## La documentation HTML de `-mom`

C'est la mieux écrite de tout l'écosystème groff — l'auteur Peter Schaffter l'a rédigée comme un tutoriel, pas comme une référence sèche.

```sh
# Chercher où elle est installée
find /usr/share/doc -name "mom-pdf.pdf" -o -name "*.html" 2>/dev/null | grep -i mom

# Typiquement dans :
ls /usr/share/doc/groff-base/
xdg-open /usr/share/doc/groff-base/mom-pdf.pdf   # si disponible
```

Si elle n'est pas installée localement, elle est en ligne :
```
https://www.schaffter.ca/mom/mom-pdf.pdf
https://www.schaffter.ca/mom/momdoc/toc.html
```

---

## Les exemples installés avec groff

```sh
find /usr/share/groff -name "*.mom" -o -name "*.ms" -o -name "*.man" 2>/dev/null
ls /usr/share/groff/1.23.0/examples/
```

Ce sont des documents compilables — une excellente façon d'apprendre par l'exemple :

```sh
groff -mom -Tpdf /usr/share/groff/1.23.0/examples/mom/mom-example.mom > exemple.pdf
```

---

## Les fichiers source des packages

Comme on l'a fait tout au long de cette session — lire directement le source est parfois la documentation la plus précise :

```sh
# Trouver les fichiers tmac
find /usr/share/groff -name "*.tmac" | sort

# Lire le source de -mom
less /usr/share/groff/1.23.0/tmac/mom.tmac

# Lire le source de -ms
less /usr/share/groff/1.23.0/tmac/s.tmac

# Lire le prologue PostScript de grops
less /usr/share/groff/1.23.0/font/devps/prologue
```

---

## Récapitulatif selon le besoin

```
Besoin                              Commande
──────────────────────────────────────────────────────────
Syntaxe d'une option de commande    man groff
Référence d'une macro -mom          man groff_mom
Caractère spécial \[...]            man groff_char
Référence complète du langage       info groff
Apprendre -mom avec des exemples    doc HTML de Peter Schaffter
Comprendre un comportement obscur   source dans /usr/share/groff/
```

## User

Peux-tu me faire un template Groff pour écrire des CVs, qui reproduise l'apparence suivante.

## Claude

## User

continue sur le CV

## Claude

---

## Bilan du débogage

Le problème est identifié : **l'environnement de génération de fichiers** (heredocs bash dans ce contexte de conteneur) double silencieusement les backslashes en écrivant les fichiers groff, ce qui transforme `\$1` (interpolation d'argument) en `\\$1` (backslash littéral suivi de `$1`). Groff ne voit donc jamais les arguments des macros.

Ce problème **n'existe pas** quand vous écrivez le fichier dans votre éditeur directement. Voici le template final complet à copier-coller dans votre éditeur :

---

## User

Peux-tu me rappeler en quoi Tex/Latex est considéré comme supérieur ? TeX est le résultat d'un mathématicien, alors que roff est celui d'un ingénieur. La logique interne est différente, bien qu'ils résolvent les mêmes problèmes de base.

## Claude

C'est une belle question de philosophie des outils. La distinction mathématicien/ingénieur est une vraie clé de lecture.

---

## Ce que TeX fait mieux

### La composition typographique fine

Knuth a conçu TeX autour d'un problème précis : comment placer du texte sur une page de façon *optimalement belle*. Son algorithme de coupure de paragraphe est fondamentalement différent de celui de groff.

Groff traite les lignes **une par une** : il remplit la ligne courante, coupe, passe à la suivante. C'est l'approche greedy, celle d'un ingénieur qui résout le problème local à chaque étape.

TeX traite le **paragraphe entier comme une unité** : il considère simultanément toutes les coupures possibles et minimise une fonction de coût globale (les "badness points"). Le résultat est que TeX peut accepter une ligne légèrement trop serrée pour éviter une ligne catastrophique trois lignes plus loin. Groff ne peut pas faire ça.

En pratique, les documents TeX ont des paragraphes visuellement plus réguliers, avec moins de rivières blanches et moins d'espacement inter-mots erratique.

### Les mathématiques

C'est la raison d'être originale de TeX et son domaine d'excellence incontestée. Knuth a formalisé les règles de composition mathématique (espacement des opérateurs, taille des indices, placement des limites des intégrales, etc.) en plusieurs centaines de règles précises. Aucun autre système n'atteint ce niveau de qualité pour les maths denses.

eqn de groff est fonctionnel mais produit des résultats nettement inférieurs pour des équations complexes.

### Les fontes — METAFONT et la précision mathématique

Knuth n'a pas seulement fait TeX, il a fait **METAFONT** : un langage de description de fontes par équations mathématiques. Chaque glyphe de Computer Modern est défini par des paramètres continus — épaisseur du trait, courbure des empattements, hauteur des capitales — qui permettent de générer la fonte optimale pour chaque taille d'impression. C'est une cohérence entre outil et fonte qu'aucun autre système n'a.

### L'écosystème LaTeX

LaTeX (Lamport, 1984) a ajouté la couche de macros de haut niveau qui manquait à TeX brut. L'écosystème CTAN compte aujourd'hui plus de 6000 packages. Pour virtuellement n'importe quel besoin de mise en page — tableaux complexes, chimie, musique, échecs, circuits électroniques, dessins géométriques précis avec TikZ — il existe un package maintenu.

---

## Ce que groff fait mieux (ou différemment)

### La philosophie pipeline

Groff n'est pas un programme : c'est un **protocole**. Le pipe `pic | tbl | eqn | groff` est une composition d'outils indépendants. Chaque préprocesseur transforme une notation de domaine en primitives groff. C'est extensible par nature : vous pouvez insérer votre propre préprocesseur dans le pipeline sans toucher au reste.

TeX absorbe tout : TikZ, listings, biblatex sont *dans* TeX, écrits en TeX. C'est puissant mais monolithique. La frontière entre contenu et moteur est floue.

### La légèreté et l'ubiquité

Groff est installé par défaut sur tous les systèmes Unix/Linux. Il n'a aucune dépendance. Une installation LaTeX complète (TeX Live full) pèse environ 7 Go. Groff pèse quelques mégaoctets. Pour un système embarqué, un pipeline CI, ou générer des pages de man, groff est imbattable.

### La prévisibilité

Groff est **impératif et local** : chaque commande produit un effet immédiat et prévisible. TeX est **déclaratif et global** : les décisions de mise en page peuvent être reportées, révisées, influencées par du contenu qui n'a pas encore été lu. C'est ce qui donne à TeX sa supériorité typographique, mais aussi ce qui rend le débogage d'un document LaTeX complexe si mystérieux. Les messages d'erreur de TeX sont notoires.

---

## La vraie différence de logique interne

Votre intuition mathématicien/ingénieur est juste mais mérite d'être précisée.

Knuth posait la question : **"Quelle est la solution optimale ?"** Il a formalisé la typographie comme un problème d'optimisation — minimiser les pénalités sur un graphe de décisions. TeX est un solveur.

Les ingénieurs Bell Labs posaient la question : **"Comment transformer ce flux de texte en sortie imprimable ?"** roff est un transducteur — il lit, il transforme, il émet. Pas de retour en arrière, pas d'optimisation globale.

Cette différence se voit aussi dans le traitement des erreurs : TeX essaie de *récupérer* d'une erreur et de continuer à composer (parfois avec des résultats étranges), ce qui est la démarche du mathématicien qui veut voir si la preuve tient malgré tout. groff s'arrête ou émet un avertissement et continue localement, ce qui est la démarche de l'ingénieur qui isole le composant défaillant.

Elle se voit enfin dans l'extensibilité : TeX est **Turing-complet en lui-même** — ses macros forment un langage de programmation (certes horrible). groff externalise la programmation dans les préprocesseurs et le shell. L'un absorbe la complexité, l'autre la distribue.

---

## Pourquoi "supérieur" est le mauvais mot

Pour un livre de mathématiques ou un article scientifique soumis à une revue, TeX/LaTeX est objectivement le meilleur outil disponible. La qualité typographique des maths et l'optimisation globale des paragraphes font une différence visible.

Pour des pages de man, de la documentation système générée automatiquement, ou un document produit dans un pipeline Unix sans dépendances, groff est objectivement supérieur.

La vraie leçon est que **la supériorité d'un outil est inséparable du problème qu'il a été conçu pour résoudre**. Knuth voulait composer les volumes de *The Art of Computer Programming* avec des mathématiques denses. Thompson et Ritchie voulaient imprimer des manuels Unix sur un PDP-11 avec un photocompositeur CAT. Ces deux problèmes ont produit deux philosophies cohérentes et légitimes.

## User

Et par rapport à typst ou quarkdown ?

## Claude

Bonne question — ce sont deux représentants d'une troisième génération d'outils qui tirent les leçons des deux précédentes.

Voilà une vue d'ensemble claire. Ce sont deux projets très différents malgré leur proximité d'âge.

---

## Typst — le concurrent sérieux de LaTeX

Typst a été conçu autour de trois objectifs : puissance comparable à LaTeX, facilité d'apprentissage, et performance suffisante pour une prévisualisation instantanée.

### La philosophie sous-jacente

Si on reprend la grille mathématicien/ingénieur, Typst est l'œuvre d'un **informaticien théoricien formé à la PL** (programming language theory). L'un des développeurs core a d'ailleurs exprimé le désir d'écrire un article sur Typst depuis une perspective PL, en contraste avec les articles centrés sur la typographie. Le langage Typst est un vrai langage de programmation fonctionnel avec un système de types, pas un macro-processeur comme TeX ou groff.

La distinction conceptuelle clé : Typst introduit les **set rules** et **show rules**.

```typst
// set rule : configure une propriété globalement
#set heading(numbering: "1.1")
#set text(font: "Linux Libertine", size: 11pt)

// show rule : redéfinit complètement le rendu d'un élément
#show heading.where(level: 1): it => {
  pagebreak()
  block(text(weight: "bold", size: 18pt, it.body))
}
```

C'est fondamentalement différent de TeX : au lieu de redéfinir des macros bas niveau, on déclare des transformations sur des éléments sémantiques typés. Le document est un AST, pas un flux de caractères.

### Ce que Typst fait mieux que LaTeX

**La compilation incrémentale.** Typst compile votre document en millisecondes pendant que vous tapez — toutes les fonctionnalités du langage doivent accommoder la compilation incrémentale, rendue possible par comemo, un système de mémoïsation en arrière-plan. LaTeX recompile tout depuis le début à chaque fois.

**Les messages d'erreur.** Typst produit des erreurs précises avec position dans le source. Les erreurs LaTeX sont célèbres pour leur crypticité.

**La cohérence du langage.** LaTeX est enterré sous des couches et des couches de macro-sets accumulés depuis des décennies — ce qui donne des comportements mystérieux comme `\makeatletter` ou des warnings abscons sur les destinations dupliquées. Typst est conçu d'un seul tenant.

### Les limites actuelles de Typst

Pour les mathématiciens purs qui écrivent principalement du texte, on peut basculer maintenant. Pour ceux qui ont besoin de graphiques avancés, on ne peut pas encore switcher.

Beaucoup de documents sont écrits avec des co-auteurs, les journaux scientifiques attendent des soumissions LaTeX, et arXiv aussi. Il n'existe pas encore de bon compilateur Typst → LaTeX.

L'algorithme de composition de paragraphe est aussi encore inférieur à celui de TeX sur les textes denses — Typst 0.12 a fait des progrès mais n'a pas encore l'optimisation globale knuthienne.

---

## Quarkdown — une philosophie différente

Quarkdown est plus précisément un système de traitement de documents Kotlin/JVM — c'est un langage de typographie avec une syntaxe à l'apparence Markdown, dans la même famille que LaTeX, Typst ou AsciiDoc, plutôt que le Markdown façon GitHub ou Obsidian que ses utilisateurs potentiels utilisent.

### L'idée centrale : source unique, sorties multiples

Un seul fichier source `.qd` peut compiler vers : HTML continu (notes, sites), HTML paginé (livres, articles via paged.js), slides (présentations via reveal.js), documentation (wikis), et PDF. Le format de sortie est déclaré dans la source elle-même avec `.doctype {paged}`.

C'est la proposition de valeur que ni TeX ni groff n'ont jamais vraiment résolue — groff peut produire du PostScript et du texte, mais pas des slides interactives ou un site web depuis le même source.

### Le système de fonctions

```quarkdown
.function {encadré}
    titre contenu:
    .box
        **Titre : .titre**
        .contenu

.encadré {Attention} contenu:{
    Ce texte sera dans un encadré.
}
```

Quarkdown est Turing-complet — il offre des fonctions définissables par l'utilisateur, des variables, des boucles, des conditionnelles, le tout dans la syntaxe Markdown.

### Les limites de Quarkdown

Le rendu PDF passe par Puppeteer qui pilote un navigateur headless — c'est HTML → Chrome → PDF, pas un moteur typographique natif. La qualité typographique fine (césure, optimisation des paragraphes, composition mathématique) est donc limitée par ce que CSS et paged.js peuvent faire.

Pour un pipeline Markdown existant, Quarkdown n'est pas une adoption incrémentale — c'est un switch. Ce qui lui donne le même problème qu'AsciiDoc : un format probablement supérieur, mais dont les utilisateurs potentiels utilisent un format différent et devraient switcher pour voir les bénéfices.

---

## La carte du territoire en 2026

```
                    Qualité typo fine
                           ▲
                    TeX/LaTeX
                           │
                    Typst  │
                           │
    Pipeline  ─────────────┼───────────── Sorties multiples
    Unix                   │
                    groff  │      Quarkdown
                           │
                    Markdown/Pandoc
                           ▼
                    Facilité d'entrée
```

### Ce que chaque génération résout

**Groff (1970s)** : transformer du texte en sortie imprimée dans un pipeline Unix. Le problème est le flux de données.

**TeX/LaTeX (1978/1984)** : composer des documents scientifiques avec des mathématiques, de façon optimalement belle. Le problème est l'optimisation typographique.

**Typst (2019)** : reprendre les objectifs de LaTeX avec un vrai langage de programmation moderne et une compilation incrémentale. Le problème est l'expérience développeur.

**Quarkdown (2024)** : partir de Markdown — ce que tout le monde écrit déjà — et lui ajouter la puissance d'un vrai système de typographie tout en ciblant plusieurs formats de sortie depuis une source unique. Le problème est la fragmentation des formats.

---

## Ce que ça change pour votre projet

Pour un document technique comme le vôtre — une source unique, PDF en sortie, contenu dense en blocs de code — **Typst serait aujourd'hui l'alternative la plus sérieuse à groff**. La syntaxe est plus lisible, la prévisualisation instantanée est un vrai gain de productivité, et l'intégration avec Claude Code serait plus fluide car le langage est plus régulier.

Quarkdown serait pertinent si vous vouliez publier le même contenu à la fois en PDF et en site web interactif depuis une source unique — ce que ni groff ni Typst ne font aussi naturellement.

Cela dit, votre choix de groff reste cohérent avec l'esprit du projet : vous documentez les outils Unix historiques *en les utilisant*. Typst est un outil remarquable, mais il ne raconte pas la même histoire.


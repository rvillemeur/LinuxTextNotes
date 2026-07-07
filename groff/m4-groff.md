# m4 et groff : le préprocesseur oublié

## Qu'est-ce que m4 ?

m4 est un préprocesseur de macros généraliste, développé par Brian Kernighan et Dennis Ritchie dans les années 1970. Il opère sur du texte brut avant que le programme cible ne le reçoive — dans ce cas, groff.

Le principe : m4 lit un fichier, substitue les macros qu'il reconnaît, puis produit du texte que groff compilera. m4 ne sait pas qu'il parle à groff. groff ne sait pas que m4 l'a précédé. C'est le pipeline Unix classique.

```
source.ms.m4  →  m4  →  source.ms  →  groff  →  document.pdf
```

---

## Pourquoi utiliser m4 avec groff ?

groff a ses propres macros (`.de`, `.ds`, etc.), mais elles sont évaluées à la composition — au moment où groff lit le fichier. m4 intervient **avant**, au niveau du texte source.

Cela permet des choses que groff seul ne peut pas faire proprement :

| Besoin | groff seul | m4 + groff |
|---|---|---|
| Constante globale (numéro de version) | `.ds VERSION 1.0` puis `\*[VERSION]` | `define(VERSION, 1.0)` |
| Inclusion conditionnelle de sections | `.if` limité | `ifdef` puissant |
| Génération de contenu répétitif | impossible nativement | boucles m4 |
| Inclusion de fichiers avec substitution | `.so` (brut) | `include()` avec expansion |
| Multi-format depuis une source unique | non | `ifdef(PDF, ...)`, `ifdef(HTML, ...)` |

---

## Syntaxe de base de m4

### Définir une macro

```m4
define(AUTEUR, Jean Dupont)
define(VERSION, 2.1)
define(ANNEE, 2024)
```

Dans le document, `AUTEUR` sera remplacé par `Jean Dupont` partout où il apparaît.

### Supprimer les retours à la ligne parasites : `dnl`

m4 conserve les fins de ligne de ses propres directives, ce qui crée des lignes vides dans la sortie. `dnl` (delete to next line) supprime tout jusqu'au retour à la ligne inclus.

```m4
define(TITRE, Manuel d'utilisation)dnl
define(VERSION, 3.0)dnl
```

Sans `dnl`, chaque `define` injecte une ligne vide dans la sortie groff, ce qui peut décaler la mise en page.

### Les guillemets m4

m4 utilise le backtick `` ` `` pour ouvrir et `'` pour fermer ses guillemets. Tout ce qui est entre ces marqueurs est protégé de l'expansion.

```m4
define(SALUT, `Bonjour, $1 !`)
SALUT(monde)           → Bonjour, monde !
SALUT(`Jean Paul`)     → Bonjour, Jean Paul !
```

**Problème avec groff** : le guillemet fermant `'` est aussi le caractère utilisé par groff en début de ligne (requête no-break). Les apostrophes dans le texte français créent des conflits.

La solution : `changequote`.

```m4
changequote([, ])

define(TITRE, [La ligne de commande sous Linux])
define(NOTE, [
.NOTE
$1
.NOTE END
])
```

`[` et `]` sont plus sûrs dans un contexte groff/texte français.

---

## Pipeline complet

```bash
m4 source.ms.m4 | groff -ms -Tpdf > document.pdf

# Avec preconv pour l'UTF-8
m4 source.ms.m4 | preconv -e utf8 | groff -ms -Tpdf > document.pdf

# Avec soelim si le fichier m4 utilise des .so
m4 source.ms.m4 | soelim | preconv -e utf8 | groff -ms -Tpdf > document.pdf
```

Convention de nommage courante : `.ms.m4` pour indiquer que le fichier est du `-ms` destiné à passer par m4.

---

## Exemples pratiques

### Constantes de document

```m4
changequote([, ])dnl
define(TITRE,    [La ligne de commande sous Linux])dnl
define(AUTEUR,   [Renaud de Villemeur])dnl
define(VERSION,  [1.0])dnl
define(DATE,     [Juillet 2024])dnl

.TL
TITRE
.AU
AUTEUR
.AI
Version VERSION — DATE
```

Modifier `VERSION` ou `DATE` en un seul endroit met à jour tout le document.

### Inclusion conditionnelle

```m4
changequote([, ])dnl

ifdef([BROUILLON], [dnl
.B
[[ BROUILLON — Ne pas distribuer ]]
.R
])dnl

.NH 1
Introduction
```

Compilation en mode brouillon :

```bash
m4 -DBROUILLON source.ms.m4 | groff -ms -Tpdf > brouillon.pdf
```

Compilation finale (sans le flag) :

```bash
m4 source.ms.m4 | groff -ms -Tpdf > final.pdf
```

### Macro pour un bloc répétitif

```m4
changequote([, ])dnl

dnl Macro : AVERTISSEMENT(texte)
define(AVERTISSEMENT, [dnl
.sp 0.5
.B
Avertissement :
.R
$1
.sp 0.5
])dnl

AVERTISSEMENT([Cette commande supprime les fichiers sans confirmation.])
AVERTISSEMENT([Droits root requis.])
```

### Multi-format depuis une source unique

```m4
changequote([, ])dnl

ifdef([FORMAT_WEB], [dnl
define(LIEN, [.URL $2 "$1"])dnl
], [dnl
define(LIEN, [$1 ($2)])dnl
])dnl

Consulter LIEN([la documentation], [https://www.gnu.org/software/groff/])
```

Pour le PDF, `LIEN` génère `la documentation (https://...)`. Pour une sortie HTML (avec `-Thtml`), il génère une vraie balise `.URL`.

### Boucle (cas avancé)

m4 n'a pas de boucle native, mais on peut simuler une récursion :

```m4
changequote([, ])dnl

dnl REPETE(n, texte) — répète texte n fois
define(REPETE, [ifelse($1, 0, [], [$2
REPETE(decr($1), $2)])])dnl

REPETE(3, [.li \(em])
```

Produit trois fois la ligne `.li \(em`. Utile pour des séparateurs, des structures tabulaires générées, etc.

---

## Les pièges

### L'ordre des expansions

m4 expand ses macros en première passe. Si une macro produit du texte qui ressemble à une autre macro m4, elle sera aussi expansée. Il faut parfois protéger avec des guillemets :

```m4
define(A, [bonjour])
define(B, [A monde])     # B → "A monde", puis "A" est expansé → "bonjour monde"
define(C, [[A] monde])   # C → "A monde" littéral, A n'est pas expansé
```

### Les arguments `$1`, `$2`… dans le corps du document

Si le texte groff contient `$1` (dans un exemple de script shell, par exemple), m4 l'interprète comme son premier argument. Solution : protéger avec les guillemets changés.

```m4
changequote([, ])

[
.BLOC_CODE
mafonction() {
    echo $1    # $1 ici est littéral pour m4 car entre [ ]
}
.BLOC_CODE END
]
```

### m4 et les `.so` de groff

groff's `.so` inclut des fichiers au moment de la composition. m4's `include()` inclut avant que groff ne voie quoi que ce soit. Les deux ne sont pas interchangeables : `include()` de m4 permet l'expansion des macros dans le fichier inclus, `.so` de groff non.

---

## m4 vs les alternatives modernes

| Approche | Avantages | Inconvénients |
|---|---|---|
| m4 + groff | universel, aucune dépendance supplémentaire | syntaxe archaïque, pièges de guillemets |
| Variables groff (`.ds`) | intégré, simple | évaluation tardive, pas de conditions puissantes |
| Script shell générant du groff | flexible, lisible | mélange deux niveaux d'abstraction |
| Pandoc | source Markdown, multi-format | perd le contrôle typographique fin de groff |

m4 reste pertinent pour les projets qui veulent rester dans l'écosystème groff pur, notamment pour des documents techniques avec des variantes (éditions, langues, formats) issues d'une source unique.

---

## Références

- `man m4` — manuel complet de GNU m4
- *The m4 Macro Processor* — Kernighan & Ritchie, 1977 (le document original)
- GNU m4 manual : https://www.gnu.org/software/m4/manual/
- *Groff: The GNU Implementation of troff* — Chapitre sur les préprocesseurs

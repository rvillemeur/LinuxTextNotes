# Variables Bash

## Tout est une chaîne

Par défaut, une variable Bash n'a pas de type — elle stocke toujours une chaîne de caractère:

```bash
x=42
echo $((x + 1))   # 43, Bash interprète la chaîne comme entier ici
echo ${#x}        # 2, longueur de la chaîne "42"
```

`declare -i x` force un entier, mais c'est rare en pratique.

## IFS n'est pas un séparateur de valeurs stockées

IFS ne change pas ce qu'une variable *contient* — il contrôle comment Bash *découpe* la valeur lors de son expansion sans guillemets.

```bash
var="a:b:c"
IFS=":"

for item in $var; do   # word splitting → "a", "b", "c"
    echo $item
done

for item in "$var"; do  # guillemets → un seul token "a:b:c"
    echo $item
done
```

La distinction `$var` vs `"$var"` est fondamentale — c'est la source de la plupart des bugs shell.

## Les vrais tableaux

Pour stocker plusieurs valeurs, Bash a des tableaux dédiés :

```bash
# Tableau indexé
fruits=(pomme poire cerise)
echo ${fruits[1]}          # poire
echo ${fruits[@]}          # tous les éléments
echo ${#fruits[@]}         # nombre d'éléments

# Tableau associatif (Bash 4+)
declare -A capitales
capitales[france]="Paris"
capitales[espagne]="Madrid"
echo ${capitales[france]}
```

## Portée : globale par défaut

Une variable déclarée dans une fonction est globale :

```bash
f() {
    x=10          # modifie la variable globale !
    local y=20    # local à la fonction
}
```

## Différences avec les langages modernes

| Comportement | Bash | Python/JS |
|---|---|---|
| Type | tout est chaîne | types natifs |
| Portée par défaut | globale | locale (fonction/bloc) |
| `$var` non quoté | word splitting + glob | jamais de découpage |
| Plusieurs valeurs | tableau `()` ou IFS | liste/array natif |
| Null vs vide | `""` et variable non définie sont différents | `None` / `null` |

---

## Les formes de quotes

Bash reconnaît quatre mécanismes de guillemets, chacun avec un comportement distinct.

### Sans guillemets — expansion maximale

```bash
echo $HOME          # expansion de variable
echo *.txt          # glob : liste les fichiers .txt
echo $((2 + 2))     # arithmétique
msg="bonjour monde"
for w in $msg; do echo "$w"; done   # word splitting → "bonjour", puis "monde"
```

Sans quotes, Bash applique dans l'ordre : expansion de variables, substitution de commandes, arithmétique, puis **word splitting** (découpage sur IFS) et **glob expansion**. Ces deux dernières étapes sont la source de la plupart des bugs.

### Guillemets doubles `"..."` — expansion sans découpage

```bash
echo "$HOME"        # expansion de variable, mais pas de word splitting
echo "$(date)"      # substitution de commande préservée
echo "$((2 + 2))"   # arithmétique préservée
echo "*.txt"        # glob désactivé : affiche littéralement *.txt
fichier="mon fichier.txt"
rm "$fichier"       # un seul argument, même avec l'espace
```

À l'intérieur des doubles guillemets, `$`, `` ` ``, `\` et `!` gardent leur sens spécial. Tout le reste est littéral. Word splitting et glob sont désactivés — c'est la forme à utiliser par défaut pour les variables.

### Guillemets simples `'...'` — tout littéral

```bash
echo '$HOME'        # affiche : $HOME  (pas d'expansion)
echo '*.txt'        # affiche : *.txt
echo 'it'\''s ok'  # guillemet simple dans une chaîne : concaténation nécessaire
```

À l'intérieur des simples guillemets, **rien** n'est interprété — ni `$`, ni `\`, ni backtick. Aucun caractère spécial ne peut être échappé à l'intérieur (pas même `\'`). Pour inclure un guillemet simple, on ferme, on échappe, puis on rouvre : `'it'\''s ok'`.

Utiliser quand la valeur doit être transmise telle quelle à une commande externe (regex pour `grep`, expression `awk`, requête SQL, etc.).

### `$'...'` — quotes ANSI-C (séquences d'échappement)

```bash
echo $'bonjour\nmonde'   # retour à la ligne réel
echo $'\t→\ttabulé'      # tabulation
printf '%s\n' $'\x41'    # caractère hexadécimal : A
IFS=$'\n'                # définir IFS sur newline (idiome courant)
```

`$'...'` interprète les séquences d'échappement C (`\n`, `\t`, `\r`, `\\`, `\'`, `\xNN`, `\uNNNN`). Utile pour définir des caractères de contrôle sans passer par `printf` ou `echo -e`.

### Le backslash `\` — échappement caractère par caractère

```bash
echo \$HOME       # affiche : $HOME
echo it\'s\ ok    # espace et apostrophe échappés
rm mon\ fichier.txt
```

`\` neutralise le caractère suivant. Fonctionne hors guillemets et dans les doubles guillemets (pour `$`, `` ` ``, `"`, `\`, `!`). Déconseillé pour les chaînes longues — préférer les quotes.

### Récapitulatif

| Mécanisme | Variables | Commandes `$()` | Glob | Word splitting | Échappements `\n` |
|---|---|---|---|---|---|
| sans quotes | oui | oui | oui | oui | non |
| `"..."` | oui | oui | non | non | non |
| `'...'` | non | non | non | non | non |
| `$'...'` | non | non | non | non | **oui** |

**Règle pratique** : utiliser `"$var"` par défaut, `'...'` pour les valeurs brutes, `$'...'` pour les caractères de contrôle.

---

## Éviter les bugs liés au word splitting

### Règle principale : toujours guillemeter `"$var"`

```bash
fichier="mon fichier.txt"

rm $fichier    # BUG : rm "mon" "fichier.txt" → deux arguments
rm "$fichier"  # OK  : rm "mon fichier.txt"   → un seul argument
```

### Les tableaux pour les listes de valeurs

```bash
# Mauvais : stocker des chemins dans une chaîne
fichiers="/etc/hosts /etc/passwd /etc/fstab"
for f in $fichiers; do ...   # cassé si un chemin contient un espace

# Bon : tableau
fichiers=("/etc/hosts" "/etc/passwd" "/etc/fstab")
for f in "${fichiers[@]}"; do ...   # guillemets + @ obligatoires
```

`"${fichiers[@]}"` préserve chaque élément comme token distinct. `"${fichiers[*]}"` fusionne tout en une chaîne — rarement ce qu'on veut.

### `$@` vs `$*` pour les arguments

```bash
mafonction() {
    cp "$@" /dest/   # OK : chaque argument préservé
    cp $*    /dest/  # BUG : word splitting sur les espaces
}
```

### `find` avec `-print0` / `xargs -0`

```bash
# Cassé si noms de fichiers contiennent espaces/retours à la ligne
find . -name "*.log" | xargs rm

# Robuste : séparateur null
find . -name "*.log" -print0 | xargs -0 rm
```

### Résumé des patterns

| Situation | À éviter | À faire |
|---|---|---|
| Variable simple | `$var` | `"$var"` |
| Liste de valeurs | chaîne + IFS | tableau `()` |
| Parcourir un tableau | `${arr[*]}` | `"${arr[@]}"` |
| Passer des arguments | `$*` | `"$@"` |
| Fichiers avec espaces | `find \| xargs` | `find -print0 \| xargs -0` |

### Détecter les bugs : `shellcheck`

```bash
shellcheck monscript.sh
```

`shellcheck` repère automatiquement les variables non quotées, les `$*` dangereux, etc.

---

## Bash et Unicode

### Stockage des variables : des octets, pas des caractères

Bash stocke toutes les variables comme des **séquences d'octets bruts**. Il n'existe pas de type "chaîne Unicode" en interne. C'est la **locale** du processus qui détermine comment ces octets sont interprétés comme des caractères.

```bash
LANG=fr_FR.UTF-8    # bash lit LC_CTYPE pour savoir comment décoder
export LC_ALL=fr_FR.UTF-8
```

### `${#var}` — longueur : octets ou caractères ?

C'est le piège le plus fréquent :

```bash
export LANG=fr_FR.UTF-8
mot="café"
echo ${#mot}    # → 4  (caractères, avec locale UTF-8)

export LANG=C
echo ${#mot}    # → 5  (octets : é = 2 octets en UTF-8)
```

Avec la locale UTF-8, `${#var}` compte des **points de code**, pas des octets.

### `${var:offset:length}` — extraction de sous-chaîne

Même comportement : les indices sont en **caractères** si la locale est UTF-8 :

```bash
export LANG=fr_FR.UTF-8
s="éléphant"
echo "${s:0:3}"   # → élé  (3 caractères)

export LANG=C
echo "${s:0:3}"   # → él   (3 octets, coupe é au milieu → résultat cassé)
```

### Littéraux Unicode : `$'...'` (ANSI-C quoting)

Depuis bash 4.2, la syntaxe `$'...'` supporte les séquences d'échappement Unicode :

```bash
printf '%s\n' $'é'      # → é   (U+00E9)
printf '%s\n' $'\U0001F600'  # → 😀  (hors BMP, bash 4.2+)
```

C'est le seul moyen propre d'insérer un codepoint Unicode par sa valeur numérique dans un script.

### Modification de casse : `${var^^}` / `${var,,}`

Les opérateurs de casse sont locale-aware depuis bash 4 :

```bash
export LANG=fr_FR.UTF-8
s="école"
echo "${s^^}"   # → ÉCOLE  (é, ç, etc. convertis correctement)

export LANG=C
echo "${s^^}"   # → éCOLE  (é ignoré, non-ASCII laissé intact)
```

### Pattern matching et regex

- Le globbing (`*`, `?`, `[...]`) est locale-aware : `[[:alpha:]]` inclut les accents avec une locale UTF-8.
- `[[ $var =~ regex ]]` délègue à la libc (POSIX ERE) : la locale s'applique pour `[[:alpha:]]`, etc.

```bash
export LANG=fr_FR.UTF-8
[[ "éàü" =~ ^[[:alpha:]]+$ ]] && echo "match"  # → match
```

### Résumé des comportements selon la locale

| Fonctionnalité | `LANG=C` | `LANG=…UTF-8` |
|---|---|---|
| `${#var}` | octets | caractères |
| `${var:n:m}` | octets | caractères |
| `${var^^}` | ASCII seulement | locale-aware |
| `[[:alpha:]]` | ASCII seulement | inclut accents |
| `read` / `IFS` | octets | caractères |
| `$'\uXXXX'` | produit des octets UTF-8 | idem |

### Piège principal : scripts sans locale explicite

Un script qui ne fixe pas la locale hérite de celle de son appelant. Si un script est lancé par un cron job ou un service système avec `LANG=C`, tous les calculs de longueur et les extractions seront en octets — silencieusement incorrects pour du texte non-ASCII. La bonne pratique est de déclarer explicitement la locale en tête de script :

```bash
#!/usr/bin/env bash
export LC_ALL=fr_FR.UTF-8
```

# Variables Bash

## Tout est une chaîne

Par défaut, une variable Bash n'a pas de type — elle stocke toujours une chaîne :

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

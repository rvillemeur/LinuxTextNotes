# Outils texte en ligne de commande

Linux/Unix fournit de base des outils pour traiter et filtrer le texte, ce qui fait sa force.
La communication se fait à travers les pipes `|`, qui échangent des flux de texte d'une commande vers une autre, le stdout d'une commande devenant le stdin de la commande suivante.

Parmi les outils disponibles :

| Outil | Description |
|---|---|
| `cat` | concaténation de fichiers |
| `head` / `tail` | début et fin d'un fichier |
| `less` | pager interactif |
| `cut` | extraction de champs |
| `paste` | fusion de colonnes |
| `join` | jointure sur un champ commun |
| `sort` | tri de lignes |
| `uniq` | dédoublonnage de lignes consécutives |
| `wc` | comptage de lignes, mots, caractères |
| `grep` | recherche par expression régulière |
| `sed` | éditeur de flux |
| `awk` | traitement structuré champ par champ |
| `tr` | traduction/suppression de caractères |
| `tee` | duplication d'un flux |
| `xargs` | construction de commandes depuis stdin |
| `nl` | numérotation de lignes |
| `fmt` | reformatage en paragraphes |
| `strings` | extraction de chaînes depuis un binaire |
| `od` | dump octal/hexadécimal |
| `xxd` | dump hexadécimal lisible |
| `iconv` | conversion d'encodage |
| `spell` / `hunspell` | vérification orthographique |
| `m4` | générateur de macros (voir note en fin de fichier) |

Pour le traitement de documents structurés (groff, TeX/LaTeX), voir la section dédiée.

---

## `cat` — concaténer et afficher des fichiers

`cat` (concatenate) affiche un fichier sur stdout, ou fusionne plusieurs fichiers :

```bash
cat fichier.txt                    # afficher
cat fichier1.txt fichier2.txt      # concaténer vers stdout
cat fichier1.txt fichier2.txt > fusion.txt   # concaténer dans un fichier
```

Options utiles :

```bash
cat -n fichier.txt                 # numéroter toutes les lignes
cat -A fichier.txt                 # afficher les caractères invisibles ($ en fin de ligne, ^I pour tab)
cat -s fichier.txt                 # compresser les lignes vides consécutives
```

`cat -A` est utile pour détecter des fins de ligne Windows (`^M$` au lieu de `$`) ou des tabulations inattendues.

Créer un fichier court directement depuis le terminal :

```bash
cat > fichier.txt << 'EOF'
ligne 1
ligne 2
EOF
```

Note : utiliser `cat fichier | commande` au lieu de `commande < fichier` est souvent appelé "useless use of cat" — la redirection directe est plus efficace, mais `cat` reste utile quand on chaîne plusieurs fichiers.

## `head` et `tail` — début et fin d'un fichier

```bash
head fichier.txt                   # 10 premières lignes (défaut)
head -n 20 fichier.txt             # 20 premières lignes
head -c 100 fichier.txt            # 100 premiers octets

tail fichier.txt                   # 10 dernières lignes
tail -n 20 fichier.txt             # 20 dernières lignes
tail -n +5 fichier.txt             # à partir de la ligne 5 (toutes sauf les 4 premières)
```

### `tail -f` — suivre un fichier en temps réel

```bash
tail -f /var/log/syslog            # affiche les nouvelles lignes au fur et à mesure
tail -F /var/log/syslog            # idem, mais gère la rotation de log (fichier recréé)
```

`tail -f` est indispensable pour surveiller des logs applicatifs ou système en direct. Combiné avec `grep` :

```bash
tail -f access.log | grep "ERROR"
```

### Extraire une plage de lignes

```bash
# Lignes 20 à 30
head -n 30 fichier.txt | tail -n 11

# Avec sed (plus lisible)
sed -n '20,30p' fichier.txt
```

## `less` — lire un fichier interactivement

`less` est un **pager** : il affiche un fichier page par page sans le charger entièrement en mémoire — indispensable pour les gros fichiers et les logs.

```bash
less fichier.txt
less +G fichier.txt                # ouvrir directement à la fin
less +F fichier.txt                # mode suivi (comme tail -f, quitter avec Ctrl-C)
```

Raccourcis clavier dans `less` :

| Touche | Action |
|---|---|
| `Space` / `f` | page suivante |
| `b` | page précédente |
| `g` / `G` | début / fin du fichier |
| `/motif` | rechercher vers le bas |
| `?motif` | rechercher vers le haut |
| `n` / `N` | occurrence suivante / précédente |
| `q` | quitter |

Recherche dans plusieurs fichiers :

```bash
less fichier1.txt fichier2.txt     # :n et :p pour naviguer entre fichiers
```

`less` colore automatiquement la sortie de `man` et peut être configuré avec `LESS` et `LESSOPEN` pour traiter d'autres formats (archives, images avec `lesspipe`).

## `iconv` — convertir l'encodage d'un fichier

`iconv` convertit un fichier d'un encodage vers un autre — essentiel pour traiter des fichiers Windows (Latin-1, CP1252) ou des données venant de systèmes anciens :

```bash
iconv -f latin1 -t utf-8 fichier.txt > fichier_utf8.txt
iconv -f cp1252 -t utf-8 fichier.txt > fichier_utf8.txt  # Windows
iconv -f utf-16 -t utf-8 fichier.txt > fichier_utf8.txt
```

Lister les encodages disponibles :

```bash
iconv -l
```

Conversion en place (via un fichier temporaire) :

```bash
iconv -f latin1 -t utf-8 fichier.txt -o fichier.txt.tmp && mv fichier.txt.tmp fichier.txt
```

Détecter l'encodage d'un fichier inconnu :

```bash
file fichier.txt                   # détection heuristique
uchardet fichier.txt               # plus précis si disponible
```

Option `-c` pour ignorer les caractères non convertibles (au lieu d'abandonner) :

```bash
iconv -f latin1 -t utf-8 -c fichier.txt > fichier_utf8.txt
```

`iconv` est l'outil POSIX standard. `uconv` (du paquet ICU) offre plus d'options de normalisation Unicode si besoin.

## `paste` — coller des colonnes côte à côte

Fusionne des fichiers ligne par ligne, séparés par une tabulation :

```bash
# fichier noms.txt      fichier ages.txt
# Alice                 30
# Bob                   25
# Carol                 35

paste noms.txt ages.txt
# Alice   30
# Bob     25
# Carol   35

paste -d',' noms.txt ages.txt   # séparateur virgule
# Alice,30
# Bob,25
# Carol,35
```

Cas d'usage typique : convertir une liste verticale en CSV.

```bash
# Transformer une colonne en ligne séparée par des virgules
paste -sd',' noms.txt
# Alice,Bob,Carol
```

## `join` — jointure SQL entre deux fichiers

Fusionne deux fichiers sur un champ commun (comme un `JOIN` SQL). Les fichiers doivent être **triés** sur la clé :

```bash
# employes.txt (trié par id)    salaires.txt (trié par id)
# 1 Alice                       1 45000
# 2 Bob                         3 52000
# 3 Carol                       4 38000

join employes.txt salaires.txt
# 1 Alice 45000
# 3 Carol 52000
# (Bob absent de salaires.txt → exclu par défaut)

join -a1 employes.txt salaires.txt   # inclure les lignes sans correspondance
# 1 Alice 45000
# 2 Bob
# 3 Carol 52000
```

## `cut` — extraire des colonnes

Extrait des champs ou des plages de caractères d'un fichier texte :

```bash
# fichier /etc/passwd
# root:x:0:0:root:/root:/bin/bash
# alice:x:1000:1000::/home/alice:/bin/bash

cut -d':' -f1 /etc/passwd        # 1er champ (login)
# root
# alice

cut -d':' -f1,7 /etc/passwd      # champs 1 et 7
# root:/bin/bash
# alice:/bin/bash

cut -d':' -f1-3 /etc/passwd      # champs 1 à 3
# root:x:0
# alice:x:1000
```

Avec des positions de caractères (utile pour les fichiers à largeur fixe) :

```bash
cut -c1-10 fichier.txt           # 10 premiers caractères de chaque ligne
```

Limitation importante : `cut` ne gère pas les délimiteurs multiples ou les champs vides consécutifs. Pour ce cas, `awk` est plus adapté :

```bash
# Avec des espaces multiples entre champs, cut échoue
echo "a  b  c" | cut -d' ' -f2   # "" (champ vide)
echo "a  b  c" | awk '{print $2}' # "b"
```

## `sort` — trier des lignes

Trie les lignes d'un fichier, alphanumérique par défaut :

```bash
sort noms.txt                    # tri alphabétique
sort -r noms.txt                 # tri inverse
sort -n nombres.txt              # tri numérique (sans -n, "10" < "9")
sort -u noms.txt                 # dédoublonner (unique)
```

Trier sur un champ précis avec `-k` :

```bash
# fichier employes.txt
# Alice 30 45000
# Bob   25 52000
# Carol 35 38000

sort -k2 -n employes.txt         # trier par âge (2e colonne)
# Bob   25 52000
# Alice 30 45000
# Carol 35 38000

sort -k3 -n -r employes.txt      # trier par salaire décroissant
# Bob   25 52000
# Alice 30 45000
# Carol 35 38000
```

Trier un CSV :

```bash
sort -t',' -k2 -n fichier.csv    # 2e colonne, séparateur virgule
```

### `sort` et `join` vont ensemble

`join` exige des fichiers triés sur la clé de jointure — `sort` est donc son compagnon naturel :

```bash
sort -k1 employes.txt > employes_tries.txt
sort -k1 salaires.txt > salaires_tries.txt
join employes_tries.txt salaires_tries.txt
```

Ou en une ligne avec la substitution de processus :

```bash
join <(sort -k1 employes.txt) <(sort -k1 salaires.txt)
```

## `uniq` — dédoublonner des lignes consécutives

Supprime les lignes **consécutives** identiques — d'où le besoin de trier avant :

```bash
# fichier fruits.txt
# pomme
# pomme
# poire
# pomme

uniq fruits.txt          # supprime les doublons consécutifs
# pomme
# poire
# pomme                  # pas supprimé : non consécutif avec le premier

sort fruits.txt | uniq   # dédoublonnage complet
# poire
# pomme
```

Options utiles :

```bash
sort fruits.txt | uniq -c    # compter les occurrences
#       1 poire
#       3 pomme

sort fruits.txt | uniq -d    # afficher seulement les doublons
# pomme

sort fruits.txt | uniq -u    # afficher seulement les lignes uniques
# poire
```

Cas d'usage classique : trouver les IPs les plus fréquentes dans un log :

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -rn | head
```

Note : `sort -u` est équivalent à `sort | uniq` pour le dédoublonnage simple, mais `uniq -c` n'a pas d'équivalent direct dans `sort`.

## `wc` — compter lignes, mots, caractères

```bash
wc fichier.txt             # lignes  mots  octets
# 42  318  2048 fichier.txt

wc -l fichier.txt          # lignes seulement
wc -w fichier.txt          # mots seulement
wc -c fichier.txt          # octets
wc -m fichier.txt          # caractères (différent de -c en UTF-8)
```

Compter plusieurs fichiers :

```bash
wc -l chapitres/*.txt      # compte par fichier + total
```

Utilisation courante dans un pipeline :

```bash
grep -r "TODO" src/ | wc -l          # nombre de TODOs
ls *.log | wc -l                     # nombre de fichiers log
cat access.log | sort -u | wc -l     # nombre de visiteurs uniques
```

Piège UTF-8 : `-c` compte les **octets**, pas les caractères. Un caractère accentué vaut 2 octets en UTF-8 :

```bash
echo "café" | wc -c    # 6 (4 lettres + 1 octet supplémentaire pour é + newline)
echo "café" | wc -m    # 5 (4 caractères + newline)
```

## `grep` — filtrer des lignes par motif

Affiche les lignes qui correspondent à un motif (expression régulière par défaut) :

```bash
grep "erreur" journal.log          # lignes contenant "erreur"
grep -i "erreur" journal.log       # insensible à la casse
grep -v "erreur" journal.log       # lignes ne contenant PAS "erreur"
grep -n "erreur" journal.log       # avec numéros de ligne
grep -c "erreur" journal.log       # compter les correspondances
```

Recherche récursive dans un répertoire :

```bash
grep -r "TODO" src/                # récursif
grep -rl "TODO" src/               # afficher seulement les noms de fichiers
grep -r "TODO" src/ --include="*.py"   # filtrer par extension
```

Expressions régulières étendues avec `-E` (ou `egrep`) :

```bash
grep -E "erreur|warning" journal.log       # OU logique
grep -E "^[0-9]{4}-[0-9]{2}" journal.log  # lignes commençant par une date
grep -E "\b[A-Z]{2,}\b" texte.txt         # mots tout en majuscules
```

Contexte autour des correspondances :

```bash
grep -A3 "erreur" journal.log      # 3 lignes après
grep -B3 "erreur" journal.log      # 3 lignes avant
grep -C3 "erreur" journal.log      # 3 lignes avant et après
```

Astuce : `grep -F` traite le motif comme une chaîne littérale (pas de regex), plus rapide pour les recherches simples :

```bash
grep -F "192.168.1.1" access.log   # pas d'interprétation des points
```

## `sed` — éditeur de flux

`sed` transforme un flux de texte ligne par ligne. Son usage le plus courant est la substitution :

```bash
sed 's/ancien/nouveau/' fichier.txt        # première occurrence par ligne
sed 's/ancien/nouveau/g' fichier.txt       # toutes les occurrences
sed 's/ancien/nouveau/gi' fichier.txt      # insensible à la casse
sed -i 's/ancien/nouveau/g' fichier.txt    # modification en place
```

Modifier des fichiers en place avec sauvegarde :

```bash
sed -i.bak 's/http:/https:/g' config.txt  # crée config.txt.bak
```

Supprimer des lignes :

```bash
sed '/^#/d' config.txt             # supprimer les commentaires
sed '/^$/d' config.txt             # supprimer les lignes vides
sed '5d' fichier.txt               # supprimer la ligne 5
sed '2,5d' fichier.txt             # supprimer les lignes 2 à 5
```

Afficher seulement certaines lignes :

```bash
sed -n '10,20p' fichier.txt        # afficher les lignes 10 à 20
sed -n '/debut/,/fin/p' fichier.txt  # afficher entre deux motifs
```

Insertions et ajouts :

```bash
sed '3i\ligne insérée' fichier.txt   # insérer avant la ligne 3
sed '3a\ligne ajoutée' fichier.txt   # ajouter après la ligne 3
sed '1i\# entête' fichier.txt        # ajouter un entête
```

### Limites de `sed`

`sed` est puissant pour les transformations ligne par ligne, mais il devient vite illisible pour des opérations complexes. Pour manipuler des champs structurés ou des traitements multi-lignes, `awk` est plus adapté :

```bash
# Remplacer le 3e champ d'un CSV — laborieux en sed, naturel en awk
awk -F',' 'BEGIN{OFS=","} {$3="nouveau"; print}' fichier.csv
```

## `awk` — traitement structuré de texte

`awk` traite les fichiers texte champ par champ. Chaque ligne est découpée automatiquement en champs `$1`, `$2`, etc. (`$0` = ligne entière) :

```bash
# fichier employes.txt
# Alice 30 45000
# Bob   25 52000
# Carol 35 38000

awk '{print $1}' employes.txt          # 1er champ (nom)
awk '{print $1, $3}' employes.txt      # nom et salaire
awk '{print NR, $0}' employes.txt      # numéroter les lignes
```

### Structure d'un programme awk

```bash
awk 'BEGIN { ... }   # exécuté une fois avant la lecture
     /motif/ { ... } # exécuté pour chaque ligne correspondante
     END   { ... }'  # exécuté une fois après la lecture
```

### Filtrer des lignes

```bash
awk '$3 > 40000' employes.txt          # salaire > 40000
awk '$2 >= 30 && $3 > 40000' employes.txt
awk '/^Alice/' employes.txt            # lignes commençant par Alice
awk 'NR >= 2 && NR <= 5' fichier.txt  # lignes 2 à 5
```

### Calculs et agrégations

```bash
# Somme des salaires
awk '{total += $3} END {print "Total :", total}' employes.txt

# Moyenne
awk '{total += $3} END {print "Moyenne :", total/NR}' employes.txt

# Maximum
awk 'BEGIN{max=0} $3>max {max=$3; nom=$1} END{print nom, max}' employes.txt
```

### Séparateur de champs

```bash
awk -F':' '{print $1}' /etc/passwd         # séparateur ':'
awk -F',' '{print $2}' fichier.csv         # CSV
awk 'BEGIN{OFS=","} {print $1,$3}' employes.txt  # séparateur en sortie
```

### Tableaux associatifs

```bash
# Compter les occurrences de chaque valeur
awk '{count[$1]++} END {for (k in count) print k, count[k]}' fichier.txt

# Jointure entre deux fichiers (équivalent de join, sans tri préalable)
awk 'NR==FNR {sal[$1]=$2; next} $1 in sal {print $1, $2, sal[$1]}' \
    salaires.txt employes.txt
```

### Transformation de format

```bash
# Reformater un CSV en tableau lisible
awk -F',' '{printf "%-15s %-10s %s\n", $1, $2, $3}' fichier.csv

# Extraire des blocs entre deux motifs
awk '/BEGIN/,/END/' fichier.txt
```

### awk vs sed vs grep

| Besoin | Outil |
|---|---|
| Filtrer des lignes par motif | `grep` |
| Substitution simple | `sed` |
| Travailler sur des champs | `awk` |
| Calculs, agrégations | `awk` |
| Transformation complexe | `awk` |

`awk` est souvent la bonne réponse quand `grep` et `sed` commencent à montrer leurs limites. Au-delà, Python ou Perl deviennent plus lisibles.

## `tr` — traduire ou supprimer des caractères

`tr` opère caractère par caractère sur stdin — il ne lit pas de fichiers directement :

```bash
echo "Bonjour" | tr 'a-z' 'A-Z'       # majuscules
echo "Bonjour" | tr 'A-Z' 'a-z'       # minuscules
echo "a:b:c"   | tr ':' ','            # remplacer : par ,
```

Supprimer des caractères avec `-d` :

```bash
echo "Bon jour" | tr -d ' '            # supprimer les espaces → Bonjour
echo "a1b2c3"   | tr -d '0-9'          # supprimer les chiffres → abc
tr -d '\r' < fichier_windows.txt       # convertir CRLF → LF
```

Compresser les répétitions avec `-s` :

```bash
echo "a   b   c" | tr -s ' '          # compresser espaces multiples → a b c
echo "aabbcc"    | tr -s 'a-z'        # → abc
```

Cas d'usage courant : nettoyer un fichier CSV mal formaté ou normaliser des séparateurs dans un pipeline :

```bash
cat fichier.txt | tr -s ' ' | tr ' ' ','   # normaliser puis convertir en CSV
```

Note : `tr` ne supporte pas les expressions régulières — pour des substitutions complexes, `sed` est plus adapté.

## `tee` — dupliquer un flux

`tee` lit stdin et écrit simultanément vers stdout **et** vers un fichier — utile pour inspecter un pipeline sans l'interrompre :

```bash
commande | tee sortie.txt | suite       # enregistre ET continue le pipeline
```

Sans `tee`, il faut choisir entre afficher et sauvegarder :

```bash
# Sans tee : on perd soit l'affichage, soit le fichier
commande > sortie.txt           # sauvegarde, rien à l'écran
commande | suite                # continue, rien de sauvegardé

# Avec tee : les deux
commande | tee sortie.txt | suite
```

Exemples concrets :

```bash
# Compiler et voir les erreurs tout en les sauvegardant
make 2>&1 | tee build.log

# Inspecter un pipeline au milieu
cat access.log | grep "404" | tee erreurs.txt | wc -l

# Ajouter à un fichier existant
commande | tee -a journal.log
```

`tee` vers plusieurs fichiers à la fois :

```bash
commande | tee fichier1.txt fichier2.txt | suite
```

## `xargs` — construire des commandes à partir de stdin

`xargs` prend des données sur stdin et les passe comme arguments à une commande. Il résout un problème fondamental : la plupart des commandes ne lisent pas stdin comme liste d'arguments.

```bash
# Sans xargs : impossible de passer stdin à rm
find . -name "*.tmp" | rm          # erreur : rm ne lit pas stdin

# Avec xargs : fonctionne
find . -name "*.tmp" | xargs rm
```

### Comportement de base

```bash
echo "a b c" | xargs echo          # echo a b c
ls *.txt | xargs wc -l             # compter les lignes de tous les .txt
cat liste.txt | xargs rm           # supprimer les fichiers listés
```

Par défaut, `xargs` regroupe les arguments en autant de commandes que nécessaire pour éviter la limite du système — il ne lance pas une commande par argument.

### Placer les arguments avec `-I`

```bash
# {} est remplacé par chaque ligne de stdin
cat liste.txt | xargs -I{} cp {} /dest/
ls *.log | xargs -I{} mv {} {}.bak
```

### Noms de fichiers avec espaces : `-0`

Le découpage par défaut se fait sur les espaces — dangereux avec des noms de fichiers :

```bash
# Risqué : "mon fichier.txt" devient deux arguments
find . -name "*.txt" | xargs rm

# Robuste : séparateur null
find . -name "*.txt" -print0 | xargs -0 rm
```

### Parallélisme avec `-P`

```bash
# Traiter 4 fichiers en parallèle
find . -name "*.png" -print0 | xargs -0 -P4 -I{} convert {} {}.jpg
```

### Limiter le nombre d'arguments avec `-n`

```bash
echo "a b c d" | xargs -n2 echo   # 2 arguments par commande
# echo a b
# echo c d
```

### Confirmation interactive avec `-p`

```bash
cat fichiers_a_supprimer.txt | xargs -p rm   # demande confirmation pour chaque commande
```

### xargs vs boucle for

```bash
# Boucle for : plus lisible, gère bien les espaces avec les guillemets
for f in *.txt; do cp "$f" /dest/; done

# xargs -P : plus efficace pour le parallélisme
find . -name "*.txt" -print0 | xargs -0 -P4 -I{} cp {} /dest/
```

La boucle `for` est préférable pour la lisibilité et la robustesse dans les scripts. `xargs` brille pour le parallélisme et pour chaîner avec `find`.

## `strings` — extraire les chaînes lisibles d'un binaire

`strings` parcourt un fichier binaire et affiche toutes les séquences de caractères imprimables d'au moins 4 caractères (par défaut). Utile pour inspecter un exécutable ou un fichier inconnu sans le désassembler :

```bash
strings /usr/bin/ls                # chaînes dans l'exécutable ls
strings fichier.bin | grep "http"  # chercher des URLs dans un binaire
strings -n 8 fichier.bin           # séquences d'au moins 8 caractères
```

Cas d'usages courants :

```bash
# Trouver la version embarquée dans un binaire
strings monprogramme | grep -i "version"

# Détecter des mots de passe ou clés en clair dans un binaire
strings monprogramme | grep -iE "password|secret|key|token"

# Inspecter un fichier PDF ou Office pour en extraire le texte brut
strings document.pdf | less
```

`strings` n'analyse pas la structure du binaire — il trouve simplement les octets qui ressemblent à du texte. Pour une analyse plus fine, `objdump` ou `readelf` sont plus adaptés.

## `fmt` — reformater du texte en paragraphes

`fmt` reformate du texte pour respecter une largeur de ligne maximale (72 caractères par défaut). Utile pour les scripts qui génèrent des messages ou pour nettoyer du texte mal formaté :

```bash
fmt fichier.txt                    # reformater à 72 caractères par ligne
fmt -w 80 fichier.txt              # largeur maximale 80 caractères
fmt -w 80 -s fichier.txt           # -s : ne jamais fusionner les lignes courtes
```

Reformater uniquement les paragraphes (séparés par des lignes vides) :

```bash
fmt -w 72 README.txt
```

Usage dans un script pour formater un message :

```bash
message="Ceci est un très long message qui dépasse la largeur normale d'un terminal standard de 80 colonnes."
echo "$message" | fmt -w 72
```

`fmt` est rudimentaire — il ne comprend pas le Markdown, le groff ou le HTML. Pour un formatage avancé, `par` (si disponible) offre plus de contrôle sur l'indentation et les préfixes de ligne.

## `spell` — vérification orthographique

`spell` est l'outil historique Unix de correction orthographique. Il affiche les mots non reconnus dans un fichier :

```bash
spell fichier.txt                  # liste les mots inconnus (anglais par défaut)
spell +mots_custom.txt fichier.txt # ajouter un dictionnaire personnel
```

Limitation importante : `spell` travaille mot par mot, sans contexte grammatical, et le dictionnaire est souvent limité. Sur les systèmes modernes il est généralement remplacé par `aspell` ou `hunspell` :

```bash
# aspell : interactif, corrige fichier en place
aspell check fichier.txt

# aspell en mode liste (comme spell)
aspell list --lang=fr < fichier.txt

# hunspell : utilisé par LibreOffice, supporte le français
hunspell -d fr_FR fichier.txt
hunspell -l -d fr_FR fichier.txt   # mode liste uniquement
```

Pour un document technique en français, `hunspell` avec le dictionnaire `fr_FR` est le choix le plus robuste — c'est le même moteur que LibreOffice.

## `nl` — numéroter les lignes

`nl` numérote les lignes d'un fichier, avec plus de contrôle que `cat -n` ou `awk '{print NR, $0}'` :

```bash
nl fichier.txt                     # numérotation des lignes non vides
cat -n fichier.txt                 # équivalent simple, numérote tout
```

Options utiles :

```bash
nl -ba fichier.txt                 # numéroter toutes les lignes (y compris vides)
nl -v10 fichier.txt                # commencer à 10
nl -i5 fichier.txt                 # incrémenter de 5
nl -w3 -s': ' fichier.txt          # largeur 3, séparateur ": "
```

`nl` comprend la notion de **sections** (en-tête `\:\:\:`, corps `\:\:`, pied `\:`) pour numéroter différemment les parties d'un document. En pratique c'est rarement utile — `awk '{print NR"\t"$0}'` suffit dans la plupart des pipelines.

## `od` — afficher le contenu brut d'un fichier

`od` (octal dump) affiche le contenu binaire d'un fichier en différentes bases. Utile pour inspecter des fichiers binaires, des caractères invisibles ou des fins de ligne :

```bash
od fichier.txt                     # affichage octal (défaut)
od -c fichier.txt                  # caractères avec échappements (\n, \t, \r...)
od -x fichier.txt                  # hexadécimal 16 bits
od -An -c fichier.txt              # sans les adresses
```

Détecter des fins de ligne Windows (CRLF) :

```bash
od -c fichier.txt | grep '\\r'     # présence de \r → fichier Windows
```

Inspecter les premiers octets (magic bytes) d'un fichier :

```bash
od -An -tx1 -N8 fichier.png        # 8 premiers octets en hex
# 89 50 4e 47 0d 0a 1a 0a          # signature PNG
```

`od` est l'outil historique POSIX. Sur les systèmes modernes, `xxd` est plus lisible.

## `xxd` — dump hexadécimal lisible

`xxd` affiche un fichier en hexadécimal avec la représentation ASCII en regard — le format classique des éditeurs hexadécimaux :

```bash
xxd fichier.bin
# 00000000: 7f45 4c46 0201 0100 0000 0000 0000 0000  .ELF............
# 00000010: 0300 3e00 0100 0000 1010 4000 0000 0000  ..>.......@.....
```

Limiter la sortie :

```bash
xxd -l 16 fichier.bin              # 16 premiers octets seulement
xxd -s 256 fichier.bin             # à partir de l'offset 256
xxd -c 8 fichier.bin               # 8 octets par ligne
```

Mode texte plat avec `-p` :

```bash
xxd -p fichier.bin                 # hex brut sans adresses ni ASCII
# 7f454c460201010000000000000000000300...
```

### Aller-retour binaire avec `xxd -r`

`xxd` permet de reconstruire un fichier binaire depuis sa représentation hex — utile en CTF ou pour patcher un binaire :

```bash
xxd binaire > dump.hex             # extraire
# ... modifier dump.hex ...
xxd -r dump.hex > binaire_modifie  # reconstruire
```

### od vs xxd

| | `od` | `xxd` |
|---|---|---|
| Disponibilité | POSIX, partout | nécessite vim ou xxd séparé |
| Lisibilité | moyenne | bonne (hex + ASCII côte à côte) |
| Reconstruction binaire | non | oui (`-r`) |
| Inspecter des caractères | excellent (`-c`) | moins adapté |

Pour inspecter des caractères invisibles : `od -c`. Pour lire un binaire : `xxd`.

## Sont-elles encore utiles ?

**`paste` — oui, régulièrement.** Le cas `-sd','` pour aplatir une colonne en liste est très courant dans les pipelines.

**`join` — rarement.** Elle a deux contraintes pénibles : le tri obligatoire et la gestion d'un seul champ clé. En pratique, dès que les données sont un peu complexes, on préfère :

```bash
# Même résultat, plus flexible
awk 'NR==FNR { sal[$1]=$2; next } $1 in sal { print $1, $2, sal[$1] }' \
    salaires.txt employes.txt
```

Ou carrément `sqlite3` pour des jointures réelles :

```bash
sqlite3 :memory: -cmd ".separator ' '" \
    ".import employes.txt emp" \
    ".import salaires.txt sal" \
    "SELECT emp.id, emp.nom, sal.salaire FROM emp JOIN sal ON emp.id=sal.id;"
```

`join` reste utile dans des scripts portables où on ne veut pas dépendre d'`awk` ou de SQLite, ou pour des fichiers déjà triés par nature (logs avec timestamps, etc.).

## `m4` — pourquoi ne pas l'approfondir

`m4` est un générateur de macros qui précède groff dans les pipelines de publication historiques des années 80-90. Il permettait de définir des substitutions de texte réutilisables avant que les macro-packages comme `-mom` n'atteignent leur maturité actuelle.

**Ce que m4 apporterait par rapport aux macros groff natives :**
- Substitution de texte plus lisible que `.ds`/`.de`
- Conditionnels plus expressifs que `.if`/`.ie`
- Génération de variantes d'un même document (version papier vs web, brouillon vs final)

**Ce que groff/-mom fait déjà nativement :**

| Besoin | groff natif |
|---|---|
| Inclusion de fichiers | `.so` |
| Variables texte | `.ds` |
| Macros | `.de` |
| Conditionnels | `.if`, `.ie`, `.el` |
| Registres numériques | `.nr` |

Pour une publication de notes avec `-mom`, `m4` n'apporte rien que groff ne couvre déjà. Le pipeline `soelim | preconv | groff` est suffisant.

Le seul cas où `m4` deviendrait utile serait la génération de plusieurs variantes du document depuis une source unique — mais à ce stade il concurrence directement des outils modernes comme Pandoc ou une logique de Makefile. Le rapport effort/bénéfice ne justifie pas l'investissement.

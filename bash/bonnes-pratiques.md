# Bonnes pratiques Bash

## En-tête de script

```bash
#!/usr/bin/env bash
set -euo pipefail
```

- `#!/usr/bin/env bash` — trouve `bash` dans le PATH plutôt que de supposer `/bin/bash`.
- `set -e` — arrête le script à la première commande qui échoue.
- `set -u` — erreur si une variable non définie est utilisée (détecte les fautes de frappe).
- `set -o pipefail` — un pipe échoue si n'importe quelle commande de la chaîne échoue (sans ça, seul le dernier code de retour compte).

Ces trois options ensemble constituent le filet de sécurité minimal de tout script sérieux.

### Cas où `set -e` nuit

`set -e` s'arrête même sur les tests intentionnels :

```bash
# Cassé avec set -e
grep -q "motif" fichier   # si grep ne trouve rien → exit 1 → script arrêté

# Correct : tester explicitement
if grep -q "motif" fichier; then
    echo "trouvé"
fi

# Ou désactiver localement
grep -q "motif" fichier || true
```

---

## Gestion des erreurs

### Trap pour le nettoyage

```bash
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

# Le fichier temporaire est supprimé même en cas d'erreur ou de Ctrl-C
```

`EXIT` se déclenche à toute sortie du script — normale, erreur, ou signal. Indispensable pour les fichiers temporaires, les verrous, les ressources à libérer.

```bash
# Trap sur plusieurs signaux
trap 'echo "Interrompu"; exit 1' INT TERM
```

### Codes de retour explicites

```bash
traiter_fichier() {
    local fichier="$1"
    [[ -f "$fichier" ]] || { echo "Erreur : $fichier introuvable" >&2; return 1; }
    # traitement...
}
```

- Toujours écrire les messages d'erreur sur `stderr` (`>&2`).
- Retourner des codes significatifs : `0` = succès, `1` = erreur générale, `2` = mauvaise utilisation.

---

## Variables

### Toujours guillemeter les expansions

```bash
# Mal
rm $fichier
cp $src $dst

# Bien
rm "$fichier"
cp "$src" "$dst"
```

Voir `variable.md` pour l'explication complète du word splitting.

### Nommage

| Portée | Convention | Exemple |
|---|---|---|
| Variables d'environnement / globales | MAJUSCULES | `DATABASE_URL` |
| Variables locales à un script | minuscules | `nb_lignes` |
| Variables locales à une fonction | `local` + minuscules | `local résultat` |

Ne pas utiliser de majuscules pour les variables internes — risque d'écraser des variables d'environnement système (`PATH`, `HOME`, `IFS`…).

### Valeurs par défaut et vérification

```bash
# Valeur par défaut si vide ou non défini
port="${PORT:-8080}"

# Erreur si non défini
: "${API_KEY:?La variable API_KEY est requise}"

# Assigner seulement si non défini
: "${TIMEOUT:=30}"
```

---

## Fonctions

### Déclarer les variables locales

```bash
convertir() {
    local input="$1"
    local résultat
    résultat=$(traitement "$input")
    echo "$résultat"
}
```

Sans `local`, chaque variable assignée dans une fonction modifie le contexte global.

### Retourner une valeur

```bash
# Mauvais : utiliser une variable globale
calculer() { résultat=$((2 + 2)); }

# Bien : stdout pour les données, return pour les codes d'état
calculer() { echo $((2 + 2)); }
valeur=$(calculer)
```

---

## Fichiers et chemins

### Fichiers temporaires

```bash
# Toujours mktemp, jamais un nom fixe
tmpfile=$(mktemp)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpfile" "$tmpdir"' EXIT
```

Un nom fixe comme `/tmp/monscript.tmp` crée une vulnérabilité de type symlink attack et casse en exécution parallèle.

### Chemins robustes

```bash
# Répertoire du script lui-même (résout les symlinks)
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

# Construire des chemins à partir de là
config="$SCRIPT_DIR/config.ini"
```

### Fichiers dont le nom commence par `-`

```bash
# Risque : rm -f interprété comme option
rm "$fichier"      # si fichier="-rf /" → catastrophe

# Sécurisé : -- marque la fin des options
rm -- "$fichier"
```

---

## Sécurité

### Ne jamais utiliser `eval` sur des données externes

```bash
# Dangereux
eval "commande=$input"   # si input contient "$(rm -rf ~)" → exécuté

# Alternative : tableau pour les arguments dynamiques
args=()
args+=("--port" "$port")
args+=("--host" "$host")
commande "${args[@]}"
```

### Éviter l'injection de commande dans les sous-shells

```bash
# Dangereux
résultat=$(cat "$fichier_utilisateur")   # nom contrôlé par l'utilisateur

# Vérifier avant d'utiliser
[[ "$fichier_utilisateur" =~ ^[a-zA-Z0-9._-]+$ ]] || exit 1
```

### Permissions des scripts

```bash
chmod 755 monscript.sh   # exécutable, pas inscriptible par tous
```

---

## Débogage

### `set -x` — trace l'exécution

```bash
set -x          # active la trace
commande        # affiche "+ commande" avant exécution
set +x          # désactive

# Ou sur une section précise
{ set -x; commande_suspecte; set +x; } 2>trace.log
```

### Vérification de syntaxe sans exécuter

```bash
bash -n monscript.sh
```

### `shellcheck` — analyse statique

```bash
shellcheck monscript.sh
```

Détecte : variables non quotées, `$*` dangereux, comparaisons incorrectes, commandes inexistantes, et des dizaines d'autres pièges. À intégrer dans le workflow de développement.

---

## Portabilité bash vs sh

Si le shebang est `#!/bin/sh`, les extensions bash sont interdites :

| Fonctionnalité | bash uniquement |
|---|---|
| Tableaux `()` | oui |
| `[[ ]]` | oui |
| `$'...'` | oui |
| `declare`, `local` | `local` est dans sh, `declare` non |
| Substitution de processus `<()` | oui |
| Arithmétique `(( ))` | oui |

Choisir `#!/usr/bin/env bash` dès qu'on utilise l'une de ces fonctionnalités.

---

## Checklist avant de livrer un script

- [ ] Shebang `#!/usr/bin/env bash`
- [ ] `set -euo pipefail` en début de script
- [ ] Toutes les variables sont quotées (`"$var"`)
- [ ] Les fichiers temporaires passent par `mktemp` avec `trap EXIT`
- [ ] Les messages d'erreur vont sur `stderr` (`>&2`)
- [ ] `shellcheck` ne remonte aucun avertissement
- [ ] Le script a été testé avec des noms de fichiers contenant des espaces

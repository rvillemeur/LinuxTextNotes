# Vim9 Script — Aide-mémoire

Vim9 script est le langage de script natif de Vim depuis la version 9. Il rompt
délibérément avec la syntaxe legacy de Vimscript pour offrir une syntaxe plus
claire, une vérification de types à la compilation, et de meilleures
performances. Ce mémo couvre exclusivement Vim9 script.

Placer `vim9script` en première ligne de tout fichier pour activer ce mode. Sans
cette déclaration, Vim exécute le fichier en mode legacy, avec une syntaxe et
une sémantique différentes.

```vim
vim9script
```

Références : `:help vim9`, [Learn Vim9 Script](https://learnxinyminutes.com/vim9script/),
[Vim9 Script for Python Developers](https://github.com/yegappan/Vim9ScriptForPythonDevelopers/blob/main/Vim9ScriptForPythonDevelopers.md).


## Éléments de base

```vim
# Commentaire (# remplace le " du mode legacy)

var compteur = 0          # déclaration et initialisation
var nom: string = "Alice" # avec annotation de type
const PI: float = 3.14159 # constante (affectation interdite)
final liste = [1, 2, 3]   # référence non-réassignable, contenu mutable

g:optionGlobale = true    # variable globale (préfixe g:)
```

Les préfixes de portée `l:` (local), `s:` (script), `g:` (global) existent
toujours, mais dans une fonction `def` les variables locales n'ont pas besoin du
préfixe `l:`.


## Types de données

### Types primitifs

| Type      | Exemples                          | Remarque                         |
|-----------|-----------------------------------|----------------------------------|
| `number`  | `-1`, `0`, `42`                   | entier 64 bits signé             |
| `number`  | `0b1011`, `0o17`, `0x1AE`         | binaire, octal, hexadécimal      |
| `float`   | `3.14`, `-1.5e2`                  | virgule flottante 64 bits        |
| `bool`    | `true`, `false`                   | pas de majuscule                 |
| `string`  | `"hello\n"`, `'littéral'`         | double : séquences d'échappement |
| `blob`    | `0z68656c6c6f`                    | données binaires brutes          |

### Types composés

```vim
var fruits: list<string>        = ['pomme', 'poire']
var scores: dict<number>        = {alice: 10, bob: 7}
var coords: tuple<number, number> = (48.85, 2.35)
var cb:     func(string): bool  = (s) => s->len() > 0
```

### Valeurs spéciales

```vim
v:none   # absence de valeur (différent de null)
v:null   # valeur nulle
v:true   # équivalent booléen à true
v:false  # équivalent booléen à false
```

### Alias de type

```vim
type Entiers  = list<number>
type Callback = func(string): bool

var ids: Entiers = [1, 2, 3]
```

### Conversions utiles

```vim
string(42)          # number  → string  : "42"
str2nr("42")        # string  → number  : 42
str2float("3.14")   # string  → float   : 3.14
float2nr(3.9)       # float   → number  : 3 (troncature)
type(valeur)        # retourne un entier identifiant le type
typename(valeur)    # retourne le nom du type sous forme de string
```


## Opérateurs

### Arithmétique et chaînes

```vim
3 + 2    # 5
7 / 2    # 3  (division entière si les deux opérandes sont des number)
7.0 / 2  # 3.5
7 % 2    # 1
"bon" .. "jour"   # "bonjour" (concaténation, pas +)
```

### Comparaison

```vim
==   !=   <   >   <=   >=   # selon l'option ignorecase pour les strings
==#  !=#  <#  >#  <=#  >=#  # toujours sensible à la casse
==?  !=?  <?  >?  <=?  >=?  # toujours insensible à la casse
=~   !~                      # correspondance avec expression régulière
```

### Logique et ternaire

```vim
a && b
a || b
!a
condition ? valeur_si_vrai : valeur_si_faux
```

### Opérateur méthode (method call)

```vim
"bonjour"->toupper()         # équivalent à toupper("bonjour")
[3, 1, 2]->sort()->reverse() # chaînage
```


## Structures de contrôle

### Condition

```vim
if score > 90
  echo "Excellent"
elseif score > 60
  echo "Passable"
else
  echo "Insuffisant"
endif
```

### Boucle for

```vim
# itération sur une liste
for fruit in ['pomme', 'poire', 'cerise']
  echo fruit
endfor

# itération sur un intervalle
for i in range(5)        # 0, 1, 2, 3, 4
  echo i
endfor

for i in range(2, 10, 3) # 2, 5, 8
  echo i
endfor

# itération sur les clés d'un dictionnaire
for cle in keys(scores)
  echo cle .. ' : ' .. scores[cle]
endfor

# itération sur les paires clé-valeur
for [cle, val] in items(scores)
  echo cle .. ' => ' .. val
endfor

# déstructuration sur une liste de listes
for [x, y] in [[1, 2], [3, 4]]
  echo x + y
endfor
```

### Boucle while

```vim
var i = 0
while i < 5
  echo i
  i += 1
endwhile
```

### Contrôle de boucle

```vim
break     # quitte la boucle immédiatement
continue  # passe à l'itération suivante
```

### Gestion des erreurs

```vim
try
  var f = readfile('/chemin/inexistant')
catch /E484/
  echo "Fichier introuvable : " .. v:exception
catch /^MaLib:/
  echo "Erreur applicative : " .. v:exception
finally
  echo "Bloc toujours exécuté"
endtry

# Lever une erreur
throw "MaLib: valeur invalide"
```

`v:exception` contient le message de l'erreur capturée. Le pattern du `catch`
est une expression régulière comparée à ce message.


## Fonctions

### Déclaration avec `def`

```vim
def Saluer(nom: string): string
  return "Bonjour, " .. nom
enddef

# Sans valeur de retour
def Afficher(msg: string)
  echo msg
enddef

# Argument avec valeur par défaut
def Saluer(nom: string, titre: string = "M.")
  echo titre .. " " .. nom
enddef

# Arguments variadiques
def Somme(...nombres: list<number>): number
  var total = 0
  for n in nombres
    total += n
  endfor
  return total
enddef

echo Somme(1, 2, 3)  # 6
```

Les fonctions `def` sont vérifiées à la compilation : les types des arguments et
du retour sont contrôlés. Contrairement au mode legacy, elles ne s'appellent pas
avec `call`.

### Fonctions lambda

```vim
var double = (n: number): number => n * 2
echo double(5)  # 10

# Corps multi-lignes
var carre = (n: number): number => {
  var r = n * n
  return r
}

# Avec filter et map (signature : index, valeur)
var pairs   = [1, 2, 3, 4]->filter((_, v) => v % 2 == 0)
var doubles = [1, 2, 3]->map((_, v) => v * 2)
```

### Closures

Une fonction `def` ou lambda peut capturer les variables de la portée englobante.

```vim
def FaireCompteur(): func(): number
  var n = 0
  return (): number => {
    n += 1
    return n
  }
enddef

var c = FaireCompteur()
echo c()  # 1
echo c()  # 2
echo c()  # 3
```

### Références de fonctions

```vim
var fn: func(number): number = Somme  # référence sans appel
var r = fn(10, 20)

# Fonction builtin comme référence
var trier = function('sort')
```


## Modules — import / export

Vim9 script introduit un système de modules explicite. Seules les définitions
marquées `export` sont accessibles depuis l'extérieur.

**Dans `autoload/utils.vim` :**

```vim
vim9script

export def Majuscule(s: string): string
  return s->toupper()
enddef

export var Version = "1.0"

def Interne(): void  # non exportée, non accessible de l'extérieur
  echo "privé"
enddef
```

**Dans un autre fichier :**

```vim
vim9script

import autoload 'utils.vim'           # chemin relatif à 'autoload/'
echo utils.Majuscule("bonjour")       # "BONJOUR"
echo utils.Version                    # "1.0"

# Alias pour raccourcir
import autoload 'utils.vim' as u
echo u.Majuscule("monde")
```

`import autoload` diffère de `import` simple : le chargement est différé jusqu'au
premier accès, comme le mécanisme autoload traditionnel.


## Classes

Vim9 script (à partir de Vim 9.1) intègre un système orienté objet natif.

### Déclaration de base

```vim
vim9script

class Compteur
  var valeur: number = 0         # propriété d'instance
  static var instances: number = 0  # propriété de classe

  def new(depart: number = 0)    # constructeur
    this.valeur = depart
    Compteur.instances += 1
  enddef

  def Incrementer(pas: number = 1)
    this.valeur += pas
  enddef

  def Valeur(): number
    return this.valeur
  enddef

  static def NombreInstances(): number
    return Compteur.instances
  enddef
endclass

var c = Compteur.new(10)
c.Incrementer()
echo c.Valeur()              # 11
echo Compteur.NombreInstances()  # 1
```

### Héritage

```vim
class Animal
  var nom: string

  def new(this.nom: string)  # syntaxe courte : initialise this.nom directement
  enddef

  def Parler(): string
    return this.nom .. " émet un son"
  enddef
endclass

class Chien extends Animal
  def new(nom: string)
    super.new(nom)
  enddef

  def Parler(): string          # redéfinition de méthode
    return this.nom .. " aboie"
  enddef
endclass

var rex = Chien.new("Rex")
echo rex.Parler()  # "Rex aboie"
```

### Classes abstraites et interfaces

```vim
# Classe abstraite : ne peut pas être instanciée directement
abstract class Forme
  abstract def Aire(): float    # méthode sans corps, à implémenter

  def Decrire(): string         # méthode concrète héritée
    return "Aire = " .. string(this.Aire())
  enddef
endclass

class Rectangle extends Forme
  var largeur: float
  var hauteur: float

  def new(this.largeur: float, this.hauteur: float)
  enddef

  def Aire(): float
    return this.largeur * this.hauteur
  enddef
endclass

# Interface : contrat sans implémentation
interface Serialisable
  def Serialiser(): string
  def Deserialiser(data: string)
endinterface

class Config implements Serialisable
  var data: dict<string> = {}

  def Serialiser(): string
    return json_encode(this.data)
  enddef

  def Deserialiser(d: string)
    this.data = json_decode(d)
  enddef
endclass
```

Une classe peut `extends` une seule classe et `implements` plusieurs interfaces.


## Énumérations

```vim
enum Direction
  Nord,
  Sud,
  Est,
  Ouest
endenum

var d: Direction = Direction.Nord
echo d.name     # "Nord"
echo d.ordinal  # 0

# Avec comparaison
if d == Direction.Nord
  echo "cap au nord"
endif

# Itération sur toutes les valeurs
for dir in Direction.values
  echo dir.name
endfor
```


## Aide-mémoire rapide

| Élément            | Vim9 script              | Legacy (à éviter)         |
|--------------------|--------------------------|---------------------------|
| Commentaire        | `#`                      | `"`                       |
| Déclaration var    | `var x = 1`              | `let x = 1`               |
| Fonction           | `def F(a: type): type`   | `function! F(a)`          |
| Appel de fonction  | `F(arg)`                 | `call F(arg)`             |
| Concaténation      | `"a" .. "b"`             | `"a" . "b"`               |
| Lambda             | `(x) => x * 2`           | —                         |
| Import             | `import autoload 'f.vim'`| `runtime autoload/f.vim`  |
| Classe             | `class C` / `endclass`   | —                         |
| Enum               | `enum E` / `endenum`     | —                         |

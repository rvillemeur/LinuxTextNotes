# introduction

Vim Script permet de personnaliser finement l'éditeur Vim, et d'intégrer plus 
facilement des outils externe. Ce mémo se concentre sur Vim9 script livré avec 
Vim9, qui comprends une refonte asssez substantielle de la syntaxe.

Mettre `vim9script` au début du script pour s'assurer que Vim va bien l'éxecuter 
sous ce mode. Cela permet aussi à d'autre personne d'immédiatement comprendre 
que le script n'utilise pas la syntaxe legacy de Vim

Pour avoir de l'aide, taper `:help vim9`.  lien utile: [apprendre
vim9](https://learnxinyminutes.com/vim9script/), et [vim9 script for python
developer](https://github.com/yegappan/Vim9ScriptForPythonDevelopers/blob/main/Vim9ScriptForPythonDevelopers.md)
Le site de référence reste [Learn vimscript the hard
way](https://learnvimscriptthehardway.stevelosh.com/), mais il est d'abord orienté VimScript d'origine, sans inclure les optimisations propre à VimScript9


## éléments de base

`#` commence un commentaire
`var` déclare une variable
`const` et `final` pour la déclaration de constante.

préfixer avec `g:` pour une variable globale

## type de donnée et expression litérales


```txt
integer		-1, 0, 5
binary	    0b1011
octal	    0477
hexadecimal	0x1AE
float		3.14, -1.5e2
string		"hello", 'world'
boolean     true, false
list	    [], [5, 9], ['a', 'b']
tuple	    (), (1,), (5, 9), ('a', 'b')
dict	    {}, {idx: 2, name: 'abc'}
special	    none, null
```

détail dans `:help eval`

## déclaration de fonction
`def` ma fonction. On déclare le type des arguments et de retour.

	`def CallMe(count: number, message: string): bool`

Vim9 script permet l'utilisation des fonctions lambda avec `=>`.


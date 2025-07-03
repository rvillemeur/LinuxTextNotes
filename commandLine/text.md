# Entrée/sortie dans les commandes

Chaque processus se voit attribuer par défaut 3 handle correspondant à
- STDIN -> entrée standard
- STDOUT -> sortie standard
- STDERR -> sortie d'erreur standard
-
Les processus communiquent entre eux à l'aide de signaux qui permettent de les 
tuer, de savoir s'ils sont terminé proprement, etc...

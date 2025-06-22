# tmux

## introduction

tmux (et son cousin screen du project GNU) sont des multiplexeur de terminaux.
À partir d'un terminal existant, il est possible de créer autant de
sous-terminaux que désirés, permettant d'interagir avec plusieurs session au
sein de la même fenêtre du bureau graphique. Ce sont des composants essentiels
pour les interfaces textuelles, permettant par exemple d'afficher côte à côte
une fenêtre d'édition avec VI, un environnement d'excution bash, et un
environnement de test ou de monitoring.

## Gestion des panes dans tmux

Tmux, comme toute application textuelle, montre tout son intérêts lorsqu'on
associe les fonctions les plus utile à des raccourcis clavier, en particulier
pour diviser la fenêtre en cours en multiple sous écran appellés `panes` dans la
terminologie `tmux`


Par exemple

| prefix | action |
|--------|-----|
|  -      |	split-window -h (split horizontally)|
|  |      |	split-window -v (split vertically)|
|  {     |Move the current pane left|
|  {     |Move the current pane right|
| h,j,k,l |Switch to pane to the direction|
|  q |Show pane numbers|
|  0 … 9 |Switch/select pane by number|
|  z |Toggle pane zoom|
|  !  |Convert pane into a window|
| m ou M | convertis une fenêtre en pane |
| Ctrl + (↑ ↓) |Resize current pane height (after Prefix, hold down the Ctrl key while tapping the up or down key)|
| Ctrl + (← →) |Resize current pane width (after Prefix, hold down the Ctrl key while tapping the right or left key)|
| x | Close current pane|
| Spacebar |Toggle between pane layouts|
| o | Switch to next pane|
| z | zoom sur le panneaux en cours|


# Séquences reconnues par le terminal — tableau de référence

> **Portée.** Ce document recense les séquences **standard et largement implémentées** : les contrôles C0/C1, les séquences d'échappement VT100/VT220/VT510 et les extensions xterm d'usage courant. Il n'est pas — et aucun tableau ne peut l'être — une énumération de *toutes* les séquences existantes (chaque émulateur ajoute ses variantes et ses modes privés). Pour l'exhaustivité formelle, les sources faisant autorité sont : la norme **ECMA-48** (5ᵉ édition), les manuels **DEC VT100 / VT220 / VT510**, et le document **« XTerm Control Sequences »** de Thomas Dickey.

**Notation.** `ESC` = octet `1B`. `CSI` = `ESC [` (octets `1B 5B`). `ST` (terminateur de chaîne) = `ESC \` (`1B 5C`), souvent remplaçable par `BEL` (`07`). `Ps` = un paramètre numérique ; `Pm` = plusieurs paramètres séparés par `;`. Les valeurs par défaut sont indiquées quand elles comptent.

---

## 1. Caractères de contrôle C0 (`00`–`1F`, plus `7F`)

Ceux que le terminal exécute immédiatement, sans former de séquence.

| Octet | Sigle | Effet |
|------|------|------|
| `05` | ENQ | Réponse (*answerback*) — renvoie une chaîne configurée |
| `07` | BEL | Sonnerie (bip ou flash visuel) |
| `08` | BS | Recul du curseur d'une colonne |
| `09` | HT | Tabulation horizontale (taquet suivant) |
| `0A` | LF | Saut de ligne (interligne vertical) |
| `0B` | VT | Tabulation verticale (traitée comme LF) |
| `0C` | FF | Saut de page (traité comme LF) |
| `0D` | CR | Retour chariot (colonne 1) |
| `0E` | SO | *Locking shift* vers G1 (LS1) |
| `0F` | SI | *Locking shift* vers G0 (LS0) |
| `11` | DC1 | XON — reprise du flux |
| `13` | DC3 | XOFF — suspension du flux |
| `18` | CAN | **Annule** la séquence en cours → Sol |
| `1A` | SUB | **Annule** la séquence en cours (affiche parfois un glyphe de substitution) → Sol |
| `1B` | ESC | Débute une séquence d'échappement |
| `7F` | DEL | Ignoré (historiquement : effacement de ruban) |

---

## 2. Fonctions C1 et leurs équivalents ESC 7 bits

Les fonctions C1 s'écrivent soit en un octet `80`–`9F` (rare en environnement UTF-8), soit, forme dominante, en `ESC` + un octet `40`–`5F`.

| Forme 7 bits | C1 | Sigle | Effet |
|------|------|------|------|
| `ESC D` | `84` | IND | Descend d'une ligne (défile si en bas) |
| `ESC E` | `85` | NEL | Nouvelle ligne (CR + LF) |
| `ESC H` | `88` | HTS | Pose un taquet de tabulation à la colonne courante |
| `ESC M` | `8D` | RI | Monte d'une ligne (défile si en haut) |
| `ESC N` | `8E` | SS2 | *Single shift* G2 (un seul caractère) |
| `ESC O` | `8F` | SS3 | *Single shift* G3 (un seul caractère) |
| `ESC P` | `90` | DCS | Début de chaîne de commande d'appareil (voir §11) |
| `ESC [` | `9B` | CSI | Introducteur de séquence de contrôle (voir §5–9) |
| `ESC \` | `9C` | ST | Terminateur de chaîne |
| `ESC ]` | `9D` | OSC | Début de chaîne système (voir §10) |
| `ESC X` | `98` | SOS | Début de chaîne (opaque) |
| `ESC ^` | `9E` | PM | Message de confidentialité (opaque) |
| `ESC _` | `9F` | APC | Commande de programme applicatif (opaque) |

---

## 3. Séquences ESC simples (hors CSI)

| Séquence | Sigle | Effet |
|------|------|------|
| `ESC 7` | DECSC | Sauvegarde curseur + attributs |
| `ESC 8` | DECRC | Restaure curseur + attributs |
| `ESC =` | DECKPAM | Pavé numérique en mode application |
| `ESC >` | DECKPNM | Pavé numérique en mode normal |
| `ESC c` | RIS | Réinitialisation matérielle complète |
| `ESC n` / `ESC o` | LS2 / LS3 | *Locking shift* vers G2 / G3 |
| `ESC #8` | DECALN | Mire d'alignement (remplit l'écran de « E ») |
| `ESC %@` | — | Sélectionne le jeu par défaut (ISO 8859-1) |
| `ESC %G` | — | Sélectionne **UTF-8** |

---

## 4. Désignation des jeux de caractères

`ESC ( C` désigne G0, `ESC ) C` désigne G1, `ESC * C` désigne G2, `ESC + C` désigne G3, où `C` est le jeu :

| `C` | Jeu désigné |
|------|------|
| `B` | US-ASCII |
| `A` | ISO britannique |
| `0` | **Semi-graphique DEC** (tracé de filets : `qxlk`… deviennent `─│┌┐`…) |
| `1` / `2` | Jeu alternatif / semi-graphique (VT100) |

Exemple classique : `ESC ( 0` active le tracé de filets, `ESC ( B` revient à l'ASCII.

---

## 5. CSI — déplacement du curseur et édition

| Séquence | Sigle | Effet (défaut de `Ps` = 1) |
|------|------|------|
| `CSI Ps A` | CUU | Curseur haut de `Ps` lignes |
| `CSI Ps B` | CUD | Curseur bas |
| `CSI Ps C` | CUF | Curseur droite |
| `CSI Ps D` | CUB | Curseur gauche |
| `CSI Ps E` | CNL | Début de la `Ps`ᵉ ligne suivante |
| `CSI Ps F` | CPL | Début de la `Ps`ᵉ ligne précédente |
| `CSI Ps G` | CHA | Colonne absolue `Ps` |
| `CSI Ps ; Ps H` | CUP | Position ligne ; colonne (défaut 1;1) |
| `CSI Ps ; Ps f` | HVP | Idem CUP |
| `CSI Ps I` | CHT | `Ps` tabulations avant |
| `CSI Ps Z` | CBT | `Ps` tabulations arrière |
| `CSI Ps d` | VPA | Ligne absolue `Ps` |
| `CSI Ps \`` | HPA | Colonne absolue `Ps` |
| `CSI Ps @` | ICH | Insère `Ps` blancs |
| `CSI Ps P` | DCH | Supprime `Ps` caractères |
| `CSI Ps X` | ECH | Efface `Ps` caractères (sans décaler) |
| `CSI Ps L` | IL | Insère `Ps` lignes |
| `CSI Ps M` | DL | Supprime `Ps` lignes |
| `CSI Ps b` | REP | Répète le dernier glyphe `Ps` fois |
| `CSI s` / `CSI u` | SCP / RCP | Sauve / restaure la position (SCO) |

---

## 6. CSI — effacement, défilement, marges, tabulations

| Séquence | Sigle | Effet |
|------|------|------|
| `CSI Ps J` | ED | Efface : `0` curseur→fin, `1` début→curseur, `2` tout l'écran, `3` + historique (xterm) |
| `CSI Ps K` | EL | Efface la ligne : `0` →fin, `1` début→, `2` toute |
| `CSI Ps S` | SU | Défile vers le haut de `Ps` lignes |
| `CSI Ps T` | SD | Défile vers le bas de `Ps` lignes |
| `CSI Ps ; Ps r` | DECSTBM | Définit la région de défilement (haut ; bas) |
| `CSI Ps g` | TBC | Efface taquets : `0` courant, `3` tous |
| `CSI Ps ; Ps ; … t` | — | Manipulation de fenêtre xterm (déplacer, redimensionner, titre…) |

---

## 7. Rendu graphique — SGR (`CSI Pm m`)

Les paramètres se cumulent, séparés par `;`. `CSI m` seul équivaut à `CSI 0 m`.

| `Ps` | Effet | | `Ps` | Effet |
|------|------|---|------|------|
| `0` | Réinitialise tous les attributs | | `27` | Désactive l'inversion |
| `1` | Gras / intense | | `28` | Révèle (annule masqué) |
| `2` | Atténué | | `29` | Désactive le barré |
| `3` | Italique | | `30`–`37` | Couleur de texte (8 couleurs) |
| `4` | Souligné | | `38;5;n` | Texte : palette 256 couleurs |
| `5` | Clignotant | | `38;2;r;g;b` | Texte : couleur RVB (24 bits) |
| `7` | Inversé (vidéo inverse) | | `39` | Couleur de texte par défaut |
| `8` | Masqué | | `40`–`47` | Couleur de fond (8 couleurs) |
| `9` | Barré | | `48;5;n` / `48;2;r;g;b` | Fond : 256 / RVB |
| `21` | Double souligné (ou annule gras) | | `49` | Couleur de fond par défaut |
| `22` | Annule gras + atténué | | `53` | Ligne supérieure (*overline*) |
| `23` | Annule italique | | `90`–`97` | Texte : 8 couleurs vives |
| `24` | Annule souligné | | `100`–`107` | Fond : 8 couleurs vives |
| `25` | Annule clignotant | | | |

---

## 8. Modes — SM / RM (ANSI) et DECSET / DECRST (privés `?`)

`CSI Pm h` **active** un mode, `CSI Pm l` le **désactive**. Les modes DEC privés s'écrivent avec un `?` : `CSI ? Pm h` / `CSI ? Pm l`.

### Modes ANSI (sans `?`)

| `Ps` | Sigle | Effet |
|------|------|------|
| `4` | IRM | Mode insertion |
| `20` | LNM | Nouvelle ligne automatique (LF ⇒ CR+LF) |

### Modes privés DEC / xterm (avec `?`) — les plus utiles

| `Ps` | Sigle | `h` active… |
|------|------|------|
| `1` | DECCKM | Touches curseur en mode application (`ESC O A`…) |
| `7` | DECAWM | Retour à la ligne automatique |
| `12` | — | Clignotement du curseur |
| `25` | DECTCEM | Curseur visible |
| `1000` | — | Souris : clic (bouton) |
| `1002` | — | Souris : clic + glisser |
| `1003` | — | Souris : tout mouvement |
| `1006` | — | Souris : encodage SGR (`CSI < … M/m`) |
| `1004` | — | Rapport de focus (`CSI I` / `CSI O`) |
| `1049` | — | Écran alternatif (+ sauvegarde curseur) |
| `47` / `1047` | — | Tampon d'écran alternatif |
| `2004` | — | Collage entre crochets (*bracketed paste*) |

---

## 9. Rapports et requêtes

| Séquence | Sigle | Effet / réponse |
|------|------|------|
| `CSI 5 n` | DSR | État → réponse `CSI 0 n` (OK) |
| `CSI 6 n` | DSR/CPR | Position curseur → réponse `CSI r ; c R` |
| `CSI c` ou `CSI 0 c` | DA | Attributs primaires → `CSI ? … c` |
| `CSI > c` | DA2 | Attributs secondaires (type + version) |
| `CSI Ps SP q` | DECSCUSR | Style curseur : `1/2` bloc, `3/4` souligné, `5/6` barre (impair = clignotant) |
| `CSI ! p` | DECSTR | Réinitialisation logicielle |
| `DCS $ q … ST` | DECRQSS | Demande l'état d'un réglage |

---

## 10. OSC — chaînes système (`ESC ] Ps ; Pt` puis `ST` ou `BEL`)

| `Ps` | Effet |
|------|------|
| `0` | Titre de fenêtre **et** d'icône |
| `1` | Titre d'icône |
| `2` | Titre de fenêtre |
| `4 ; n ; couleur` | Redéfinit la couleur `n` de la palette |
| `8 ; params ; URI` | Hyperlien (encadre le texte cliquable) |
| `10` / `11` / `12` | Couleur du texte / du fond / du curseur (ou requête avec `?`) |
| `52` | Accès au presse-papiers (copier/coller) |
| `104` / `110` / `111` / `112` | Réinitialise palette / texte / fond / curseur |

---

## 11. DCS et autres chaînes (`ESC P … ST`)

Chaînes de charge utile plus longue, terminées par `ST`. Contenu opaque à l'automate jusqu'au terminateur.

| Introducteur | Usage typique |
|------|------|
| `DCS q … ST` | **Sixel** (graphisme point par point) |
| `DCS $ q … ST` | DECRQSS (requête de réglage) |
| `DCS | … ST` | DECUDK (touches définies par l'utilisateur) |
| `DCS + q … ST` | Requête de capacités termcap/terminfo (xterm) |
| `SOS` / `PM` / `APC` | Chaînes opaques, ignorées par la plupart des émulateurs |

---

## 12. Séquences d'ENTRÉE — le terminal vers l'application

Rappel de la symétrie : ces mêmes formes CSI circulent **en sens inverse**, comme rapports.

| Séquence reçue | Signification |
|------|------|
| `ESC [ A/B/C/D` | Flèches (mode normal) |
| `ESC O A/B/C/D` | Flèches (mode application, DECCKM) |
| `ESC [ 1~ … 6~` | Origine, Insér., Suppr., Fin, Page préc./suiv. |
| `ESC [ 11~ … 24~` | Touches de fonction F1–F12 |
| `ESC [ < b ; x ; y M/m` | Événement souris (encodage SGR) |
| `ESC [ 200~ … ESC [ 201~` | Début / fin de collage entre crochets |
| `ESC [ I` / `ESC [ O` | Fenêtre : gain / perte de focus |
| `ESC [ r ; c R` | Réponse à `CSI 6 n` (position du curseur) |

---

*Pour aller vers l'exhaustivité formelle : ECMA-48 pour le cadre normatif, les manuels VT pour l'héritage DEC, et « XTerm Control Sequences » pour l'état réel d'un émulateur moderne. Ce qu'un lecteur rencontre au quotidien tient toutefois presque entièrement dans les sections 1, 5, 6, 7 et 8.*

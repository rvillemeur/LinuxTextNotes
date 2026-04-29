# Projet : "La ligne de commande et le terminal sous Linux"
# Document technique écrit en GNU groff avec le package -mom

## Contexte et ambition

Je veux écrire un document technique sur la ligne de commande et le terminal
sous Linux. Le document est destiné à un lecteur technique débutant à
intermédiaire. Il sera écrit entièrement en GNU groff avec le package -mom,
et produit en PDF via :

  groff -mom -Kutf8 -Tpdf main.mom > document.pdf

Le document lui-même est une démonstration de la philosophie Unix : des outils
qui font une chose, qui se composent, et qui durent. Groff en est l'exemple
final et la mise en abyme.

## Structure du document

Le document est organisé en quatre parties :

  Partie 1 — Bash
    - Introduction au shell, rôle de bash
    - Syntaxe : variables, expansions, redirections, pipes
    - Démarrage : .profile, .bashrc, PATH

  Partie 2 — Les outils en ligne de commande
    - Navigation et fichiers  (ls, find, tree, fd…)
    - Manipulation de texte   (grep, sed, awk, cut, sort, uniq…)
    - Réseau                  (curl, ss, ip, dig…)
    - Gestion de paquets      (apt / dnf / pacman)

  Partie 3 — Le terminal
    - Codes ANSI et séquences d'échappement
    - Terminfo / termcap
    - Les TUI : définition et fonctionnement
    - Vim comme étude de cas

  Partie 4 — Les outils historiques
    - Groff : typographie en ligne de commande
    - La philosophie Unix : pipe de préprocesseurs, séparation contenu/rendu
    - Groff comme archétype : pic, tbl, eqn, groff

## Structure des fichiers source

Crée l'arborescence suivante :

  document.pdf                    ← sortie compilée (ne pas versionner)
  Makefile                        ← cible par défaut : PDF, cible watch
  .gitignore                      ← ignorer document.pdf et groff.log
  main.mom                        ← fichier maître
  style.mom                       ← définitions de style et macros

  chapitres/
    00-avant-propos/
      index.mom                   ← source du chapitre
      assets/                     ← images et illustrations du chapitre
        .gitkeep
    01-bash/
      index.mom
      assets/
        .gitkeep
    02-outils/
      index.mom
      assets/
        .gitkeep
    03-terminal/
      index.mom
      assets/
        .gitkeep
    04-groff/
      index.mom
      assets/
        .gitkeep

## Inclusion des chapitres

Groff ne résout pas les chemins relatifs au fichier source lors des
appels .so — il les résout depuis le répertoire de travail courant.
Le Makefile doit donc toujours invoquer groff depuis la racine du projet.
Les inclusions dans main.mom utilisent des chemins relatifs à cette racine :

  .so chapitres/00-avant-propos/index.mom
  .so chapitres/01-bash/index.mom
  ...

## Inclusion des assets

Chaque image doit être en format EPS ou PDF (seuls formats supportés
nativement par groff -mom pour l'inclusion dans un PDF de sortie).

Définir dans style.mom une macro d'inclusion d'image :

  .ILLUSTRATION chemin legende largeur

    chemin   : chemin relatif à la racine du projet
                ex : chapitres/01-bash/assets/pipeline.pdf
    legende  : texte de légende affiché sous l'image (peut être vide "")
    largeur  : largeur souhaitée exprimée en mm (ex : 120)

  Comportement attendu :
    - L'image est centrée
    - La légende est centrée sous l'image, en italique 9pt
    - Un espace de 8pt est ajouté avant et après le bloc
    - Si le chemin ne pointe vers aucun fichier, groff émet un
      avertissement via .tm mais ne plante pas

Dans chaque chapitre, inclure un appel .ILLUSTRATION commenté en exemple
(pointant vers un fichier assets/exemple.pdf fictif) pour montrer la
syntaxe à utiliser.

## Ce que je veux dans style.mom

### Mise en page générale
- Format A4, marges de 30mm (haut/bas) et 25mm (gauche/droite)
- Police principale : Libertinus ou Linux Libertine si disponible,
  sinon Times
- Taille de corps : 11pt, interligne 15pt
- En-tête : titre du chapitre courant (côté extérieur), numéro de page
  (côté intérieur)
- Pied de page : titre du document centré

### Hiérarchie des titres
- HEADING niveau 1 : nouveau chapitre, débute sur nouvelle page, 18pt
  gras, espace avant 0, espace après 18pt
- HEADING niveau 2 : 14pt gras, espace avant 18pt, espace après 10pt
- HEADING niveau 3 : 11pt gras italique, espace avant 12pt, espace
  après 6pt

### Éléments répétitifs — macros personnalisées à définir

  .CMD texte          ← commande inline dans le texte courant
                        rendu : fonte monospace, fond gris léger si
                        possible, sinon monospace gras

  .BLOC_CODE          ← début d'un bloc de code multi-lignes
  ...contenu...
  .BLOC_CODE END      ← fin du bloc
                        rendu : retrait gauche de 8mm, police monospace
                        9pt, pas de remplissage (.nf), espace avant/après
                        de 6pt, filet gauche vertical si faisable

  .NOTE               ← début d'une note ou aparté
  ...contenu...
  .NOTE END           ← fin
                        rendu : retrait gauche et droit de 12mm,
                        italique, espace avant/après 8pt, filet gauche

  .TERM terme         ← introduit un terme technique pour la première
                        fois — rendu : gras italique

  .TOUCHE touche      ← touche clavier (ex : .TOUCHE Ctrl-C)
                        rendu : crochets + monospace

  .ILLUSTRATION c l w ← voir section "Inclusion des assets" ci-dessus

### Table des matières
- Générée automatiquement par -mom
- Placée au début du document après la page de titre
- Profondeur : niveaux 1 et 2 uniquement

### Page de titre
- Titre : "La ligne de commande et le terminal sous Linux"
- Sous-titre : "Un tour d'horizon des outils Unix"
- Auteur
- Date générée automatiquement

## Ce que je veux dans main.mom

Le fichier maître doit :
1. Inclure style.mom
2. Déclarer la page de titre
3. Générer la table des matières
4. Inclure chaque chapitre avec .so chapitres/XX-nom/index.mom
5. Appeler .TC en fin de document

## Ce que je veux dans chaque index.mom de chapitre

Chaque fichier est autonome pour le contenu mais hérite du style de
style.mom. Il doit contenir :
- Un .HEADING 1 "Titre du chapitre"
- Quelques paragraphes d'exemple représentatifs du chapitre
- Au moins un .BLOC_CODE avec un exemple shell réaliste
- Au moins une utilisation de .CMD inline
- Au moins un .HEADING 2 et un .HEADING 3
- Un appel .ILLUSTRATION commenté montrant la syntaxe avec un asset
  fictif dans le sous-répertoire assets/ du chapitre

Le contenu est un squelette — je l'écrirai moi-même. Il doit être
suffisamment représentatif pour valider le rendu de chaque élément.

## Ce que je veux dans le Makefile

  PDF     = document.pdf
  SOURCE  = main.mom style.mom \
            $(wildcard chapitres/*/index.mom)
  ASSETS  = $(wildcard chapitres/*/assets/*)

  all: $(PDF)

  $(PDF): $(SOURCE) $(ASSETS)
  	groff -mom -Kutf8 -Tpdf main.mom > $(PDF) 2>groff.log
  	@if [ -s groff.log ]; then \
  	  echo "=== Avertissements groff ===" ; cat groff.log ; fi

  watch:
  	while inotifywait -e modify $(SOURCE); do make; done

  clean:
  	rm -f $(PDF) groff.log

  .PHONY: all watch clean

## Langue et typographie française

Le document est entièrement rédigé en français. Les points suivants
doivent être configurés dans style.mom et dans le Makefile.

CÉSURE
  Activer les règles de césure françaises via .hla fr et .hpf fr.
  Vérifier que le paquet hyphen-fr est disponible sur le système avec :
    fc-list | grep -i libert
  Si absent, émettre un avertissement via .tm dans style.mom et
  continuer sans césure plutôt que de planter :
    .sy dpkg -l hyphen-fr 2>/dev/null | grep -q "^ii" \
      || tm style.mom: avertissement : hyphen-fr absent, césure désactivée

GUILLEMETS
  Activer .SMARTQUOTES FR pour obtenir les guillemets français
  « » automatiquement à partir des guillemets droits dans la source.

ENCODAGE
  Tous les fichiers source sont en UTF-8.
  La commande groff dans le Makefile inclut -Kutf8.

ESPACES INSÉCABLES
  En typographie française, une espace insécable précède : ; ! ? »
  et suit «. Documenter dans un commentaire en tête de style.mom
  l'escape à utiliser dans la source :
    \~ pour une espace insécable cadratin
    \  (backslash-espace) pour une espace insécable fine
  Exemple : mot\~; suite    →    mot ; suite

ÉLÉMENTS AUTO-GÉNÉRÉS
  Les chaînes générées automatiquement par -mom doivent être
  redéfinies en français dans style.mom. Inventorier et redéfinir
  au minimum :
    Table des matières  (par défaut "Table of Contents")
    En-tête de notes    (si applicable)
    Tout label généré automatiquement visible dans le PDF final
  Utiliser les mécanismes de redéfinition de chaînes de -mom
  (typiquement .STRINGREPLACE ou .ds selon la version).
  Documenter dans un commentaire chaque redéfinition effectuée
  et sa valeur originale anglaise.

## Contraintes techniques

- Compiler après chaque fichier créé. Si groff.log contient des
  avertissements, les corriger avant de continuer.
- Ne pas utiliser de fonctionnalités -mom non documentées ou
  expérimentales.
- Tous les chemins sont relatifs à la racine du projet.
- Le PDF final doit avoir les métadonnées correctes (titre, auteur,
  langue : fr) via les directives PDF de -mom.
- Si une fonctionnalité demandée n'est pas faisable proprement en -mom
  sans hacks fragiles, proposer l'alternative la plus proche et la
  documenter dans un commentaire dans style.mom.
- Les fichiers assets/ vides sont versionnables via un .gitkeep.
- Le .gitignore doit ignorer document.pdf et groff.log et versionner
  tout le reste.

## Ordre de travail demandé

1. Créer .gitignore et le Makefile
2. Créer style.mom — compiler un fichier de test minimal pour valider
   la mise en page, les polices, la césure française et les guillemets
3. Créer main.mom — compiler, vérifier la page de titre et la TOC
   en français
4. Créer chapitres/00-avant-propos/index.mom et son assets/ — compiler,
   vérifier que tous les éléments personnalisés (CMD, BLOC_CODE, NOTE,
   TERM, TOUCHE, ILLUSTRATION) s'affichent correctement
5. Créer les chapitres 01 à 04 dans l'ordre — compiler après chacun
6. Compilation finale — vérifier groff.log, corriger les avertissements,
   confirmer que les métadonnées PDF sont correctes, que la TOC est en
   français, et que les chemins d'assets sont correctement résolus

À chaque étape, afficher la commande de compilation utilisée et signaler
tout compromis fait par rapport aux spécifications ci-dessus.

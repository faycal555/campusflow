# Séance 2 — Design system v1

Page de référence, traduite en `ThemeData` Flutter en séance 4
(`campusflow_app/lib/theme/`). Base : Material 3.

## Couleurs

| Rôle | Nom Flutter | Valeur | Usage |
|------|-------------|--------|-------|
| Primaire | `primary` | `#1D4ED8` | Boutons principaux, éléments actifs |
| Sur primaire | `onPrimary` | `#FFFFFF` | Texte sur bouton primaire |
| Conteneur secondaire | `secondaryContainer` | `#DBEAFE` | Filtre sélectionné, indicateur de navigation |
| Sur conteneur secondaire | `onSecondaryContainer` | `#1E3A8A` | Texte du filtre sélectionné |
| Surface | `surface` | `#FFFFFF` | Fond des cartes et des écrans |
| Fond gris | `surfaceContainer` | `#F3F4F6` | Champs de saisie, zones secondaires |
| Texte principal | `onSurface` | `#1F2937` | Titres, texte courant |
| Texte secondaire | `onSurfaceVariant` | `#4B5563` | Sous-titres, libellés |
| Erreur / En retard | `error` | `#B91C1C` | Tâche en retard, erreurs de formulaire |
| Succès / Fait | extension `success` | `#15803D` | Tâche terminée |

### Contraste du texte (exigence : ≥ 4,5:1, WCAG AA)

Calculé avec la formule de luminance relative du WCAG 2.1.

| Combinaison | Ratio | Conforme |
|-------------|-------|----------|
| `#FFFFFF` sur `#1D4ED8` (texte de bouton) | 6,70:1 | ✅ |
| `#1D4ED8` sur `#FFFFFF` (lien, icône active) | 6,70:1 | ✅ |
| `#1F2937` sur `#FFFFFF` (texte principal) | 14,68:1 | ✅ |
| `#4B5563` sur `#FFFFFF` (texte secondaire) | 7,56:1 | ✅ |
| `#1F2937` sur `#F3F4F6` (texte dans un champ) | 13,34:1 | ✅ |
| `#4B5563` sur `#F3F4F6` (indice dans un champ) | 6,87:1 | ✅ |
| `#B91C1C` sur `#FFFFFF` (« En retard ») | 6,47:1 | ✅ |
| `#15803D` sur `#FFFFFF` (« Faite ») | 5,02:1 | ✅ |
| `#1E3A8A` sur `#DBEAFE` (filtre sélectionné) | 8,49:1 | ✅ |
| `#FFFFFF` sur `#1F2937` (SnackBar) | 14,68:1 | ✅ |

L'état « en retard » n'est jamais signalé par la couleur seule : il est aussi
écrit en toutes lettres (accessibilité daltonisme).

## Typographie

Police **Roboto**, police système d'Android : aucun téléchargement, donc pas de
données consommées ni de poids ajouté à l'application.

| Style Material | Taille | Graisse | Usage |
|----------------|--------|---------|-------|
| `headlineSmall` | 24 sp | 700 | Titre d'écran de connexion |
| `titleLarge` | 20 sp | 700 | Titre de l'AppBar |
| `titleMedium` | 16 sp | 600 | Titre d'une tâche |
| `bodyLarge` | 16 sp | 400 | Texte courant, champs |
| `bodyMedium` | 14 sp | 400 | Sous-titres (cours, date) |
| `labelLarge` | 14 sp | 600 | Texte des boutons |

## Trois composants

### 1. Bouton principal (`FilledButton`)
- Hauteur 52 dp, coins arrondis 26 dp (pilule), largeur pleine sur téléphone.
- Fond `primary`, texte `onPrimary` en `labelLarge`.
- Un seul bouton principal par écran (« Se connecter », « Enregistrer », « Marquer comme fait »).

### 2. Carte de tâche (`ListTile` dans la liste)
- Hauteur minimale 60 dp (zone tactile ≥ 48 dp).
- À gauche : case à cocher ronde ; au centre : titre (`titleMedium`) et sous-titre « cours · date » (`bodyMedium`, `onSurfaceVariant`) ; à droite : chevron.
- Tâche en retard : sous-titre en `error` + libellé « En retard ». Tâche faite : titre barré + couleur `success`.

### 3. Champ de saisie (`TextFormField`)
- Style rempli : fond `surfaceContainer`, coins 12 dp, sans bordure au repos, bordure `primary` de 2 dp au focus.
- Libellé au-dessus, message d'erreur en `error` sous le champ (« Le titre est obligatoire »).

## Espacements et formes

- Grille de 4 dp ; marges d'écran de 16 dp ; espacement entre éléments de 8 / 16 / 24 dp.
- Coins arrondis : 12 dp (cartes, champs), 26 dp (boutons), 16 dp (bouton flottant).

## Tailles de fenêtre visées

| Classe Material | Largeur | Appareil cible | Mise en page |
|-----------------|---------|----------------|--------------|
| Compacte | < 600 dp | Téléphone (référence : 360 dp) | Une colonne, `NavigationBar` en bas |
| Moyenne | 600–839 dp | Petite tablette, téléphone en paysage | Une colonne élargie |
| Étendue | ≥ 840 dp | Tablette | Liste et détail côte à côte |

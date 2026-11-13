# CampusFlow

Application mobile de suivi des cours, échéances et tâches d'un étudiant,
construite séance par séance (7 séances, 27 TP) : de la décision de plateforme
jusqu'à une application Flutter connectée à une API avec authentification.

- **Cours :** Programmation Mobile — Master 1 MSI & IA-FPC, Université Aube Nouvelle (2026-2027)
- **Enseignant :** M. COMPAORÉ Moctar
- **Réalisé par :** SAVADOGO Pengdwende Fayçal

L'historique Git suit la progression : **un commit par TP** (`git log --reverse`).

## Comment tester

**Compte de démonstration :** `aminata@campus.bf` / `campus2026`

- **Rapide (sans serveur) :** installer `campusflow-demo.apk` depuis la page
  [Releases](../../releases) sur un téléphone Android. Ce mode démo utilise des
  données en mémoire (`FakeTaskRepository`) : tous les écrans sont testables,
  les données reviennent à l'état initial au redémarrage.
- **Complet (avec l'API, séance 7) :** lancer le serveur puis l'application,
  voir [Lancer le projet](#lancer-le-projet).

## Auto-vérification (section IV du sujet)

| Séance | Trace attendue | Où la trouver |
|--------|----------------|---------------|
| 1 | Fiche comparative, autopsie sourcée, paragraphe de décision | [docs/seance1/](docs/seance1/) |
| 2 | Persona, parcours, 5 wireframes (3 variantes d'un écran), design system v1 | [docs/seance2/](docs/seance2/) |
| 3 | Package `campusflow_models` : Task, Course, User, `fromJson`, 3 tests qui passent | [campusflow_models/](campusflow_models/) |
| 4 | `flutter doctor`, application sur l'émulateur, thème centralisé, asset affiché, ≥ 3 commits | [docs/seance4/](docs/seance4/), [lib/theme/](campusflow_app/lib/theme/app_theme.dart) |
| 5 | Écrans Échéances, Détail, Formulaire, version tablette à 840 dp | [docs/seance5/](docs/seance5/), [lib/screens/](campusflow_app/lib/screens/) |
| 6 | Navigation par adresses, état partagé entre les trois écrans, trois filtres | [docs/seance6/](docs/seance6/), [lib/router/](campusflow_app/lib/router/app_router.dart), [lib/state/](campusflow_app/lib/state/) |
| 7 | API json-server, couches Repository, liste connectée (POST, PATCH, DELETE), connexion avec jeton sécurisé | [docs/seance7/](docs/seance7/), [campusflow_api/](campusflow_api/), [lib/data/](campusflow_app/lib/data/) |

## Structure du dépôt

```
docs/               livrables de conception et captures, une page par séance
campusflow_models/  séance 3 — package Dart pur (modèles + tests)
campusflow_app/     séances 4 à 7 — application Flutter
campusflow_api/     séance 7 — serveur json-server avec authentification simulée
```

## Lancer le projet

Prérequis : Flutter 3.38+, Node.js 18+, un émulateur Android (ou un téléphone).

```bash
# 1. Serveur (terminal 1)
cd campusflow_api
npm install
npm start                      # http://localhost:3000

# 2. Application (terminal 2)
cd campusflow_app
flutter pub get
flutter run                    # émulateur Android : l'API est jointe via 10.0.2.2
```

**Compte de démonstration :** `aminata@campus.bf` / `campus2026`

Sur un vrai téléphone (même Wi-Fi que le PC) :
`flutter run --dart-define=API_URL=http://<IP-du-PC>:3000`

## Tests

```bash
cd campusflow_models && dart test     # 3 tests (séance 3)
cd campusflow_app && flutter test     # 16 tests : widgets, routes, état, filtres, CRUD, connexion
```

## Choix techniques

| Besoin | Choix |
|--------|-------|
| Plateforme | Flutter (cross-platform), Android en priorité — voir la [décision](docs/seance1/03-decision-campusflow.md) |
| État | Riverpod 3 (`Notifier`, `AsyncNotifier`, fournisseurs dérivés) |
| Navigation | go_router (`ShellRoute`, paramètre `:id`, redirection sur l'authentification) |
| Réseau | Dio + intercepteur (jeton, gestion du 401) |
| Jeton | flutter_secure_storage (Keystore / Keychain) |
| Données de test | `FakeTaskRepository` injecté via `ProviderScope(overrides: …)` |

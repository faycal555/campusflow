# Séance 1 — Fiche comparative Android / iOS

**Cas étudié :** une application étudiante (CampusFlow) destinée aux étudiants
d'Afrique francophone (Burkina Faso, Côte d'Ivoire, Sénégal, Mali…).

**Repère chiffré.** En octobre 2026, Android représente **83 %** des
smartphones en Afrique contre **17 %** pour iOS, alors qu'en France le partage est
d'environ 64 % / 36 % (source : StatCounter,
<https://gs.statcounter.com/os-market-share/mobile/africa> et
<https://gs.statcounter.com/os-market-share/mobile/france>, consultés le 13/11/2026).
Ce seul écart justifie de ne pas reprendre tel quel un raisonnement « européen ».

| # | Critère | Android | iOS | Ce qui change pour une app étudiante en Afrique francophone |
|---|---------|---------|-----|-------------------------------------------------------------|
| 1 | **Philosophie** | Système ouvert (AOSP), personnalisable par chaque constructeur. | Système fermé, Apple contrôle matériel et logiciel. | L'ouverture d'Android a permis des téléphones d'entrée de gamme (Tecno, Itel, Infinix, Samsung série A) : c'est le téléphone réel des étudiants. |
| 2 | **Architecture** | Noyau Linux, ART (Android Runtime), couche constructeur au-dessus. | Noyau XNU (Darwin), frameworks Apple (UIKit / SwiftUI). | Sur Android, la surcouche constructeur ajoute de la RAM consommée : l'app doit rester légère pour des appareils de 2 à 4 Go. |
| 3 | **Langage** | Kotlin (recommandé), Java. | Swift, Objective-C. | Deux langages = deux équipes. Pour un petit projet étudiant, un code unique (Dart/Flutter) est plus réaliste. |
| 4 | **Cycle de vie** | Activités/fragments, le système peut tuer l'app en arrière-plan pour libérer la mémoire. | Scènes/vues, suspension stricte en arrière-plan. | Avec peu de RAM, Android tue souvent les apps : il faut sauvegarder l'état (formulaire en cours) et le restaurer. |
| 5 | **Permissions** | Demandées à l'exécution (depuis Android 6), regroupées par catégories. | Demandées à l'exécution avec un texte d'explication obligatoire. | Demander le minimum (notifications seulement) : les utilisateurs se méfient des apps qui demandent contacts ou localisation. |
| 6 | **Stockage** | Stockage interne + carte SD sur beaucoup de modèles. | Stockage interne uniquement, pas d'extension. | Les téléphones d'entrée de gamme ont 32 à 64 Go souvent pleins (photos, WhatsApp) : viser un APK léger et peu de cache. |
| 7 | **Distribution** | Google Play, mais aussi installation directe d'APK et boutiques tierces. | App Store uniquement (sauf exceptions réglementaires UE). | Les APK circulent beaucoup par partage (Bluetooth, WhatsApp, apps de partage) : Android permet de distribuer l'app sur le campus même sans Play Store. |
| 8 | **Fragmentation** | Très forte : milliers de modèles, tailles d'écran et versions. | Faible : quelques modèles, versions homogènes. | Tester sur un petit écran (≈ 360 dp de large) et une vieille version d'Android est prioritaire. |
| 9 | **Mises à jour** | Dépendent du constructeur ; beaucoup d'appareils restent sur d'anciennes versions. | Diffusées par Apple à tous les appareils compatibles, adoption rapide. | Fixer un `minSdk` assez bas pour couvrir les téléphones anciens encore très utilisés. |
| 10 | **Contraintes de développement** | Développement possible sur Windows, Linux ou macOS ; inscription Play Console à 25 $ (paiement unique). | Mac obligatoire pour compiler (Xcode) ; Apple Developer Program à 99 $/an. | Les étudiants et l'université ont surtout des PC Windows : Android est développable tout de suite, iOS demande un Mac. |
| 11 | **Interface (guidelines)** | Material Design 3. | Human Interface Guidelines. | Les utilisateurs sont habitués aux codes Android (bouton retour, barre de navigation en bas) : Material 3 est le choix naturel. |
| 12 | **Coût des appareils** | Du très bas de gamme au haut de gamme. | Uniquement moyen/haut de gamme. | Le prix d'un iPhone dépasse plusieurs mois de budget étudiant : la majorité de la cible est sur Android. |
| 13 | **Connectivité / données** | Mode économie de données intégré, gestion fine du réseau. | Mode données réduites. | Internet mobile coûteux et parfois instable : l'app doit fonctionner hors ligne et consommer peu de données. |
| 14 | **Monétisation / paiement** | Achats intégrés via Google Play (carte bancaire, parfois facturation opérateur). | Achats intégrés via l'App Store. | Peu d'étudiants ont une carte bancaire ; le paiement passe par le mobile money (Orange Money, Moov Money, Wave) : CampusFlow reste gratuite. |

## Ce que retient la fiche

- La cible est **majoritairement sur Android**, souvent sur des appareils d'entrée de gamme.
- Les contraintes fortes sont la **mémoire**, le **stockage**, le **coût des données** et la **diversité des écrans**.
- iOS reste présent (environ 1 étudiant sur 6) : il ne faut pas l'exclure si le coût est faible.

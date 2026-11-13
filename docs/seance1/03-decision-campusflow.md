# Séance 1 — Décision pour CampusFlow

**Cible :** les étudiants des universités d'Afrique francophone, en premier lieu
ceux de l'Université Aube Nouvelle (Ouagadougou), équipés le plus souvent d'un
smartphone Android d'entrée ou de milieu de gamme (2 à 4 Go de RAM, écran
d'environ 6 pouces, stockage souvent saturé) et d'un forfait de données limité.

**Plateformes :** Android en priorité, car il équipe 83 % des smartphones en
Afrique (StatCounter, octobre 2026) et c'est la seule plateforme que nous pouvons
compiler, tester et distribuer (Play Store ou APK partagé sur le campus) avec nos
PC Windows. iOS est visé dans un second temps : il représente encore environ un
étudiant sur six, et l'exclure créerait un « trou » dans les groupes de travail.
Une version tablette (écran ≥ 840 dp) est prévue pour la consultation en
bibliothèque.

**Approche : cross-platform avec Flutter.** Un code unique en Dart couvre Android
et iOS sans doubler l'équipe ni l'effort, ce qui est décisif pour un projet
étudiant. Flutter compile en code natif, ce qui reste fluide sur les appareils
modestes, et son interface Material 3 correspond aux habitudes des utilisateurs
Android. L'autopsie de Windows Phone nous rappelle qu'une application doit être là
où sont déjà les utilisateurs : nous partons donc d'Android, sans nous enfermer
dans un seul système. Enfin, les contraintes du terrain (données chères, réseau
instable, peu de mémoire) imposent une application légère, avec une interface
sobre et des données mises en cache, principes qui guideront la conception
(séance 2) et l'architecture (séance 7).

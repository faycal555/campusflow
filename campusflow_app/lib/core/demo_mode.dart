import 'package:flutter_riverpod/misc.dart';

import '../data/auth_repository.dart';
import '../data/fake_repositories.dart';
import '../data/repository_providers.dart';

/// Mode démo : l'application fonctionne sans serveur, avec des données en mémoire.
///
/// `flutter build apk --dart-define=DEMO=true`
const demoMode = bool.fromEnvironment('DEMO');

/// Remplace les repositories réseau par leurs versions en mémoire.
List<Override> get demoOverrides => [
  authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
  taskRepositoryProvider.overrideWithValue(
    FakeTaskRepository(latency: const Duration(milliseconds: 400)),
  ),
  courseRepositoryProvider.overrideWithValue(FakeCourseRepository()),
];

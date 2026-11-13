import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repository_providers.dart';

/// État partagé et asynchrone : la liste des tâches chargée depuis l'API.
///
/// L'écran affiche trois états : chargement, erreur (avec « Réessayer ») et
/// données. L'état reste immuable : on assigne toujours une nouvelle liste.
class TachesNotifier extends AsyncNotifier<List<Task>> {
  // Rechargé à chaque connexion / déconnexion (voir AuthNotifier._resetData).
  @override
  Future<List<Task>> build() => ref.watch(taskRepositoryProvider).fetchAll();

  List<Task> get _current => state.value ?? const [];

  /// POST /taches
  Future<void> ajouter(Task task) async {
    final saved = await ref.read(taskRepositoryProvider).create(task);
    state = AsyncData([..._current, saved]);
  }

  /// PATCH /taches/:id
  Future<void> cocher(String id) async {
    final task = _current.firstWhere((t) => t.id == id);
    final updated = await ref
        .read(taskRepositoryProvider)
        .setDone(id, done: !task.isDone);
    state = AsyncData([for (final t in _current) t.id == id ? updated : t]);
  }

  /// DELETE /taches/:id
  Future<void> supprimer(String id) async {
    await ref.read(taskRepositoryProvider).delete(id);
    state = AsyncData(_current.where((t) => t.id != id).toList());
  }
}

// autoDispose : les données de session sont libérées quand plus aucun écran
// ne les affiche (par exemple après une déconnexion).
final tachesProvider =
    AsyncNotifierProvider.autoDispose<TachesNotifier, List<Task>>(
      TachesNotifier.new,
      // Pas de nouvelle tentative automatique : l'utilisateur décide avec « Réessayer ».
      retry: (_, _) => null,
    );

final coursProvider = FutureProvider.autoDispose<List<Course>>(
  (ref) => ref.watch(courseRepositoryProvider).fetchAll(),
  retry: (_, _) => null,
);

/// Une tâche par son identifiant (null si elle n'existe pas ou pas encore chargée).
final tacheProvider = Provider.autoDispose.family<Task?, String>(
  (ref, id) =>
      ref.watch(tachesProvider).value?.where((t) => t.id == id).firstOrNull,
);

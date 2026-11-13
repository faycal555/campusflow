import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_data.dart';

/// État partagé : la liste des tâches, commune à la liste, au détail et au formulaire.
///
/// L'état est immuable : chaque méthode assigne une nouvelle liste à `state`
/// au lieu de modifier l'ancienne.
class TachesNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() => buildSampleTasks();

  void ajouter(Task task) {
    state = [...state, task];
  }

  void cocher(String id) {
    state = [
      for (final t in state) t.id == id ? t.copyWith(isDone: !t.isDone) : t,
    ];
  }
}

final tachesProvider = NotifierProvider<TachesNotifier, List<Task>>(
  TachesNotifier.new,
);

final coursProvider = Provider<List<Course>>((ref) => sampleCourses);

/// Une tâche par son identifiant (null si elle n'existe pas).
final tacheProvider = Provider.family<Task?, String>(
  (ref, id) => ref.watch(tachesProvider).where((t) => t.id == id).firstOrNull,
);

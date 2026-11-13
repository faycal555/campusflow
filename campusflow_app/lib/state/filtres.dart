import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/task_utils.dart';
import 'taches_notifier.dart';

enum Filtre {
  aFaire('À faire'),
  faites('Faites'),
  enRetard('En retard');

  final String label;
  const Filtre(this.label);

  bool accepte(Task task, DateTime now) => switch (this) {
    Filtre.aFaire => !task.isDone,
    Filtre.faites => task.isDone,
    Filtre.enRetard => task.isLate(now),
  };
}

/// Filtre sélectionné sur l'écran des échéances.
class FiltreNotifier extends Notifier<Filtre> {
  @override
  Filtre build() => Filtre.aFaire;

  void choisir(Filtre filtre) => state = filtre;
}

final filtreProvider = NotifierProvider<FiltreNotifier, Filtre>(
  FiltreNotifier.new,
);

/// Fournisseur dérivé : les tâches du filtre courant, triées par date.
///
/// Il conserve les états chargement / erreur de la liste source.
final tachesFiltreesProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final filtre = ref.watch(filtreProvider);
  final now = DateTime.now();
  return ref
      .watch(tachesProvider)
      .whenData(
        (tasks) =>
            tasks.where((t) => filtre.accepte(t, now)).toList()
              ..sort((a, b) => a.dueDate.compareTo(b.dueDate)),
      );
});

/// Nombre de tâches pour chacun des trois filtres.
final compteursProvider = Provider<Map<Filtre, int>>((ref) {
  final tasks = ref.watch(tachesProvider).value ?? const [];
  final now = DateTime.now();
  return {
    for (final f in Filtre.values)
      f: tasks.where((t) => f.accepte(t, now)).length,
  };
});

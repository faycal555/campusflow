import 'package:campusflow_models/campusflow_models.dart';

/// Contrat d'accès aux tâches : les écrans et l'état ne connaissent que lui.
abstract interface class TaskRepository {
  Future<List<Task>> fetchAll();

  /// Crée la tâche et renvoie la version enregistrée (avec son identifiant).
  Future<Task> create(Task task);

  Future<Task> setDone(String id, {required bool done});

  Future<void> delete(String id);
}

/// Contrat d'accès aux cours.
abstract interface class CourseRepository {
  Future<List<Course>> fetchAll();
}

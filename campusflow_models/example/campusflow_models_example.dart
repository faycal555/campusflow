import 'package:campusflow_models/campusflow_models.dart';

Future<void> main() async {
  const repository = CampusFlowRepository();

  print('Chargement des données…');
  final user = await repository.fetchCurrentUser();
  final courses = await repository.fetchCourses();
  final tasks = await repository.fetchTasks();

  print('Utilisateur : $user');
  print('Cours :');
  courses.forEach(print);
  print('Tâches :');
  tasks.forEach(print);

  final done = tasks.first.copyWith(isDone: true);
  print('Après copyWith : $done');

  // Un serveur qui renvoie des données invalides : l'erreur est rattrapée.
  const brokenRepository = CampusFlowRepository(
    rawJson: '{"tasks": [{"id": "t9", "title": "Sans date"}]}',
  );
  try {
    await brokenRepository.fetchTasks();
  } on FormatException catch (e) {
    print('Erreur attendue rattrapée : ${e.message}');
  }
}

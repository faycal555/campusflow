import 'package:campusflow_models/campusflow_models.dart';

/// Données locales utilisées tant que l'application n'a pas d'API.
const sampleCourses = [
  Course(
    id: 'c1',
    name: 'Développement mobile',
    teacher: 'M. Compaoré',
    credits: 4,
  ),
  Course(id: 'c2', name: 'Bases de données', teacher: 'Mme Kaboré', credits: 3),
  Course(id: 'c3', name: 'Cloud computing', teacher: 'M. Sawadogo', credits: 3),
  Course(
    id: 'c4',
    name: 'Optimisation linéaire',
    teacher: 'M. Traoré',
    credits: 4,
  ),
];

const sampleUser = User(
  id: 'u1',
  name: 'Aminata Ouédraogo',
  email: 'aminata@campus.bf',
);

List<Task> buildSampleTasks() {
  final today = DateTime.now();
  DateTime inDays(int days) =>
      DateTime(today.year, today.month, today.day + days, 8);
  return [
    Task(
      id: 't1',
      title: 'TP Flutter — écran détail',
      courseId: 'c1',
      dueDate: inDays(3),
    ),
    Task(
      id: 't2',
      title: 'Rapport de stage (plan)',
      courseId: 'c4',
      dueDate: inDays(-1),
    ),
    Task(id: 't3', title: 'Exercices SQL', courseId: 'c2', dueDate: inDays(5)),
    Task(id: 't4', title: 'Exposé cloud', courseId: 'c3', dueDate: inDays(7)),
    Task(
      id: 't5',
      title: 'Lecture chapitre 2',
      courseId: 'c2',
      dueDate: inDays(-3),
      isDone: true,
    ),
  ];
}

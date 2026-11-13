import 'package:campusflow_models/campusflow_models.dart';
import 'package:intl/intl.dart';

String formatDueDate(DateTime date) =>
    DateFormat('EEE d MMM', 'fr_FR').format(date);

String formatDueDateLong(DateTime date) =>
    DateFormat("EEEE d MMMM y, HH'h'mm", 'fr_FR').format(date);

extension TaskStatus on Task {
  /// Une tâche est en retard si elle n'est pas faite et que sa date est passée.
  bool isLate([DateTime? now]) =>
      !isDone && dueDate.isBefore(now ?? DateTime.now());
}

String courseName(List<Course> courses, String courseId) => courses
    .firstWhere(
      (c) => c.id == courseId,
      orElse: () =>
          Course(id: courseId, name: 'Cours inconnu', teacher: '', credits: 0),
    )
    .name;

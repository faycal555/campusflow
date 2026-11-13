import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/taches_notifier.dart';
import '../utils/task_utils.dart';
import '../widgets/task_detail_view.dart';

/// Écran Détail d'une tâche (route /taches/:id), branché sur l'état partagé.
class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(tacheProvider(taskId));
    final courses = ref.watch(coursProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: task == null
          ? Center(child: Text('Tâche « $taskId » introuvable'))
          : TaskDetailView(
              task: task,
              courseName: courseName(courses, task.courseId),
              onToggleDone: () =>
                  ref.read(tachesProvider.notifier).cocher(task.id),
            ),
    );
  }
}

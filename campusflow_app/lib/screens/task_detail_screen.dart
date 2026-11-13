import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import '../state/taches_notifier.dart';
import '../utils/task_utils.dart';
import '../widgets/async_views.dart';
import '../widgets/task_detail_view.dart';

/// Écran Détail d'une tâche (route /taches/:id), branché sur l'état partagé.
class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  Future<void> _supprimer(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la tâche ?'),
        content: Text('« ${task.title} » sera définitivement supprimée.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final ok = await runAction(
      context,
      () => ref.read(tachesProvider.notifier).supprimer(task.id),
      success: 'Tâche « ${task.title} » supprimée',
    );
    if (ok && context.mounted) context.go(Routes.taches);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tachesProvider);
    final task = ref.watch(tacheProvider(taskId));
    final courses = ref.watch(coursProvider).value ?? const <Course>[];
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: switch ((tasksAsync, task)) {
        (AsyncError(:final error), _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(tachesProvider),
        ),
        (_, final Task task) => TaskDetailView(
          task: task,
          courseName: courseName(courses, task.courseId),
          onToggleDone: () => runAction(
            context,
            () => ref.read(tachesProvider.notifier).cocher(task.id),
          ),
          onDelete: () => _supprimer(context, ref, task),
        ),
        (AsyncLoading(), _) => const LoadingView(),
        _ => Center(child: Text('Tâche « $taskId » introuvable')),
      },
    );
  }
}

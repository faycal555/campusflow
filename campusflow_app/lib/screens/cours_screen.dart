import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/taches_notifier.dart';
import '../theme/app_theme.dart';
import '../widgets/async_views.dart';

/// Écran « Mes cours » (route /cours).
class CoursScreen extends ConsumerWidget {
  const CoursScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tasks = ref.watch(tachesProvider).value ?? const <Task>[];
    return Scaffold(
      appBar: AppBar(title: const Text('Mes cours')),
      body: ref
          .watch(coursProvider)
          .when(
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(
              error: error,
              onRetry: () => ref.invalidate(coursProvider),
            ),
            data: (courses) => ListView.separated(
              padding: const EdgeInsets.all(Spacing.m),
              itemCount: courses.length,
              separatorBuilder: (_, _) => const SizedBox(height: Spacing.s),
              itemBuilder: (context, index) {
                final course = courses[index];
                final remaining = tasks
                    .where((t) => t.courseId == course.id && !t.isDone)
                    .length;
                return Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.secondaryContainer,
                      foregroundColor: theme.colorScheme.onSecondaryContainer,
                      child: const Icon(Icons.school_outlined),
                    ),
                    title: Text(
                      course.name,
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '${course.teacher} · ${course.credits} crédits',
                    ),
                    trailing: Text(
                      remaining <= 1 ? '$remaining tâche' : '$remaining tâches',
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }
}

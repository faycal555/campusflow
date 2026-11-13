import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/task_utils.dart';

/// Contenu du détail d'une tâche, partagé par l'écran Détail et la vue tablette.
class TaskDetailView extends StatelessWidget {
  final Task task;
  final String courseName;
  final VoidCallback onToggleDone;
  final VoidCallback? onDelete;

  const TaskDetailView({
    super.key,
    required this.task,
    required this.courseName,
    required this.onToggleDone,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = theme.extension<StatusColors>()!;
    final late = task.isLate();
    final (statusLabel, statusColor) = task.isDone
        ? ('Faite', status.done)
        : late
        ? ('En retard', status.late)
        : ('À faire', theme.colorScheme.onSurface);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(Spacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: Spacing.s),
                  Chip(
                    label: Text(courseName),
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                    side: BorderSide.none,
                  ),
                  const SizedBox(height: Spacing.m),
                  _InfoRow(
                    icon: Icons.event,
                    label: 'Échéance',
                    value: formatDueDateLong(task.dueDate),
                  ),
                  const SizedBox(height: Spacing.m),
                  _InfoRow(
                    icon: Icons.flag_outlined,
                    label: 'Statut',
                    value: statusLabel,
                    valueColor: statusColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.l),
          FilledButton.icon(
            onPressed: onToggleDone,
            icon: Icon(task.isDone ? Icons.undo : Icons.check),
            label: Text(
              task.isDone ? 'Marquer comme à faire' : 'Marquer comme fait',
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(height: Spacing.s),
            OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Supprimer'),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: Spacing.m),
        // Expanded évite le débordement (« RenderFlex overflowed ») des textes longs.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

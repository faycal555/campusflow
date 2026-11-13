import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/task_utils.dart';

/// Ligne de la liste des échéances (composant « carte de tâche » du design system).
class TaskTile extends StatelessWidget {
  final Task task;
  final String courseName;
  final bool selected;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;

  const TaskTile({
    super.key,
    required this.task,
    required this.courseName,
    required this.onTap,
    required this.onToggle,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = theme.extension<StatusColors>()!;
    final late = task.isLate();

    final subtitle = late
        ? '$courseName · ${formatDueDate(task.dueDate)} · En retard'
        : '$courseName · ${formatDueDate(task.dueDate)}';

    return ListTile(
      minTileHeight: 60,
      selected: selected,
      selectedTileColor: theme.colorScheme.secondaryContainer,
      leading: Checkbox(
        shape: const CircleBorder(),
        value: task.isDone,
        activeColor: status.done,
        onChanged: (value) => onToggle(value ?? false),
      ),
      title: Text(
        task.title,
        style: theme.textTheme.titleMedium?.copyWith(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
          color: task.isDone ? status.done : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: late ? status.late : theme.colorScheme.onSurfaceVariant,
          fontWeight: late ? FontWeight.w600 : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

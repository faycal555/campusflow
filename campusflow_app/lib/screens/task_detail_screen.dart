import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';

import '../widgets/task_detail_view.dart';

/// Écran Détail d'une tâche.
class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final String courseName;
  final ValueChanged<Task> onChanged;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.courseName,
    required this.onChanged,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Task _task = widget.task;

  void _toggleDone() {
    setState(() => _task = _task.copyWith(isDone: !_task.isDone));
    widget.onChanged(_task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: TaskDetailView(
        task: _task,
        courseName: widget.courseName,
        onToggleDone: _toggleDone,
      ),
    );
  }
}

import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../utils/task_utils.dart';
import '../widgets/task_detail_view.dart';

/// Écran Détail d'une tâche (route /taches/:id).
class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  // Provisoire : copie locale des données, non partagée avec la liste.
  late Task? _task = buildSampleTasks()
      .where((t) => t.id == widget.taskId)
      .firstOrNull;

  @override
  Widget build(BuildContext context) {
    final task = _task;
    return Scaffold(
      appBar: AppBar(title: const Text('Détail')),
      body: task == null
          ? Center(child: Text('Tâche « ${widget.taskId} » introuvable'))
          : TaskDetailView(
              task: task,
              courseName: courseName(sampleCourses, task.courseId),
              onToggleDone: () =>
                  setState(() => _task = task.copyWith(isDone: !task.isDone)),
            ),
    );
  }
}

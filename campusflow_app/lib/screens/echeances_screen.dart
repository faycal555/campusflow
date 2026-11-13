import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/sample_data.dart';
import '../router/app_router.dart';
import '../utils/task_utils.dart';
import '../widgets/task_detail_view.dart';
import '../widgets/task_tile.dart';

/// Largeur à partir de laquelle on affiche la liste et le détail côte à côte.
const tabletBreakpoint = 840.0;

/// Écran Échéances : liste des tâches triées par date.
class EcheancesScreen extends StatefulWidget {
  const EcheancesScreen({super.key});

  @override
  State<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends State<EcheancesScreen> {
  List<Task> _tasks = buildSampleTasks();
  String? _selectedId;

  List<Task> get _sortedTasks =>
      [..._tasks]..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  void _toggle(Task task, bool done) {
    setState(() {
      _tasks = [
        for (final t in _tasks) t.id == task.id ? t.copyWith(isDone: done) : t,
      ];
    });
  }

  void _openDetail(Task task) => context.push(Routes.tache(task.id));

  void _openForm() => context.push(Routes.nouvelleTache);

  Widget _buildList(List<Task> tasks, {required bool wide}) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskTile(
          task: task,
          courseName: courseName(sampleCourses, task.courseId),
          selected: wide && task.id == _selectedId,
          // Sur tablette, la sélection remplit le panneau de droite.
          onTap: wide
              ? () => setState(() => _selectedId = task.id)
              : () => _openDetail(task),
          onToggle: (done) => _toggle(task, done),
        );
      },
    );
  }

  Widget _buildDetailPane(List<Task> tasks) {
    final selected = tasks.where((t) => t.id == _selectedId).firstOrNull;
    if (selected == null) {
      return const Center(child: Text('Sélectionnez une tâche'));
    }
    return TaskDetailView(
      task: selected,
      courseName: courseName(sampleCourses, selected.courseId),
      onToggleDone: () => _toggle(selected, !selected.isDone),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _sortedTasks;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes échéances')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < tabletBreakpoint) {
            return _buildList(tasks, wide: false);
          }
          // Au-dessus de 840 dp : liste et détail côte à côte.
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 400, child: _buildList(tasks, wide: true)),
              const VerticalDivider(width: 1),
              Expanded(child: _buildDetailPane(tasks)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter une tâche',
        onPressed: _openForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}

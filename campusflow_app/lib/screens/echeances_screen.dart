import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../utils/task_utils.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

/// Écran Échéances : liste des tâches triées par date.
class EcheancesScreen extends StatefulWidget {
  const EcheancesScreen({super.key});

  @override
  State<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends State<EcheancesScreen> {
  List<Task> _tasks = buildSampleTasks();
  int _navIndex = 0;

  List<Task> get _sortedTasks =>
      [..._tasks]..sort((a, b) => a.dueDate.compareTo(b.dueDate));

  void _toggle(Task task, bool done) {
    setState(() {
      _tasks = [
        for (final t in _tasks) t.id == task.id ? t.copyWith(isDone: done) : t,
      ];
    });
  }

  void _openDetail(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          task: task,
          courseName: courseName(sampleCourses, task.courseId),
          onChanged: (updated) => _toggle(updated, updated.isDone),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _sortedTasks;
    return Scaffold(
      appBar: AppBar(title: const Text('Mes échéances')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return TaskTile(
            task: task,
            courseName: courseName(sampleCourses, task.courseId),
            onTap: () => _openDetail(task),
            onToggle: (done) => _toggle(task, done),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter une tâche',
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Tâches'),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            label: 'Cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

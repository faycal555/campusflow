import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import '../state/taches_notifier.dart';
import '../utils/task_utils.dart';
import '../widgets/task_detail_view.dart';
import '../widgets/task_tile.dart';

/// Largeur à partir de laquelle on affiche la liste et le détail côte à côte.
const tabletBreakpoint = 840.0;

/// Écran Échéances : liste des tâches triées par date.
class EcheancesScreen extends ConsumerStatefulWidget {
  const EcheancesScreen({super.key});

  @override
  ConsumerState<EcheancesScreen> createState() => _EcheancesScreenState();
}

class _EcheancesScreenState extends ConsumerState<EcheancesScreen> {
  // Sélection locale à l'écran (vue tablette) : pas besoin de la partager.
  String? _selectedId;

  // ref.read dans les gestionnaires d'action.
  void _cocher(Task task) => ref.read(tachesProvider.notifier).cocher(task.id);

  Widget _buildList(
    List<Task> tasks,
    List<Course> courses, {
    required bool wide,
  }) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskTile(
          task: task,
          courseName: courseName(courses, task.courseId),
          selected: wide && task.id == _selectedId,
          // Sur tablette, la sélection remplit le panneau de droite.
          onTap: wide
              ? () => setState(() => _selectedId = task.id)
              : () => context.push(Routes.tache(task.id)),
          onToggle: (_) => _cocher(task),
        );
      },
    );
  }

  Widget _buildDetailPane(List<Task> tasks, List<Course> courses) {
    final selected = tasks.where((t) => t.id == _selectedId).firstOrNull;
    if (selected == null) {
      return const Center(child: Text('Sélectionnez une tâche'));
    }
    return TaskDetailView(
      task: selected,
      courseName: courseName(courses, selected.courseId),
      onToggleDone: () => _cocher(selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch dans build : l'écran se reconstruit quand la liste change.
    final tasks = [...ref.watch(tachesProvider)]
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final courses = ref.watch(coursProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mes échéances')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < tabletBreakpoint) {
            return _buildList(tasks, courses, wide: false);
          }
          // Au-dessus de 840 dp : liste et détail côte à côte.
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 400,
                child: _buildList(tasks, courses, wide: true),
              ),
              const VerticalDivider(width: 1),
              Expanded(child: _buildDetailPane(tasks, courses)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter une tâche',
        onPressed: () => context.push(Routes.nouvelleTache),
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/taches_notifier.dart';
import '../theme/app_theme.dart';
import '../utils/task_utils.dart';
import '../widgets/async_views.dart';

/// Formulaire de nouvelle tâche (route /taches/nouvelle).
///
/// Ajoute la tâche dans l'état partagé ; l'écran reste défilant pour ne pas
/// être masqué par le clavier.
class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String? _courseId;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      locale: const Locale('fr', 'FR'),
    );
    if (picked != null) {
      setState(
        () => _dueDate = DateTime(picked.year, picked.month, picked.day, 8),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final task = Task(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      title: _titleController.text.trim(),
      courseId: _courseId!,
      dueDate: _dueDate,
    );
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await ref.read(tachesProvider.notifier).ajouter(task);
      messenger.showSnackBar(
        SnackBar(content: Text('Tâche « ${task.title} » ajoutée')),
      );
      navigator.pop();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Impossible d'ajouter la tâche. ${describeError(e)}"),
        ),
      );
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final courses = ref.watch(coursProvider).value ?? const <Course>[];
    _courseId ??= courses.firstOrNull?.id;
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle tâche')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Titre *',
                  hintText: 'Ex. : TP Flutter',
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Le titre est obligatoire'
                    : null,
              ),
              const SizedBox(height: Spacing.m),
              DropdownButtonFormField<String>(
                initialValue: _courseId,
                decoration: const InputDecoration(labelText: 'Cours'),
                items: [
                  for (final course in courses)
                    DropdownMenuItem(
                      value: course.id,
                      child: Text(course.name),
                    ),
                ],
                onChanged: (value) => setState(() => _courseId = value),
                validator: (value) =>
                    value == null ? 'Choisissez un cours' : null,
              ),
              const SizedBox(height: Spacing.m),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date limite',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    formatDueDate(_dueDate),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.l),
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

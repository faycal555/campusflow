import 'package:campusflow_models/campusflow_models.dart';

import 'sample_data.dart';
import 'task_repository.dart';

/// Implémentation en mémoire, utilisée par les tests (aucun réseau).
class FakeTaskRepository implements TaskRepository {
  final Duration latency;
  List<Task> _tasks;
  int _nextId = 100;

  FakeTaskRepository({List<Task>? tasks, this.latency = Duration.zero})
    : _tasks = tasks ?? buildSampleTasks();

  Future<void> _wait() => Future.delayed(latency);

  @override
  Future<List<Task>> fetchAll() async {
    await _wait();
    return List.unmodifiable(_tasks);
  }

  @override
  Future<Task> create(Task task) async {
    await _wait();
    final saved = task.copyWith(id: 'f${_nextId++}');
    _tasks = [..._tasks, saved];
    return saved;
  }

  @override
  Future<Task> setDone(String id, {required bool done}) async {
    await _wait();
    final updated = _tasks.firstWhere((t) => t.id == id).copyWith(isDone: done);
    _tasks = [for (final t in _tasks) t.id == id ? updated : t];
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _wait();
    _tasks = _tasks.where((t) => t.id != id).toList();
  }
}

class FakeCourseRepository implements CourseRepository {
  @override
  Future<List<Course>> fetchAll() async => sampleCourses;
}

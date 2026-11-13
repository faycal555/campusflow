import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';
import 'api_repositories.dart';
import 'task_repository.dart';

/// Implémentations réelles par défaut ; les tests les remplacent par les Fake
/// avec `ProviderScope(overrides: [...])`.
final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => ApiTaskRepository(ref.watch(dioProvider)),
);

final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) => ApiCourseRepository(ref.watch(dioProvider)),
);

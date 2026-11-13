import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';

import 'task_repository.dart';

/// Implémentation qui appelle l'API REST (json-server).
class ApiTaskRepository implements TaskRepository {
  final Dio _dio;

  ApiTaskRepository(this._dio);

  @override
  Future<List<Task>> fetchAll() async {
    final response = await _dio.get<List<dynamic>>('/taches');
    return response.data!
        .map((json) => Task.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Task> create(Task task) async {
    // L'identifiant est attribué par le serveur.
    final body = task.toJson()..remove('id');
    final response = await _dio.post<Map<String, dynamic>>(
      '/taches',
      data: body,
    );
    return Task.fromJson(response.data!);
  }

  @override
  Future<Task> setDone(String id, {required bool done}) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/taches/$id',
      data: {'isDone': done},
    );
    return Task.fromJson(response.data!);
  }

  @override
  Future<void> delete(String id) => _dio.delete<void>('/taches/$id');
}

class ApiCourseRepository implements CourseRepository {
  final Dio _dio;

  ApiCourseRepository(this._dio);

  @override
  Future<List<Course>> fetchAll() async {
    final response = await _dio.get<List<dynamic>>('/cours');
    return response.data!
        .map((json) => Course.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

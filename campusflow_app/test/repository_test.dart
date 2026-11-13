import 'dart:convert';
import 'dart:typed_data';

import 'package:campusflow_app/data/api_repositories.dart';
import 'package:campusflow_app/data/fake_repositories.dart';
import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adaptateur HTTP qui répond sans réseau et mémorise les requêtes reçues.
class _FakeAdapter implements HttpClientAdapter {
  final List<RequestOptions> requests = [];
  final Object? Function(RequestOptions options) respond;

  _FakeAdapter(this.respond);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(respond(options)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('ApiTaskRepository', () {
    test('GET /taches est converti en objets Task', () async {
      final adapter = _FakeAdapter(
        (_) => [
          {
            'id': 't1',
            'title': 'TP',
            'courseId': 'c1',
            'dueDate': '2026-11-16T08:00:00.000',
            'isDone': false,
          },
        ],
      );
      final dio = Dio(BaseOptions(baseUrl: 'http://api'))
        ..httpClientAdapter = adapter;

      final tasks = await ApiTaskRepository(dio).fetchAll();

      expect(tasks.single.title, 'TP');
      expect(adapter.requests.single.path, '/taches');
    });

    test('POST sans id, PATCH isDone et DELETE sur /taches/:id', () async {
      final adapter = _FakeAdapter((o) {
        final body = o.data is Map ? Map<String, dynamic>.from(o.data) : {};
        return {
          'id': 'srv1',
          'title': 'TP',
          'courseId': 'c1',
          'dueDate': '2026-11-16T08:00:00.000',
          'isDone': false,
          ...body,
        };
      });
      final dio = Dio(BaseOptions(baseUrl: 'http://api'))
        ..httpClientAdapter = adapter;
      final repo = ApiTaskRepository(dio);

      final created = await repo.create(
        Task(id: '', title: 'TP', courseId: 'c1', dueDate: DateTime(2026)),
      );
      expect(created.id, 'srv1');
      expect(adapter.requests.last.method, 'POST');
      expect((adapter.requests.last.data as Map).containsKey('id'), isFalse);

      final done = await repo.setDone('srv1', done: true);
      expect(done.isDone, isTrue);
      expect(adapter.requests.last.method, 'PATCH');
      expect(adapter.requests.last.path, '/taches/srv1');

      await repo.delete('srv1');
      expect(adapter.requests.last.method, 'DELETE');
    });
  });

  test('FakeTaskRepository garde les données en mémoire', () async {
    final repo = FakeTaskRepository();
    final before = (await repo.fetchAll()).length;

    final created = await repo.create(
      Task(id: '', title: 'Nouvelle', courseId: 'c1', dueDate: DateTime(2026)),
    );
    await repo.setDone(created.id, done: true);
    expect((await repo.fetchAll()).length, before + 1);
    expect((await repo.fetchAll()).last.isDone, isTrue);

    await repo.delete(created.id);
    expect((await repo.fetchAll()).length, before);
  });
}

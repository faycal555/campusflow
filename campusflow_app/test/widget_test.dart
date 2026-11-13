import 'dart:typed_data';

import 'package:campusflow_app/core/auth_interceptor.dart';
import 'package:campusflow_app/core/token_storage.dart';
import 'package:campusflow_app/data/auth_repository.dart';
import 'package:campusflow_app/data/fake_repositories.dart';
import 'package:campusflow_app/data/repository_providers.dart';
import 'package:campusflow_app/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

Widget _app(TokenStorage storage) => ProviderScope(
  overrides: [
    tokenStorageProvider.overrideWithValue(storage),
    authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
    taskRepositoryProvider.overrideWithValue(FakeTaskRepository()),
    courseRepositoryProvider.overrideWithValue(FakeCourseRepository()),
  ],
  child: const CampusFlowApp(),
);

/// Adaptateur qui répond toujours avec le même statut HTTP.
class _StatusAdapter implements HttpClientAdapter {
  final int status;
  RequestOptions? last;

  _StatusAdapter(this.status);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    last = options;
    return ResponseBody.fromString(
      '{}',
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  testWidgets('Sans jeton, toute adresse mène à /login', (tester) async {
    await tester.pumpWidget(_app(MemoryTokenStorage()));
    await tester.pumpAndSettle();
    expect(find.text('CampusFlow'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Mes échéances'), findsNothing);
  });

  testWidgets('Mauvais mot de passe : message et pas de navigation', (
    tester,
  ) async {
    final storage = MemoryTokenStorage();
    await tester.pumpWidget(_app(storage));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'aminata@campus.bf',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'faux');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('E-mail ou mot de passe incorrect.'), findsOneWidget);
    expect(await tester.runAsync(storage.read), isNull);
  });

  testWidgets('Connexion : jeton rangé, puis déconnexion depuis le profil', (
    tester,
  ) async {
    final storage = MemoryTokenStorage();
    await tester.pumpWidget(_app(storage));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'aminata@campus.bf',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'campus2026');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();
    expect(find.text('Mes échéances'), findsOneWidget);
    expect(await tester.runAsync(storage.read), 'fake-token');

    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Aminata Ouédraogo'), findsOneWidget);
    await tester.tap(find.text('Se déconnecter'));
    await tester.pumpAndSettle();
    expect(find.text('Se connecter'), findsOneWidget);
    expect(await tester.runAsync(storage.read), isNull);
  });

  testWidgets('Un jeton déjà rangé ouvre directement les échéances', (
    tester,
  ) async {
    await tester.pumpWidget(_app(MemoryTokenStorage('fake-token')));
    await tester.pumpAndSettle();
    expect(find.text('Mes échéances'), findsOneWidget);
  });

  group('AuthInterceptor', () {
    test('ajoute « Authorization: Bearer <jeton> » à chaque requête', () async {
      final adapter = _StatusAdapter(200);
      final dio = Dio(BaseOptions(baseUrl: 'http://api'))
        ..httpClientAdapter = adapter
        ..interceptors.add(
          AuthInterceptor(
            storage: MemoryTokenStorage('abc'),
            onUnauthorized: () {},
          ),
        );
      await dio.get<void>('/taches');
      expect(adapter.last!.headers['Authorization'], 'Bearer abc');
    });

    test('signale un 401, sauf sur /login', () async {
      var calls = 0;
      final dio = Dio(BaseOptions(baseUrl: 'http://api'))
        ..httpClientAdapter = _StatusAdapter(401)
        ..interceptors.add(
          AuthInterceptor(
            storage: MemoryTokenStorage('expiré'),
            onUnauthorized: () => calls++,
          ),
        );

      await expectLater(dio.get<void>('/taches'), throwsA(isA<DioException>()));
      expect(calls, 1);

      await expectLater(dio.post<void>('/login'), throwsA(isA<DioException>()));
      expect(calls, 1);
    });
  });
}

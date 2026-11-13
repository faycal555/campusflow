import 'package:campusflow_models/campusflow_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_client.dart';

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}

/// Contrat d'authentification.
abstract interface class AuthRepository {
  /// Renvoie le jeton, ou lève [InvalidCredentialsException].
  Future<String> login(String email, String password);

  Future<void> logout();

  Future<User> me();
}

class ApiAuthRepository implements AuthRepository {
  final Dio _dio;

  ApiAuthRepository(this._dio);

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/login',
        data: {'email': email, 'password': password},
      );
      return response.data!['token'] as String;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const InvalidCredentialsException();
      }
      rethrow;
    }
  }

  @override
  Future<void> logout() => _dio.post<void>('/logout');

  @override
  Future<User> me() async {
    final response = await _dio.get<Map<String, dynamic>>('/me');
    return User.fromJson(response.data!);
  }
}

/// Implémentation en mémoire pour les tests.
class FakeAuthRepository implements AuthRepository {
  static const user = User(
    id: 'u1',
    name: 'Aminata Ouédraogo',
    email: 'aminata@campus.bf',
  );

  @override
  Future<String> login(String email, String password) async {
    if (email == user.email && password == 'campus2026') return 'fake-token';
    throw const InvalidCredentialsException();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<User> me() async => user;
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => ApiAuthRepository(ref.watch(dioProvider)),
);

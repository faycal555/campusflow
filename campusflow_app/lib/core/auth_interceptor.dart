import 'package:dio/dio.dart';

import 'token_storage.dart';

/// Ajoute le jeton à chaque requête et signale les réponses 401.
class AuthInterceptor extends Interceptor {
  final TokenStorage storage;

  /// Appelé quand le serveur refuse le jeton (absent, expiré ou révoqué).
  final void Function() onUnauthorized;

  AuthInterceptor({required this.storage, required this.onUnauthorized});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.read();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Un 401 sur /login signifie « mauvais identifiants », pas « session expirée ».
    final isLogin = err.requestOptions.path == '/login';
    if (err.response?.statusCode == 401 && !isLogin) {
      onUnauthorized();
    }
    handler.next(err);
  }
}

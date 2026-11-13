import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Où le jeton d'authentification est rangé.
abstract interface class TokenStorage {
  Future<String?> read();
  Future<void> write(String token);
  Future<void> clear();
}

/// Stockage sécurisé : Keystore sur Android, Keychain sur iOS.
/// Le jeton n'est jamais écrit en clair (pas de SharedPreferences).
class SecureTokenStorage implements TokenStorage {
  static const _key = 'campusflow_token';
  final FlutterSecureStorage _storage;

  const SecureTokenStorage([this._storage = const FlutterSecureStorage()]);

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String token) => _storage.write(key: _key, value: token);

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

/// Stockage en mémoire pour les tests.
class MemoryTokenStorage implements TokenStorage {
  String? _token;

  MemoryTokenStorage([this._token]);

  @override
  Future<String?> read() async => _token;

  @override
  Future<void> write(String token) async => _token = token;

  @override
  Future<void> clear() async => _token = null;
}

final tokenStorageProvider = Provider<TokenStorage>(
  (ref) => const SecureTokenStorage(),
);

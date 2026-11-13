import 'package:campusflow_models/campusflow_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/token_storage.dart';
import '../data/auth_repository.dart';
import 'taches_notifier.dart';

/// État de connexion : le jeton courant, ou null si personne n'est connecté.
class AuthNotifier extends AsyncNotifier<String?> {
  /// Message à afficher sur l'écran de connexion (session expirée…).
  String? message;

  @override
  Future<String?> build() => ref.read(tokenStorageProvider).read();

  Future<void> login(String email, String password) async {
    final token = await ref.read(authRepositoryProvider).login(email, password);
    await ref.read(tokenStorageProvider).write(token);
    message = null;
    _resetData();
    state = AsyncData(token);
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (_) {
      // Déconnexion locale même si le serveur est injoignable.
    }
    await _clear();
  }

  /// Le serveur a répondu 401 : le jeton n'est plus valide.
  Future<void> expire() async {
    if (state.value == null) return;
    message = 'Votre session a expiré. Reconnectez-vous.';
    await _clear();
  }

  Future<void> _clear() async {
    await ref.read(tokenStorageProvider).clear();
    _resetData();
    state = const AsyncData(null);
  }

  /// Les données d'une session ne doivent pas survivre à un changement d'utilisateur.
  void _resetData() {
    ref
      ..invalidate(tachesProvider)
      ..invalidate(coursProvider)
      ..invalidate(currentUserProvider);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, String?>(
  AuthNotifier.new,
);

/// Utilisateur connecté (GET /me).
final currentUserProvider = FutureProvider.autoDispose<User>(
  (ref) => ref.watch(authRepositoryProvider).me(),
  retry: (_, _) => null,
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/app_shell.dart';
import '../screens/cours_screen.dart';
import '../screens/echeances_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profil_screen.dart';
import '../screens/task_detail_screen.dart';
import '../screens/task_form_screen.dart';
import '../state/auth_notifier.dart';

/// Adresses de l'application.
abstract final class Routes {
  static const login = '/login';
  static const taches = '/taches';
  static const nouvelleTache = '/taches/nouvelle';
  static String tache(String id) => '/taches/$id';
  static const cours = '/cours';
  static const profil = '/profil';
}

final routerProvider = Provider<GoRouter>((ref) {
  // Prévient GoRouter à chaque changement de session pour réévaluer `redirect`.
  final authState = ValueNotifier<AsyncValue<String?>>(ref.read(authProvider));
  ref.listen(authProvider, (_, next) => authState.value = next);

  final router = GoRouter(
    // Pendant la lecture du jeton, on reste sur /login ; la redirection
    // ouvre /taches dès qu'un jeton valide est trouvé.
    initialLocation: Routes.login,
    refreshListenable: authState,
    redirect: (context, state) {
      final auth = authState.value;
      if (auth.isLoading && !auth.hasValue) return null;
      final loggedIn = auth.value != null;
      final onLogin = state.matchedLocation == Routes.login;
      // Pas de jeton (absent, ou refusé par un 401) : écran de connexion.
      if (!loggedIn) return onLogin ? null : Routes.login;
      if (onLogin) return Routes.taches;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // La barre de navigation est commune à tous les écrans du ShellRoute.
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: Routes.taches,
            builder: (context, state) => const EcheancesScreen(),
            routes: [
              // « nouvelle » doit être déclarée avant « :id » pour ne pas être
              // prise pour un identifiant.
              GoRoute(
                path: 'nouvelle',
                builder: (context, state) => const TaskFormScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    TaskDetailScreen(taskId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: Routes.cours,
            builder: (context, state) => const CoursScreen(),
          ),
          GoRoute(
            path: Routes.profil,
            builder: (context, state) => const ProfilScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page introuvable')),
      body: Center(child: Text("L'adresse ${state.uri} n'existe pas.")),
    ),
  );

  ref.onDispose(() {
    authState.dispose();
    router.dispose();
  });
  return router;
});

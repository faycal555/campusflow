import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/sample_data.dart';
import '../screens/app_shell.dart';
import '../screens/cours_screen.dart';
import '../screens/echeances_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profil_screen.dart';
import '../screens/task_detail_screen.dart';
import '../screens/task_form_screen.dart';

/// Adresses de l'application.
abstract final class Routes {
  static const login = '/login';
  static const taches = '/taches';
  static const nouvelleTache = '/taches/nouvelle';
  static String tache(String id) => '/taches/$id';
  static const cours = '/cours';
  static const profil = '/profil';
}

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: Routes.login,
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
                // Provisoire : sans état partagé, la tâche créée n'est pas
                // encore visible dans la liste (voir TachesNotifier).
                builder: (context, state) => TaskFormScreen(
                  courses: sampleCourses,
                  onSubmit: (_) async {},
                ),
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
}

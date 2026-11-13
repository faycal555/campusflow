import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/auth_notifier.dart';
import '../theme/app_theme.dart';
import '../widgets/async_views.dart';

/// Écran Profil (route /profil) : utilisateur connecté (GET /me).
class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ref
          .watch(currentUserProvider)
          .when(
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(
              error: error,
              onRetry: () => ref.invalidate(currentUserProvider),
            ),
            data: (user) => ListView(
              padding: const EdgeInsets.all(Spacing.m),
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                  child: Text(
                    user.name.characters.first,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: Spacing.m),
                Text(
                  user.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  user.email,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                OutlinedButton.icon(
                  // La redirection du routeur renvoie vers /login.
                  onPressed: () => ref.read(authProvider.notifier).logout(),
                  icon: const Icon(Icons.logout),
                  label: const Text('Se déconnecter'),
                ),
              ],
            ),
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../router/app_router.dart';
import '../theme/app_theme.dart';

/// Écran de connexion (route /login).
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateFormat.yMMMMEEEEd('fr_FR').format(DateTime.now());
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(Spacing.l),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/logo.png', width: 96, height: 96),
                  const SizedBox(height: Spacing.l),
                  Text('CampusFlow', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: Spacing.s),
                  Text(
                    'Vos cours et échéances, au même endroit',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    today,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),
                  FilledButton(
                    onPressed: () => context.go(Routes.taches),
                    child: const Text('Se connecter'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

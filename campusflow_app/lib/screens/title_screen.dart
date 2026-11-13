import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Écran de titre de la séance 4 : il ne lit que des valeurs du thème.
class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('CampusFlow', style: theme.textTheme.headlineSmall),
                const SizedBox(height: Spacing.s),
                Text(
                  'Vos cours et échéances, au même endroit',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                FilledButton(onPressed: () {}, child: const Text('Commencer')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

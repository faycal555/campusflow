import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Message lisible pour une erreur réseau ou de données.
String describeError(Object error) {
  if (error is DioException) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        'Serveur injoignable. Vérifiez votre connexion.',
      DioExceptionType.badResponse =>
        'Le serveur a répondu ${error.response?.statusCode}.',
      _ => 'Erreur réseau.',
    };
  }
  if (error is FormatException) return 'Données reçues invalides.';
  return 'Une erreur est survenue.';
}

/// État « erreur » avec un bouton Réessayer.
class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: Spacing.m),
            Text(
              describeError(error),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: Spacing.l),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}

/// État « chargement ».
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

/// Exécute une action asynchrone (POST, PATCH, DELETE) et affiche un SnackBar
/// en cas d'échec ou de succès.
Future<bool> runAction(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await action();
    if (success != null) {
      messenger.showSnackBar(SnackBar(content: Text(success)));
    }
    return true;
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(describeError(e))));
    return false;
  }
}

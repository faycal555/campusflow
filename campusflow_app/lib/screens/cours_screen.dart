import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_theme.dart';

/// Écran « Mes cours » (route /cours).
class CoursScreen extends StatelessWidget {
  const CoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mes cours')),
      body: ListView.separated(
        padding: const EdgeInsets.all(Spacing.m),
        itemCount: sampleCourses.length,
        separatorBuilder: (_, _) => const SizedBox(height: Spacing.s),
        itemBuilder: (context, index) {
          final course = sampleCourses[index];
          return Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.secondaryContainer,
                foregroundColor: theme.colorScheme.onSecondaryContainer,
                child: const Icon(Icons.school_outlined),
              ),
              title: Text(course.name, style: theme.textTheme.titleMedium),
              subtitle: Text('${course.teacher} · ${course.credits} crédits'),
            ),
          );
        },
      ),
    );
  }
}

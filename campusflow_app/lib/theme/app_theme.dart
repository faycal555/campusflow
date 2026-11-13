import 'package:flutter/material.dart';

/// Couleurs du design system v1 (docs/seance2/04-design-system-v1.md).
///
/// C'est le seul endroit de l'application où des couleurs sont écrites en dur :
/// les widgets les lisent dans le thème.
abstract final class AppColors {
  static const primary = Color(0xFF1D4ED8);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFDBEAFE);
  static const onSecondaryContainer = Color(0xFF1E3A8A);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceContainer = Color(0xFFF3F4F6);
  static const onSurface = Color(0xFF1F2937);
  static const onSurfaceVariant = Color(0xFF4B5563);
  static const error = Color(0xFFB91C1C);
  static const success = Color(0xFF15803D);
}

/// Couleurs propres à CampusFlow, absentes du ColorScheme Material.
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  final Color done;
  final Color late;

  const StatusColors({required this.done, required this.late});

  @override
  StatusColors copyWith({Color? done, Color? late}) =>
      StatusColors(done: done ?? this.done, late: late ?? this.late);

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other == null) return this;
    return StatusColors(
      done: Color.lerp(done, other.done, t)!,
      late: Color.lerp(late, other.late, t)!,
    );
  }
}

abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.primary,
      onSecondary: AppColors.onPrimary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      error: AppColors.error,
      onError: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHighest: AppColors.surfaceContainer,
      outlineVariant: Color(0xFFE5E7EB),
    );

    // Roboto est la police système d'Android : rien à télécharger.
    const textTheme = TextTheme(
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(
        bodyColor: AppColors.onSurface,
        displayColor: AppColors.onSurface,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.secondaryContainer,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.onSurface,
        behavior: SnackBarBehavior.floating,
      ),
      extensions: const [
        StatusColors(done: AppColors.success, late: AppColors.error),
      ],
    );
  }
}

/// Espacements de la grille de 4 dp.
abstract final class Spacing {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 16.0;
  static const l = 24.0;
  static const xl = 32.0;
}

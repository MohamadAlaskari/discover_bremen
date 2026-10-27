import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text.dart';

/// The Material 3 theme, built from the Figma tokens.
///
/// Buttons, snackbar, text field and dialogs get their Figma look here once,
/// so the screens can use plain FilledButton, TextButton and SnackBar.
abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      primary: AppColors.brand,
      onPrimary: AppColors.surface,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
    );

    // Figma "Button": height 52, radius 16, Label/Large, 20 px icon.
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    );
    const buttonSize = Size(64, 52);
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.md,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvas,
      textTheme: const TextTheme(
        displayLarge: AppText.displayLarge,
        headlineMedium: AppText.headlineMedium,
        titleLarge: AppText.titleLarge,
        titleMedium: AppText.titleMedium,
        bodyLarge: AppText.bodyLarge,
        bodyMedium: AppText.bodyMedium,
        labelLarge: AppText.labelLarge,
        labelMedium: AppText.labelMedium,
        labelSmall: AppText.labelSmall,
      ).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),

      // Primary button: brand red, darker while pressed (Primary/Pressed).
      filledButtonTheme: FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
              foregroundColor: AppColors.surface,
              disabledBackgroundColor: AppColors.brand.withValues(alpha: 0.38),
              disabledForegroundColor: AppColors.surface,
              minimumSize: buttonSize,
              padding: buttonPadding,
              shape: buttonShape,
              textStyle: AppText.labelLarge,
              iconSize: 20,
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.pressed)
                    ? AppColors.brandPressed
                    : AppColors.brand,
              ),
            ),
      ),
      // Secondary button: white with a strong border.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
          minimumSize: buttonSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: AppText.labelLarge,
          iconSize: 20,
        ),
      ),
      // Text button: no background, brand text, less side padding.
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brand,
          minimumSize: const Size(AppSpacing.xxxl, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          shape: buttonShape,
          textStyle: AppText.labelLarge,
          iconSize: 20,
        ),
      ),

      // Figma "Snackbar": dark ink bar, pink UNDO, floats 16 px from the edges.
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.night,
        contentTextStyle: AppText.bodyMedium.copyWith(color: AppColors.onNight),
        actionTextColor: AppColors.inverseAction,
        elevation: 6,
        insetPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),

      // Figma "Text Field" (name on onboarding): white, radius 12, red when focused.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppText.bodyLarge.copyWith(color: AppColors.textSecondary),
        prefixIconColor: AppColors.textPrimary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.brand, width: 2),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.brand,
        selectionColor: AppColors.brand.withValues(alpha: 0.25),
        selectionHandleColor: AppColors.brand,
      ),

      // The About dialog sits on the cream canvas like the rest of the app.
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.canvas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
    );
  }
}

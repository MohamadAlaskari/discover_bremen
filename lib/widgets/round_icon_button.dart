import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

/// Figma "Icon Button" styles.
enum RoundButtonVariant {
  /// White with a shadow: floats over the details hero.
  surface,

  /// No background: Home top bar.
  ghost,

  /// White 15 %: on the night concert screen.
  onBrand,
}

/// 48 × 48 round icon button, the Material minimum touch target
/// (Figma "Icon Button").
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.variant = RoundButtonVariant.ghost,
  });

  /// A widget, so the sound toggle can animate between two icons.
  final Widget icon;

  /// Read by screen readers and shown on long press.
  final String tooltip;
  final VoidCallback onPressed;
  final RoundButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (variant) {
      RoundButtonVariant.surface => (AppColors.surface, AppColors.textPrimary),
      RoundButtonVariant.ghost => (Colors.transparent, AppColors.textPrimary),
      RoundButtonVariant.onBrand => (
        AppColors.onBrandSubtle,
        AppColors.surface,
      ),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: variant == RoundButtonVariant.surface
            ? AppShadows.elevation2
            : null,
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: icon,
        style: IconButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          fixedSize: const Size.square(AppSpacing.xxxl),
          iconSize: 24,
        ),
      ),
    );
  }
}

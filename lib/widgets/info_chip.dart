import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Colour set of an [InfoChip] (Figma "Chip" tones).
enum ChipTone { neutral, brand, success, onBrand }

/// Small pill with an icon and a label (Figma "Chip"): the facts on the
/// details and Read-more screens, "Visited today", the distances of nearby
/// sights, "To Bremen" and "Tap the coin".
class InfoChip extends StatelessWidget {
  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.tone = ChipTone.neutral,
  });

  final IconData icon;
  final String label;
  final ChipTone tone;

  @override
  Widget build(BuildContext context) {
    final (background, iconColor, textColor) = switch (tone) {
      // As in Figma, the location pin keeps its ink colour; the other icons
      // are as soft as the text.
      ChipTone.neutral => (
        AppColors.surface,
        icon == Icons.place ? AppColors.textPrimary : AppColors.textSecondary,
        AppColors.textSecondary,
      ),
      // Route info ("Stop 2 · ≈ 350 m", "Finale").
      ChipTone.brand => (
        AppColors.brandSubtle,
        AppColors.brand,
        AppColors.brand,
      ),
      ChipTone.success => (
        AppColors.successSubtle,
        AppColors.success,
        AppColors.success,
      ),
      ChipTone.onBrand => (
        AppColors.onBrandSubtle,
        AppColors.surface,
        AppColors.surface,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: ShapeDecoration(
        color: background,
        shape: StadiumBorder(
          side: tone == ChipTone.neutral
              ? const BorderSide(color: AppColors.border)
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: AppSpacing.xxs),
          Flexible(
            child: Text(
              label,
              style: AppText.labelMedium.copyWith(color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

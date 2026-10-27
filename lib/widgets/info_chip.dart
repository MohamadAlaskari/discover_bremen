import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Colour set of an [InfoChip] (Figma "Chip" tones).
enum ChipTone { neutral, success, onBrand }

/// Small pill with an icon and a label (Figma "Chip"): the facts on the
/// details screen, "Visited today", "To Bremen" and "Tap the coin".
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
      ChipTone.neutral => (
        AppColors.surface,
        AppColors.textPrimary,
        AppColors.textSecondary,
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

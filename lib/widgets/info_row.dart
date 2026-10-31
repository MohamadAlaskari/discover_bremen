import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// One line of practical info (Figma "Info Row"): an icon, a small label and
/// the value under it. The value wraps, so a two-line address simply makes
/// the row taller instead of overlapping the next one.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    // Read as one sentence by screen readers: "Address, Sandstraße …".
    return MergeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            // As in Figma: the location pin in ink, other icons softer.
            color: icon == Icons.place
                ? AppColors.textPrimary
                : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppText.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(value, style: AppText.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

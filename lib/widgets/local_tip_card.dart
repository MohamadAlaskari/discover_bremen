import 'package:flutter/material.dart';

import '../data/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// A personal tip (Figma "Local Tip Card"): Card(color: AppColors.note)
/// with Icons.lightbulb. The Read-more screen reuses it as "Local tradition".
class LocalTipCard extends StatelessWidget {
  const LocalTipCard({
    super.key,
    required this.tip,
    this.title = 'Local tip from ${AppStrings.authorFirstName}',
  });

  final String tip;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.note,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  size: 20,
                  color: AppColors.iconNote,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: Text(title, style: AppText.labelLarge)),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(tip, style: AppText.bodyMedium),
          ],
        ),
      ),
    );
  }
}

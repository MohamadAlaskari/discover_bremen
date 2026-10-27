import 'package:flutter/material.dart';

import '../data/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// A personal tip on the details screen (Figma "Local Tip Card"):
/// Card(color: AppColors.note) with Icons.lightbulb.
class LocalTipCard extends StatelessWidget {
  const LocalTipCard({super.key, required this.tip});

  final String tip;

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
            const Row(
              children: [
                Icon(Icons.lightbulb, size: 20, color: AppColors.iconNote),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Local tip from ${AppStrings.authorFirstName}',
                    style: AppText.labelLarge,
                  ),
                ),
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

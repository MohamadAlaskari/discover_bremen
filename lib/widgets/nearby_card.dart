import 'package:flutter/material.dart';

import '../models/place_story.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import 'animal_badge.dart';
import 'coin.dart';
import 'info_chip.dart';

/// A sight near the stop (Figma "Nearby Card"): thumbnail, name, one line
/// and a distance chip.
///
/// Not tappable on purpose: it keeps the navigation simple (the route list is
/// the one way forward). The card grows with its text.
class NearbyCard extends StatelessWidget {
  const NearbyCard({super.key, required this.sight});

  final NearbySight sight;

  static const _thumbSize = 72.0;

  /// Badge and coin share one size inside the thumbnail.
  static const _thumbContent = 48.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: MergeSemantics(
        child: Row(
          children: [
            _thumbnail(),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sight.name, style: AppText.titleMedium),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    sight.line,
                    style: AppText.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  InfoChip(
                    icon: Icons.directions_walk,
                    label: sight.chip,
                    // Route info in brand red, plain distances neutral.
                    tone: sight.onRoute ? ChipTone.brand : ChipTone.neutral,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A route stop shows its animal, the Bremer Loch its coin, any other
  /// sight a Material icon.
  Widget _thumbnail() {
    final animal = sight.animal;
    final Widget content;
    if (animal != null) {
      content = AnimalBadge(animal: animal, size: _thumbContent);
    } else if (sight.isCoin) {
      content = const SizedBox.square(
        dimension: _thumbContent,
        child: FittedBox(child: Coin()),
      );
    } else {
      content = Icon(
        sight.icon ?? Icons.place,
        size: 24,
        color: AppColors.textSecondary,
      );
    }
    return Container(
      width: _thumbSize,
      height: _thumbSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: animal?.subtle ?? AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: ExcludeSemantics(child: content),
    );
  }
}

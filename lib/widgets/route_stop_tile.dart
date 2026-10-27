import 'package:flutter/material.dart';

import '../models/place.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import 'animal_badge.dart';
import 'dashed_line.dart';
import 'visited_stamp.dart';

/// Where a stop is on the walk.
enum StopStatus { upcoming, next, visited }

/// One stop on the route: the itemBuilder of the ListView.builder on Home
/// (Figma "Route Stop": Upcoming / Next / Visited).
///
/// Left is the rail with the stop number and the trail to the next stop
/// (dashed, solid green once visited). Right is the card: tap → details.
class RouteStopTile extends StatelessWidget {
  const RouteStopTile({
    super.key,
    required this.place,
    required this.status,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  final Place place;
  final StopStatus status;

  /// The first stop has no trail above, the last one no trail below.
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      // IntrinsicHeight lets the rail grow to the height of the card.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Rail(
              stop: place.id,
              status: status,
              trailAbove: !isFirst,
              trailBelow: !isLast,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _card()),
          ],
        ),
      ),
    );
  }

  Widget _card() {
    final visited = status == StopStatus.visited;
    final (
      borderColor,
      borderWidth,
      overlineColor,
      statusText,
    ) = switch (status) {
      StopStatus.upcoming => (
        AppColors.border,
        1.0,
        AppColors.textSecondary,
        'Not visited yet',
      ),
      StopStatus.next => (AppColors.brand, 1.5, AppColors.brand, 'Next stop'),
      StopStatus.visited => (
        AppColors.success,
        1.0,
        AppColors.success,
        'Visited',
      ),
    };
    final radius = BorderRadius.circular(AppRadius.lg);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // One screen reader node per card: "Stop 1 · Marktplatz, Town
        // Musicians, …, Visited, button".
        MergeSemantics(
          child: Semantics(
            button: true,
            value: statusText,
            child: Material(
              type: MaterialType.transparency,
              child: Ink(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: radius,
                  border: Border.all(color: borderColor, width: borderWidth),
                  boxShadow: AppShadows.elevation1,
                ),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: radius,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        AnimalBadge(
                          animal: place.animal,
                          heroTag: place.heroTag,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                place.overline.toUpperCase(),
                                style: AppText.overline.copyWith(
                                  color: overlineColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(place.shortName, style: AppText.titleMedium),
                              const SizedBox(height: 2),
                              Text(
                                place.teaser,
                                style: AppText.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Icon(
                          visited ? Icons.check_circle : Icons.chevron_right,
                          color: visited
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Small stamp over the top-right corner. It slams in when the user
        // comes back from marking the place.
        Positioned(
          top: -15,
          right: 0,
          child: VisitedStamp(visible: visited, compact: true),
        ),
      ],
    );
  }
}

/// Stop number and the trail between the stops.
class _Rail extends StatelessWidget {
  const _Rail({
    required this.stop,
    required this.status,
    required this.trailAbove,
    required this.trailBelow,
  });

  final int stop;
  final StopStatus status;
  final bool trailAbove;
  final bool trailBelow;

  /// Space above the marker, so it sits next to the badge.
  static const _trailAboveHeight = 30.0;
  static const _width = 32.0;

  @override
  Widget build(BuildContext context) {
    // Each half of the trail takes the colour of its own stop: the way out
    // of a visited stop is already walked (green), the rest is still dashed.
    final Widget trail = status == StopStatus.visited
        ? const ColoredBox(color: AppColors.success, child: SizedBox(width: 2))
        : const DashedLine(color: AppColors.borderStrong);

    return ExcludeSemantics(
      child: SizedBox(
        width: _width,
        child: Column(
          children: [
            if (trailAbove) SizedBox(height: _trailAboveHeight, child: trail),
            _marker(),
            if (trailBelow) Expanded(child: trail),
          ],
        ),
      ),
    );
  }

  Widget _marker() {
    final (fill, border, child) = switch (status) {
      StopStatus.visited => (
        AppColors.success,
        null,
        const Icon(Icons.check, size: 18, color: AppColors.surface),
      ),
      StopStatus.next => (
        AppColors.brand,
        Border.all(color: AppColors.brandSubtle, width: 4),
        Text(
          '$stop',
          style: AppText.labelLarge.copyWith(color: AppColors.surface),
        ),
      ),
      StopStatus.upcoming => (
        AppColors.surface,
        Border.all(color: AppColors.borderStrong, width: 1.5),
        Text(
          '$stop',
          style: AppText.labelLarge.copyWith(color: AppColors.textSecondary),
        ),
      ),
    };
    return Container(
      width: _width,
      height: _width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: fill,
        border: border,
      ),
      child: child,
    );
  }
}

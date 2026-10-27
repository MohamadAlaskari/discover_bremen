import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// The red "Visited" ink stamp (Figma "Stamp", sizes Small and Large).
///
/// When [visible] becomes true it slams down like a rubber stamp: it starts
/// 1.6× big, tilted the other way and a bit off to the top right, and lands
/// in 450 ms with Curves.easeInOutBack. When [visible] becomes false (UNDO),
/// the same move plays backwards.
class VisitedStamp extends StatelessWidget {
  const VisitedStamp({
    super.key,
    required this.visible,
    this.subtitle,
    this.compact = false,
  });

  final bool visible;

  /// Second line on the large stamp, e.g. "Bremen · Stop 1".
  final String? subtitle;

  /// The small stamp on a route card instead of the large one on details.
  final bool compact;

  // Figma counts rotation counter-clockwise, Flutter clockwise. Figma's
  // "10° → −12°" is therefore −10° → +12° here, which matches the Figma
  // frames. The small stamp rests at 10° clockwise, as in Figma.
  static const _startTurns = -10 / 360;
  static const _landedTurns = 12 / 360;
  static const _compactTurns = 10 / 360;

  /// Where the large stamp starts (Figma's hidden stamp), in stamp sizes.
  static const _startOffset = Offset(0.26, -1.32);

  @override
  Widget build(BuildContext context) {
    // Decoration only: the visited state is announced by the card and chip.
    return IgnorePointer(
      child: ExcludeSemantics(
        child: AnimatedSlide(
          offset: visible || compact ? Offset.zero : _startOffset,
          duration: AppMotion.stamp,
          curve: AppMotion.slam,
          child: AnimatedRotation(
            turns: compact
                ? _compactTurns
                : (visible ? _landedTurns : _startTurns),
            duration: AppMotion.stamp,
            curve: AppMotion.slam,
            child: AnimatedScale(
              scale: visible ? 1 : 1.6,
              duration: AppMotion.stamp,
              curve: AppMotion.slam,
              child: AnimatedOpacity(
                opacity: visible ? 1 : 0,
                duration: AppMotion.fast,
                child: compact ? _small() : _large(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Double red frame: outer border 3 px, inner border 1.5 px.
  Widget _large() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: AppColors.onBrandSoft,
        border: Border.all(color: AppColors.brand, width: 3),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.brand, width: 1.5),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'VISITED',
              style: AppText.stampLarge.copyWith(color: AppColors.brand),
            ),
            if (subtitle case final line?)
              Text(
                line.toUpperCase(),
                style: AppText.overline.copyWith(color: AppColors.brand),
              ),
          ],
        ),
      ),
    );
  }

  Widget _small() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.onBrandSoft,
        border: Border.all(color: AppColors.brand, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 3,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.brand),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'VISITED',
          style: AppText.stampSmall.copyWith(color: AppColors.brand),
        ),
      ),
    );
  }
}

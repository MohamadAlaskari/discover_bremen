import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

/// Figma "Page Dots": white dots, the active page is a wide pill. Used on
/// the brand-red onboarding and over the photos of the Read-more screen.
class PageDots extends StatelessWidget {
  const PageDots({
    super.key,
    required this.page,
    required this.count,
    this.overPhoto = false,
  });

  final int page;
  final int count;

  /// Over a photo the dots get a dark halo, so they stay visible on bright
  /// pictures too (Figma only shows tinted placeholders there).
  final bool overPhoto;

  static const _dot = 8.0;
  static const _activeWidth = 22.0;
  static const _gap = 6.0;
  static final _halo = [
    BoxShadow(
      color: AppColors.night.withValues(alpha: 0.7),
      blurRadius: 2,
      spreadRadius: 0.5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Page ${page + 1} of $count',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) const SizedBox(width: _gap),
            AnimatedContainer(
              duration: AppMotion.base,
              curve: AppMotion.standard,
              width: i == page ? _activeWidth : _dot,
              height: _dot,
              decoration: BoxDecoration(
                color: i == page ? AppColors.surface : AppColors.onBrandMuted,
                borderRadius: BorderRadius.circular(_dot / 2),
                boxShadow: overPhoto ? _halo : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

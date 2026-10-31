import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_motion.dart';

/// Figma "Page Dots": white dots, the active page is a wide pill. Used on
/// the brand-red onboarding and over the photos of the Read-more screen.
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.page, required this.count});

  final int page;
  final int count;

  static const _dot = 8.0;
  static const _activeWidth = 22.0;
  static const _gap = 6.0;

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
              ),
            ),
          ],
        ],
      ),
    );
  }
}

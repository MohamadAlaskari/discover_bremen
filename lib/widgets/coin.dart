import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// The euro coin (Figma "Coin", 56 px): rim, gold face, ring, € and shine.
///
/// The concert drops it into the Bremer Loch; the Read-more screen shows it
/// on the "Bremer Loch" nearby card. Wrap it in a FittedBox to change size.
class Coin extends StatelessWidget {
  const Coin({super.key});

  static const _size = 56.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _size,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.coinEdge,
              ),
            ),
          ),
          const Positioned.fill(
            left: 3,
            top: 3,
            right: 3,
            bottom: 3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.coin,
              ),
            ),
          ),
          const Positioned.fill(
            left: 8,
            top: 8,
            right: 8,
            bottom: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: AppColors.coinEdge, width: 1.5),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              '€',
              style: AppText.voiceCall.copyWith(
                fontSize: 24,
                height: 1,
                color: AppColors.coinEdge,
              ),
            ),
          ),
          // Light reflection on the top left.
          const Positioned(
            left: 10,
            top: 10,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(20 / 360),
              child: SizedBox(
                width: 16,
                height: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.onBrandFaded,
                    borderRadius: BorderRadius.all(Radius.elliptical(8, 4)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

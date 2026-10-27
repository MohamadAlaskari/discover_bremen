import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_text.dart';

/// The real "Bremer Loch" on the Marktplatz: a bronze manhole cover that is
/// a donation box (Figma "Bremer Loch").
///
/// Idle = waiting for a coin. Playing = the slot glows and three sound-wave
/// rings ripple out. It takes the size of its parent, so the concert screen
/// can shrink it smoothly with an AnimatedPositioned.
class BremerLoch extends StatefulWidget {
  const BremerLoch({super.key, required this.playing});

  final bool playing;

  @override
  State<BremerLoch> createState() => _BremerLochState();
}

class _BremerLochState extends State<BremerLoch>
    with SingleTickerProviderStateMixin {
  /// All Figma measurements are for a 220 px cover.
  static const _design = 220.0;

  /// One loop moves all three wave rings, a third of a loop apart.
  late final AnimationController _waves = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  );

  @override
  void initState() {
    super.initState();
    if (widget.playing) _waves.repeat();
  }

  @override
  void didUpdateWidget(BremerLoch oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The waves only run while the band plays.
    if (widget.playing && !_waves.isAnimating) _waves.repeat();
    if (!widget.playing) _waves.reset();
  }

  @override
  void dispose() {
    _waves.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Bremer Loch, a bronze donation box in the ground',
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest.shortestSide;
          return SizedBox.square(
            dimension: size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.playing)
                  for (var i = 0; i < 3; i++) _wave(size, i),
                // The cover is drawn at Figma size and scaled to fit.
                Positioned.fill(child: FittedBox(child: _cover())),
              ],
            ),
          );
        },
      ),
    );
  }

  /// A ring that grows from the rim to 1.5× and fades out.
  Widget _wave(double size, int index) {
    return AnimatedBuilder(
      animation: _waves,
      builder: (context, _) {
        final t = (_waves.value + index / 3) % 1;
        final diameter = size * (1 + 0.5 * t);
        final offset = (size - diameter) / 2;
        return Positioned(
          left: offset,
          top: offset,
          width: diameter,
          height: diameter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.coin.withValues(alpha: 0.5 * (1 - t)),
                width: 2 * size / _design,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _cover() {
    const center = _design / 2;
    // Eight rivets on a ring, 22.5° off the axes like on the real cover.
    const rivetRing = 94.0;
    const rivet = 7.0;
    final groove = Border.all(
      color: AppColors.bronzeLight.withValues(alpha: 0.55),
      width: 1.5,
    );

    return SizedBox.square(
      dimension: _design,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bronzeDark,
              ),
            ),
          ),
          Positioned.fill(
            left: 8,
            top: 8,
            right: 8,
            bottom: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bronze,
                border: Border.all(color: AppColors.bronzeLight, width: 2),
              ),
            ),
          ),
          for (final inset in [24.0, 52.0])
            Positioned.fill(
              left: inset,
              top: inset,
              right: inset,
              bottom: inset,
              child: DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, border: groove),
              ),
            ),
          for (var i = 0; i < 8; i++)
            Positioned(
              left: center + rivetRing * math.cos((22.5 + 45 * i) * math.pi / 180) - rivet / 2,
              top: center + rivetRing * math.sin((22.5 + 45 * i) * math.pi / 180) - rivet / 2,
              child: const SizedBox.square(
                dimension: rivet,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bronzeLight,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 66,
            left: 0,
            right: 0,
            child: Text(
              'BREMER LOCH',
              textAlign: TextAlign.center,
              style: AppText.overline.copyWith(color: AppColors.bronzeLight),
            ),
          ),
          // The coin slot glows gold while the band plays.
          Positioned(
            left: 74,
            top: 103,
            child: AnimatedContainer(
              duration: AppMotion.base,
              width: 72,
              height: 14,
              decoration: BoxDecoration(
                color: widget.playing ? AppColors.coin : AppColors.night,
                borderRadius: BorderRadius.circular(7),
                boxShadow: [
                  if (widget.playing)
                    BoxShadow(
                      color: AppColors.coin.withValues(alpha: 0.7),
                      blurRadius: 12,
                    ),
                ],
              ),
            ),
          ),
          // The four musicians, engraved in the bronze.
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                AppColors.bronzeLight,
                BlendMode.srcIn,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final animal in Animal.values)
                    SizedBox(
                      width: 34,
                      child: Text(
                        animal.emoji,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

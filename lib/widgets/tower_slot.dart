import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_shadows.dart';

/// One animal in the Musician Tower (Figma "Tower Slot", used on brand red).
///
/// Locked = the stop is not visited yet: a faded animal in a dashed ring.
/// Unlocked = the animal is free: a white disc pops in on top with
/// AnimatedScale (0.6 → 1, Curves.easeOutBack) and fades in.
class TowerSlot extends StatelessWidget {
  const TowerSlot({
    super.key,
    required this.animal,
    required this.unlocked,
    this.scale = 1,
  });

  final Animal animal;
  final bool unlocked;

  /// 1 = Home size. Onboarding, band complete and concert scale it.
  final double scale;

  /// Slot diameters from Figma: the tower gets narrower towards the top.
  static double sizeOf(Animal animal) => switch (animal) {
    Animal.donkey => 56,
    Animal.dog => 50,
    Animal.cat => 44,
    Animal.rooster => 40,
  };

  /// Emoji size relative to the slot (30 px in 56).
  static const _emojiRatio = 0.53;

  @override
  Widget build(BuildContext context) {
    final size = sizeOf(animal) * scale;
    final emoji = TextStyle(fontSize: size * _emojiRatio, height: 1);
    return Semantics(
      label:
          '${animal.label} (${animal.instrument}), '
          '${unlocked ? 'in your band' : 'not freed yet'}',
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Locked look. It stays underneath and is simply covered once
            // the animal is free, so the unlock can animate on top.
            CustomPaint(
              foregroundPainter: _DashedRingPainter(
                color: AppColors.onBrandFaded,
                strokeWidth: 1.5 * scale,
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onBrandSubtle,
                ),
                child: Center(
                  // A colour emoji ignores the text colour, so a colour
                  // filter turns it into the faded white silhouette.
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      AppColors.onBrandFaded,
                      BlendMode.srcIn,
                    ),
                    child: Text(animal.emoji, style: emoji),
                  ),
                ),
              ),
            ),
            // Unlocked look.
            AnimatedOpacity(
              opacity: unlocked ? 1 : 0,
              duration: AppMotion.base,
              child: AnimatedScale(
                scale: unlocked ? 1 : 0.6,
                duration: AppMotion.slow,
                curve: AppMotion.pop,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                    boxShadow: AppShadows.elevation1,
                  ),
                  child: Center(child: Text(animal.emoji, style: emoji)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashed circle on the inside edge of the slot (like Figma's dashed stroke).
class _DashedRingPainter extends CustomPainter {
  const _DashedRingPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  static const _dash = 4.0;
  static const _gap = 3.0;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );
    final count = (2 * math.pi * radius / (_dash + _gap)).floor();
    final step = 2 * math.pi / count;
    final sweep = step * _dash / (_dash + _gap);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (var i = 0; i < count; i++) {
      canvas.drawArc(rect, i * step, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
